import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_reader.dart';
import 'package:translate_ref_generator/src/translations_merger.dart';

void main() {
  group('LangFilesMerger', () {
    test('should merge keys of all input files', () {
      final translations = [
        _en,
        _hi,
        _es,
      ].map((json) => LangFileReader.parse(json)).toList();

      final mergedSet = TranslationsMerger.mergeMaps(translations);

      expect(mergedSet, hasLength(1));
      expect(mergedSet.first, 'greeting');
    });
  });

  test('should merge keys not present in all files too', () {
    final translations = [
      _en,
      _hi,
      _es,
      _fr,
    ].map((json) => LangFileReader.parse(json)).toList();

    final mergedSet = TranslationsMerger.mergeMaps(translations);

    expect(mergedSet, hasLength(2));
    expect(mergedSet, containsAll(['greeting', 'goodbye']));
  });

  test('should return empty set when input is empty', () {
    final translations = List<Map<String, dynamic>>.empty();
    final mergedSet = TranslationsMerger.mergeMaps(translations);

    expect(mergedSet, isEmpty);
  });
}

const _en = '''
{
  "greeting": "Hello"
}
''';

const _hi = '''
{
  "greeting": "नमस्कार"
}
''';

const _es = '''
{
  "greeting": "Hola"
}
''';

const _fr = '''
{
  "greeting": "Bonjour",
  "goodbye": "Au revoir"
}
''';
