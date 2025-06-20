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
  bool isLoading = false;
  Future<void> login() async {
    bool isNotValid = formKey.currentState!.validate() == false;
    if (isNotValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> response =
          await AuthService().login(email: email!, password: password!);
      offAll(const MainNavigationView());
      ss("Login berhasil"); // Success message
    } on Exception catch (err) {
      String errorMsg = err.toString().replaceAll("Exception: ", "");
      se(errorMsg);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lang = AppLocalizations.of(context)!;

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      "Admin Login",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter your admin credentials to continue",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 40),
                    QTextField(
                      label: "Email",
                      validator: Validator.email,
                      suffixIcon: Icons.email,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    QTextField(
                      label: "Password",
                      obscureText: true,
                      validator: Validator.required,
                      suffixIcon: Icons.password,
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 30),
                    QButton(
                      label: lang.login,
                      onPressed: () => login(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
