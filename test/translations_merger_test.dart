import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_reader.dart';
import 'package:translate_ref_generator/src/translations_merger.dart';

import 'utilities.dart';

void main() {
  group('LangFilesMerger', () {
    test('should merge keys of all input files', () {
      final translations = [
        mockEn,
        mockHi,
        mockEs,
      ].map((json) => LangFileReader.parse(json)).toList();

      final mergedSet = TranslationsMerger.mergeMaps(translations);

      expect(mergedSet, hasLength(1));
      expect(mergedSet.first, 'greeting');
    });
  });

  test('should merge keys not present in all files too', () {
    final translations = [
      mockEn,
      mockHi,
      mockEs,
      mockFr,
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
