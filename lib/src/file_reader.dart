import 'dart:convert';

import 'package:build/build.dart';

/// Parses a .lang.json file containing translation strings
class LangFileReader {
  static Future<Map<String, dynamic>> readAsset(
    AssetId assetId,
    BuildStep buildStep,
  ) async {
    final contents = await buildStep.readAsString(assetId);
    return parse(contents);
  }

  static Map<String, dynamic> parse(String contents) {
    final decoder = JsonDecoder();
    final json = decoder.convert(contents);

    return Map<String, dynamic>.from(json);
  }
}
