import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translate_ref_generator/src/annotations.dart';
import 'package:translate_ref_generator/src/file_reader.dart';
import 'package:translate_ref_generator/src/file_discoverer.dart';
import 'package:translate_ref_generator/src/extensions.dart';
import 'package:translate_ref_generator/src/translations_merger.dart';

/// Generates a Dart file that contains static properties representing
/// keys in JSON translation files.
///
/// Searches for translation files (*.lang.json) in the given directory
/// and merges their keys into a set. It then creates a Dart file containing
/// those keys as static properties. These keys can be used to reference
/// translated strings across multiple files depending on the user locale.
class TranslationReferenceGenerator
    extends GeneratorForAnnotation<TranslationReferences> {
  final LangFileDiscoverer _discoverer;

  TranslationReferenceGenerator(String dir)
      : _discoverer = LangFileDiscoverer(dir: dir);

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The annotation must only be used on a class',
      );
    }

    if (!element.displayName.startsWith(r'$') ||
        element.displayName.length < 2) {
      throw InvalidGenerationSourceError(
        'Annotated class name must start with \$ and not be empty',
      );
    }

    final className = element.displayName.substring(1);
    final translationRefs = await generateRefKeys(buildStep);

    final buffer = StringBuffer();
    final staticConstants = translationRefs
        .map((ref) => 'static const String $ref = \'$ref\';')
        .join('\n');

    buffer
      ..writeln('class $className {')
      ..writeln(staticConstants)
      ..writeln('}');

    return buffer.toString();
  }

  Future<Set<String>> generateRefKeys(BuildStep buildStep) async {
    final langFilePaths = await _discoverer.discoverPaths();
    print('Discovered paths: $langFilePaths');

    final translations = await Stream.fromIterable(langFilePaths)
        .map((p) => AssetId(buildStep.inputId.package, p))
        .asyncWhere((assetId) async {
          final canRead = await buildStep.canRead(assetId);
          if (!canRead) {
            print('Can not read ${assetId.toString()}');
          }
          return canRead;
        })
        .asyncMap((assetId) => LangFileReader.readAsset(assetId, buildStep))
        .toList();

    final mergedSet = LangFilesMerger.merge(translations);

    return mergedSet;
  }
}
