import 'package:file/file.dart';

Future<List<File>> createFiles(List<String> fileNames, FileSystem fs) async {
  return Stream.fromIterable(fileNames)
      .asyncMap((fileName) => createFile(fileName, fs))
      .toList();
}

Future<File> createFile(String fileName, FileSystem fs) {
  return fs.file(fileName).create(recursive: true);
}

const mockEn = '''
{
  "greeting": "Hello"
}
''';

const mockHi = '''
{
  "greeting": "नमस्कार"
}
''';

const mockEs = '''
{
  "greeting": "Hola"
}
''';

const mockFr = '''
{
  "greeting": "Bonjour",
  "goodbye": "Au revoir"
}
''';
