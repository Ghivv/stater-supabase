import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/presentation/main_navigation_view.dart';
import 'package:reusekit/service/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  Future<void> login() async {
    bool isNotValid = formKey.currentState!.validate() == false;
    if (isNotValid) {
      return;
    }

    try {
      await AuthService().login(email: email!, password: password!);
      offAll(MainNavigationView());
    } on Exception catch (err) {
      se("Gagal login: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lang = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              QTextField(
                label: "Email",
                validator: Validator.email,
                suffixIcon: Icons.email,
                value: null,
                onChanged: (value) {
                  email = value;
                },
              ),
              QTextField(
                label: "Password",
                obscureText: true,
                validator: Validator.required,
                suffixIcon: Icons.password,
                value: null,
                onChanged: (value) {
                  password = value;
                },
              ),
              QButton(
                label: lang.login,
                onPressed: () {
                  login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
