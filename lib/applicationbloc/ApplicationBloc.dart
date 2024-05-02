// ignore: depend_on_referenced_packages
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:appointment_views/Api/doctorAccess.dart';
import 'package:appointment_views/Api/loginAccess.dart';
import 'package:appointment_views/Api/scheduleAccess.dart';
import 'package:appointment_views/applicationConfig.dart';
import 'package:appointment_views/applicationbloc/ApplicationEvents.dart';
import 'package:appointment_views/applicationbloc/ApplicationState.dart';
import 'package:appointment_views/models/PatientSchedule.dart';
import 'package:appointment_views/models/doctorModel.dart';
import 'package:appointment_views/models/loginResponse.dart';
import 'package:appointment_views/models/qrCodeConfigModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final connection = InternetConnection();
  ApplicationBloc() : super(ApplicationInitialState()) {
    List<PatientSchedule> schedulesInBloc = [];
    LoginResponseModel loginResp;

    String doctorID;
    DateTime selectedDate = DateTime.now();

    connection.onStatusChange.listen((InternetStatus status) {
      // Internet state checking
      if (status == InternetStatus.disconnected) {
        emit(NoInternetState());
      } else {
        //configuration Checking
        ReadConfiguration().then((result) async {
          if (result == false) {
            emit(QRCodeState());
          } else {
            if (ApplicationConfig.configStatus == ConfigStatus.notConfigured) {
              emit(QRCodeState());
            } else if (ApplicationConfig.configStatus ==
                ConfigStatus.configured) {
              emit(LoginPageState());
            } else if (ApplicationConfig.configStatus ==
                ConfigStatus.loggedIn) {
              ResultData result = ResultData.waiting;
              result = await refreshScheduler(
                  // doctorsInBloc,
                  selectedDate,
                  ApplicationConfig.DefaultDoctor,
                  // schedulesnIBloc,
                  result);
              if (result == ResultData.Success) {
                emit(ShedulerViewState(doctorsInBloc, schedulesnIBloc,
                    selectedDate, ApplicationConfig.DefaultDoctor));
              }
            }
          }
        }).catchError((error) {
          emit(MedicoPlusErrorState("Error", error.toString()));
        });

        on<RequestQRScanEvent>((event, emit) {
          emit(QRCodeState());
        });

        on<SearchEvent>((event, emit) {
          emit(LoginRequestingState());
        });
        on<LogoutEvent>((event, emit) async {
          // Perform logout actions here, such as clearing user session data
          // For example:
          // await clearUserSessionData();

          // Emit a state indicating that the user is logged out
          emit(LoginPageState());
        });

        on<LoginButtonPressed>((event, emit) async {
          // emit(LoginRequestingState());
          add(SearchEvent());
          String clinicId = ApplicationConfig.ClinicId;
          String username = event.userName;
          String password = event.password;

          try {
            var loginResult = await verifyLogin(
              int.parse(clinicId),
              username,
              password,
            );

            if (loginResult.resultType == 0) {
              loginResp = loginResult;
              selectedDate = DateTime.now().subtract(Duration(days: 1));
              // DateTime(2024, 04, 27);
              doctorID = loginResp.userEmpDocNo;
              saveToLocal("defaultDoctor", doctorID);

              ResultData result = ResultData.waiting;
              result = await refreshScheduler(
                // doctorsInBloc,
                selectedDate,
                doctorID,
                // schedulesnIBloc,
                result,
              );

              if (result == ResultData.Success) {
                emit(ShedulerViewState(
                  doctorsInBloc,
                  schedulesnIBloc,
                  selectedDate,
                  doctorID,
                ));
              } else {
                // Handle failure scenarios
              }
            } else {
              emit(LoginErrorState(loginResult.message));
            }
          } catch (e) {
            // Handle exceptions
          }
        });

        on<SearchScheduleEvent>((event, emit) async {
          {
            add(SearchEvent());
            ResultData result = ResultData.waiting;
            doctorID = event.employeeDocNo;
            selectedDate = event.searchDate;
            result = await refreshScheduler(
              // doctorsInBloc,
              event.searchDate,
              event.employeeDocNo,
              // schedulesnIBloc,
              result,
            );

            if (result == ResultData.Success) {
              emit(ShedulerViewState(
                doctorsInBloc,
                schedulesnIBloc,
                event.searchDate,
                event.employeeDocNo,
              ));
            } else if (result == ResultData.NoSchedules) {
              emit(ShedulerViewState(
                doctorsInBloc,
                List.empty(),
                event.searchDate,
                event.employeeDocNo,
              ));
            } else {
              // Handle failure scenarios
              // add(SearcherroEvent());
            }
          }
        });

        // Controlling Events
        on<QRCodeScannedEvent>((event, emit) async {
          QrCodeConfigModel config = QrCodeConfigModel(url: "", clinicId: -1);
          try {
            config = QrCodeConfigModel.fromJson(event.qRCodeJson.toString());
          } catch (e) {
            emit(MedicoPlusErrorState(
                "Invalid QR Code", "The QR Code Which you scanned is invalid"));
          }
          if (config.clinicId != -1) {
            saveToLocal("ConnectionURL", config.url);
            saveToLocal("ClinicId", config.clinicId.toString());
            saveToLocal("Configuration", ConfigStatus.configured.toString());
            ApplicationConfig.ConnectionUrl = config.url;
            ApplicationConfig.ClinicId = config.clinicId.toString();
            ApplicationConfig.configStatus = ConfigStatus.configured;
            ApplicationConfig.DefaultDoctor = "";
            emit(LoginPageState());
          }
        });
      }
    });
  }

  static List<PatientSchedule> schedulesnIBloc = [];
  static List<DoctorModel> doctorsInBloc = [];

  Future<ResultData> refreshScheduler(
      // List<DoctorModel> doctorsInBloc,
      DateTime selectedDate,
      String doctorID,
      // List<PatientSchedule> schedulesInBloc,
      ResultData result) async {
    try {
      var futureDoctors = await fetchDoctorList();
      if (futureDoctors.isNotEmpty) {
        doctorsInBloc = futureDoctors;
        var futureSchedules = await fetchSchedules(selectedDate, doctorID);
        if (futureSchedules.isNotEmpty) {
          schedulesnIBloc = futureSchedules;
          return ResultData.Success;
        } else {
          // emit(ShedulerErrorState("NoSchedules"));
          return ResultData.NoSchedules;
          // ShedulerErrorState
        }
      } else {
        // emit(ShedulerErrorState("NoDoctors"));
        return ResultData.NoDoctors;
      }
    } catch (e) {
      // Handle any exceptions that might occur during fetching
      throw "erro";
    }
  }

  Future<bool> ReadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApplicationConfig.ConnectionUrl = prefs.get("ConnectionURL").toString();
    ApplicationConfig.ClinicId = prefs.get("ClinicId").toString();
    ApplicationConfig.DefaultDoctor = prefs.get("defaultDoctor").toString();
    ApplicationConfig.configStatus = prefs.get("Configuration") != null
        ? toConfigStatus(prefs.get("Configuration").toString())
        : ConfigStatus.notConfigured;
    return true;
  }

  Future saveToLocal(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}

enum ResultData { NoDoctors, NoSchedules, Errors, Success, waiting }
