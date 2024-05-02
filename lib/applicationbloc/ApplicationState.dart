import 'package:appointment_views/models/PatientSchedule.dart';
import 'package:appointment_views/models/doctorModel.dart';

abstract class ApplicationState {}

class ApplicationInitialState extends ApplicationState {}

class QRCodeState extends ApplicationState {}

class QRCodeErrorState extends ApplicationState {}

class LoginPageState extends ApplicationState {}

class ShedulerErrorState extends ApplicationState {
  final String errorMessage;
  ShedulerErrorState(this.errorMessage);
}

class LoginRequestingState extends ApplicationState {}

class LoginErrorState extends ApplicationState {
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}

class NoInternetState extends ApplicationState {}

class ShedulerViewState extends ApplicationState {
  final List<DoctorModel> doctors;
  final List<PatientSchedule> Shedules;
  final DateTime SelectedDate;
  final String EmpDocNo;
  ShedulerViewState(
      this.doctors, this.Shedules, this.SelectedDate, this.EmpDocNo);
}

class MedicoPlusErrorState extends ApplicationState {
  final String title;
  final String errorMessage;

  MedicoPlusErrorState(this.title, this.errorMessage);
}
