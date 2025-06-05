/*
path: android\app\src\main\res\xml\file_paths.xml
content: 
<paths>
    <cache-path name="cache" path="." />
</paths>
*/
import 'dart:io';

void createFilePathsXml() {
  final file = File('android/app/src/main/res/xml/file_paths.xml');
  final content = '''
<paths>
    <cache-path name="cache" path="." />
</paths> 
''';

  file.createSync(recursive: true);
  file.writeAsStringSync(content);
}

void main() {
  createFilePathsXml();
}
