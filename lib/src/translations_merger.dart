import 'package:translate_ref_generator/src/translation.dart';

/// Merges the maps of keys of multiple translation files
/// into a single Set
class TranslationsMerger {
  static Set<String> merge(List<Translation> translations) {
    if (translations.isEmpty) {
      return const <String>{};
    }

    if (translations.length == 1) {
      return Set<String>.of(translations.first.map.keys);
    }

    final translationMaps =
        translations.map((translations) => translations.map).toList();
    return mergeMaps(translationMaps);
  }

  static Set<String> mergeMaps(List<Map<String, dynamic>> maps) {
    if (maps.isEmpty) {
      return const <String>{};
    }

    if (maps.length == 1) {
      return Set<String>.of(maps.first.keys);
    }

    return maps
        .map((map) => Set<String>.from(map.keys))
        .reduce((combined, s) => combined..addAll(s));
  }
}
