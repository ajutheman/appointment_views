import 'package:appointment_views/applicationConfig.dart';
import 'package:appointment_views/applicationbloc/ApplicationBloc.dart';
import 'package:appointment_views/applicationbloc/ApplicationEvents.dart';
import 'package:appointment_views/kaizenControls/Medcolors.dart';
import 'package:appointment_views/kaizenControls/MedicoControls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loginpage extends StatelessWidget {
  BuildContext applicationContext;
  final String errorMessage;
  Loginpage(this.applicationContext, this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Container(
                  height: 98.8,
                  width: 280,
                  child: Image.asset(
                      'assets/image/clinic-management-software.png'),
                ),
              ),
              const SizedBox(height: 150),
              MedicoControls.NormalLablel("Username"),
              const SizedBox(height: 20),
              MedicoControls.textField(userIdController, 'Enter your username'),
              const SizedBox(height: 16),
              MedicoControls.NormalLablel("Password"),
              const SizedBox(height: 23),
              MedicoControls.PasswordtextField(
                  passwordController, 'Enter your Password'),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: Medicolor.gradientFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MedicoControls.LoginButton(() {
                    applicationContext
                        .read<ApplicationBloc>()
                        .add(
                          LoginButtonPressed(
                          ApplicationConfig.ClinicId,
                          userIdController.text,
                          passwordController.text,
                          // "1"
                        ));
                  }, "Login"),
                ),
              ),
              const SizedBox(height: 15),

              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),

              // Add your additional UI components here if needed
            ],
          ),
        ),
      ),
    );
  }
}
