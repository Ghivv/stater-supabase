/*
Ambil semua teks yang ada pada String title
Misalnya
title: "Profile",
atau Text("Hello")


label: "Help"

Simpan pada file lang.json

Baca semua file yang ada di lib/presentation
*/

import 'dart:convert';
import 'dart:io';

final defaultJson = {
  "defaultError": "Failed to process",
  "defaultSuccess": "Success to process",
  "helloWorld": "Hello World!",
  "email": "Email",
  "password": "Password",
  "login": "Login",
  "register": "Register",
  "dashboard": "Dashboard",
  "posts": "Posts",
  "activities": "Activities",
  "meals": "Meals",
  "profile": "Profile",
  "developer": "Developer"
};
void main(List args) async {
  final directory = Directory('lib/presentation');
  final appEnArbContent = File('lib/core/l10n/app_en.arb').readAsStringSync();
  final Map<String, dynamic> currentLang = jsonDecode(appEnArbContent);

  final langFile = File('lib/core/l10n/app_en.arb');
  Map<String, dynamic> translations = currentLang;
  translations.addAll(defaultJson);

  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final regex =
          RegExp(r'title:\s*"([^"]+)"|Text\("([^"]+)"\)|label:\s*"([^"]+)"');
      final matches = regex.allMatches(content);

      for (var match in matches) {
        final title = match.group(1) ?? match.group(2) ?? match.group(3);
        if (title != null) {
          //key
          var key = title.keyName;
          if (key.contains("&")) continue;
          if (key.contains("\${")) continue;

          key = key.replaceAll("?", "");
          final camelCaseKey = key.camelCaseName;

          translations[camelCaseKey] = title.titleName;
        }
      }
    }
  }

  final encoder = JsonEncoder.withIndent('  ');
  final prettyPrint = encoder.convert(translations);
  await langFile.writeAsString(prettyPrint);
  print('Translations saved to lang.json');

  //copy app_en.arb to app_id.arb, app_es.arb, app_ja.arb, app_ko.arb
  if (args.isEmpty) return;

  if (args.isNotEmpty) {
    if (args[0] == "all") {
      final langs = ['id', 'es', 'ja', 'ko'];
      for (var lang in langs) {
        final langFile = File('lib/core/l10n/app_$lang.arb');
        await langFile.writeAsString(prettyPrint);
      }
      print(
          'Translations saved to app_id.arb, app_es.arb, app_ja.arb, app_ko.arb');
    }
  }
}

extension StringExtension on String {
  //keyName
  String get keyName {
    var value = this;
    // Convert camelCase or PascalCase to snake_case
    value = value.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)}_${match.group(2)!.toLowerCase()}';
    });
    // Convert spaces to underscores and make lowercase
    value = value.replaceAll(' ', '_').toLowerCase();
    return value;
  }

  String get camelCaseName {
    var value = this.keyName;
    // Convert snake_case to camelCase
    value = value.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join('');

    //firstCharacterToLower
    value = value[0].toLowerCase() + value.substring(1);
    return value;
  }

  String get titleName {
    var value = this;
    // Capitalize each word
    value = value.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
    return value;
  }
}
