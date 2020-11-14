/// Merges the maps of keys of multiple translation files
/// into a single Set
class LangFilesMerger {
  static Set<String> merge(List<Map<String, dynamic>> maps) {
    if (maps.isEmpty) {
      return <String>{};
    }

    if (maps.length == 1) {
      return Set<String>.of(maps.first.keys);
    }

    final mergedSet = maps
        .map((map) => Set<String>.from(map.keys))
        .reduce((combined, s) => combined..addAll(s));

    return mergedSet;
  }
}
