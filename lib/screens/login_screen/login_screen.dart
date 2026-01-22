import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/common/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 64,
                    color: Colors.brown,
                  ),
                  const Text(
                    "Simple Journal",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("por Alura",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text("Entre ou Registre-se"),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: const InputDecoration(label: Text("Senha")),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) {
    String email = _emailController.text;
    String password = _passController.text;

    service.login(email: email, password: password).then((resultLogin) {
      if (resultLogin && context.mounted) {
        Navigator.pushReplacementNamed(context, 'home');
      }
    }).catchError(
      (error) {
        if (context.mounted) {
          HttpException innerError = error;
          showExceptionDialog(context, content: innerError.message);
        }
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        if (context.mounted) {
          showConfirmationDialog(context,
                  content:
                      "Would you like to sign-up using $email and the informed password?",
                  affirmativeOption: "SIGN-UP")
              .then((value) {
            if (value != null && value) {
              service
                  .register(email: email, password: password)
                  .then((resultRegister) {
                if (resultRegister && context.mounted) {
                  Navigator.pushReplacementNamed(context, 'home');
                }
              });
            }
          });
        }
      },
      test: (error) => error is UserNotFoundException,
    );
  }
}
