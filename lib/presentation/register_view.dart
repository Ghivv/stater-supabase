import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/presentation/login_view.dart';
import 'package:reusekit/service/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  bool isLoading = false;

  Future<void> register() async {
    bool isNotValid = formKey.currentState!.validate() == false;
    if (isNotValid) {
      return;
    }

    if (password != confirmPassword) {
      se("Password tidak cocok!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().register(email: email!, password: password!);
      offAll(const LoginView());
      ss(
        "Registrasi berhasil! Silakan login dengan akun baru Anda.",
      );
    } on Exception catch (err) {
      se("Gagal registrasi: $err");
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
      appBar: AppBar(
        title: const Text("Register"),
        actions: const [],
      ),
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
                    const SizedBox(height: 20),
                    Text(
                      "Create New Account",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please fill in the form to register",
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
                    QTextField(
                      label: "Confirm Password",
                      obscureText: true,
                      validator: Validator.required,
                      suffixIcon: Icons.password,
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                    ),
                    const SizedBox(height: 30),
                    QButton(
                      label:lang.register,
                      onPressed: () => register(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            to(const LoginView());
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
