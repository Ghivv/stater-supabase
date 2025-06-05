/*
withOpacity(
to
withValues(alpha:
*/

import 'dart:io';

void main() {
  //read all dart files in lib/
  var libDir = Directory('lib');
  var libFiles = libDir.listSync(recursive: true, followLinks: false);
  for (var file in libFiles) {
    if (file.path.endsWith('.dart')) {
      var content = File(file.path).readAsStringSync();
      content = content.replaceAllMapped(
        RegExp(r'withOpacity\('),
        (match) {
          return 'withValues(alpha:';
        },
      );
      File(file.path).writeAsStringSync(content);
    }
  }
}
