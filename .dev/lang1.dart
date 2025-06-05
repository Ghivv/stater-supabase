import 'dart:convert';
import 'dart:io';

void main() {
  final directory = Directory('lib/presentation');
  //read app_en.arb
  final appEnArbContent = File('lib/core/l10n/app_en.arb').readAsStringSync();
  final Map<String, dynamic> lang = jsonDecode(appEnArbContent);

  directory.listSync(recursive: true).forEach((file) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      // lang.forEach((key, value) {
      //   content = content.replaceAll('title: "$key"', 'title: lang.$value');
      //   content = content.replaceAll('Text("$key")', 'Text(lang.$value)');
      //   content = content.replaceAll('label: "$key"', 'label: lang.$value');
      // });

      lang.forEach((key, value) {
        // print(key);
        content = content.replaceAll('Text("$value"', 'Text(lang.$key');
        content = content.replaceAll('Text("$value"', 'Text(lang.$key');

        if (file.path.endsWith("_view.dart") || file.path.contains("widget")) {
          content = content.replaceAll('title: "$value"', 'title: lang.$key');
          content = content.replaceAll('label: "$value"', 'label: lang.$key');

          content =
              content.replaceAll('"title": "$value"', '"title": lang.$key');
          content =
              content.replaceAll('"label": "$value"', '"label": lang.$key');
        }

        //cleaning
        content = content.replaceAll('const Text(lang', 'Text(lang');
      });

      file.writeAsStringSync(content);
      print('Translated: ${file.path}');
    }
  });
}
