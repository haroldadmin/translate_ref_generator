import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_reader.dart';

void main() async {
  group('LangFileReader', () {
    test('should read file correctly', () {
      const json = '''
      {
        "name": "Translation Reference Generator"
      }
      ''';
      final parsed = LangFileReader.parse('mock-file', json);

      expect(parsed, containsPair('name', 'Translation Reference Generator'));
    });

    test('should return empty map when json is invalid', () {
      const json = '''
      { "name" : "this line should not end with a comma", }
      ''';

      final parsed = LangFileReader.parse('mock-file', json);

      expect(parsed, isEmpty);
    });
  });
}
