import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/presentation/login_view.dart';
import 'package:reusekit/presentation/main_navigation_view.dart';
import 'package:reusekit/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.url,
    anonKey: Env.anonPublic,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<MainAppState>(this);
  }

  List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
    Locale('id'),
  ];

  void changeLocale(Locale locale) {
    setState(() {
      supportedLocales.clear();
      supportedLocales.add(locale);
    });
  }

  String get currentLocale {
    return supportedLocales.isNotEmpty
        ? supportedLocales.first.languageCode
        : 'en';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: RKAppTheme.theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      locale: Locale(currentLocale),
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('id'),
      ],
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedInAsync(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const MainNavigationView();
          }
          return const LoginView();
        },
      ),
    );
  }
}
