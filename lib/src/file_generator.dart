import 'dart:developer';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:translate_ref_generator/src/extensions.dart';
import 'package:translate_ref_generator/src/file_discoverer.dart';
import 'package:translate_ref_generator/src/file_reader.dart';
import 'package:translate_ref_generator/src/translation.dart';
import 'package:translate_ref_generator/src/translations_merger.dart';

class ReferenceFileGenerator {
  final LangFileDiscoverer _discoverer;

  const ReferenceFileGenerator(this._discoverer);

  Future<String> generate(Element element, BuildStep buildStep) async {
    final className = element.displayName.substring(1);
    log.info('Generating translations file with name $className');

    final langFiles = await _discoverer.discoverPaths();
    log.info('Discovered lang files: $langFiles');

    final translations = await _readTranslationsInFiles(langFiles, buildStep);

    return createSourceString(className, translations);
  }

  Future<String> createSourceString(
    String className,
    List<Translation> translations,
  ) async {
    final mergedSet = TranslationsMerger.merge(translations);

    translations.forEach((translation) {
      final missingKeys = mergedSet.difference(translation.map.keys.toSet());
      if (missingKeys.isNotEmpty) {
        log.warning(
          'Missing keys in ${translation.fileName}: ${missingKeys.toString()}',
        );
      }
    });

    final staticConstants = mergedSet
        .map((key) => 'static const String $key = \'$key\';')
        .join('\n');

    final buffer = StringBuffer()
      ..writeln('class $className {')
      ..writeln(staticConstants)
      ..writeln('}');

    return buffer.toString();
  }

  Future<List<Translation>> _readTranslationsInFiles(
    List<String> langFilePaths,
    BuildStep buildStep,
  ) =>
      Stream.fromIterable(langFilePaths)
          .map((p) => AssetId(buildStep.inputId.package, p))
          .asyncWhere((assetId) async {
        final canRead = await buildStep.canRead(assetId);
        if (!canRead) {
          log.warning('Can not read ${assetId.toString()}, skipping');
        }
        return canRead;
      }).asyncMap((assetId) async {
        final translations = await LangFileReader.readAsset(assetId, buildStep);
        final fileName = assetId.path;
        log.info('Discovered ${translations.length} translations in $fileName');
        return Translation(fileName, translations);
      }).toList();
}
