import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_reader.dart';

void main() async {
  group('LangFileReader', () {
    test('should read file correctly', () {
      final json = '''
      {
        "name": "Translation Reference Generator"
      }
      ''';
      final parsed = LangFileReader.parse(json);

      expect(parsed, containsPair('name', 'Translation Reference Generator'));
    });
  });
}
