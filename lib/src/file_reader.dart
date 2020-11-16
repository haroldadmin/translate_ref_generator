import 'dart:convert';

import 'package:build/build.dart';
import 'package:path/path.dart' as path;

/// Parses a .lang.json file containing translation strings
class LangFileReader {
  static Future<Map<String, dynamic>> readAsset(
    AssetId assetId,
    BuildStep buildStep,
  ) async {
    final fileName = path.basename(assetId.path);
    final contents = await buildStep.readAsString(assetId);
    return parse(fileName, contents);
  }

  static Map<String, dynamic> parse(
    String fileName,
    String contents,
  ) {
    final decoder = JsonDecoder();
    try {
      final json = decoder.convert(contents);
      return Map<String, dynamic>.from(json);
    } on FormatException catch (err) {
      log.severe('Could not parse $fileName: ${err.message}');
    }

    return const {};
  }
}
