import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translate_ref_generator/src/annotations.dart';
import 'package:translate_ref_generator/src/file_generator.dart';

/// Generates a Dart file that contains static properties representing
/// keys in JSON translation files.
///
/// Searches for translation files (*.lang.json) in the given directory
/// and merges their keys into a set. It then creates a Dart file containing
/// those keys as static properties. These keys can be used to reference
/// translated strings across multiple files depending on the user locale.
class TranslationReferenceGenerator
    extends GeneratorForAnnotation<TranslationReferences> {
  final ReferenceFileGenerator _generator;

  TranslationReferenceGenerator(this._generator);

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

    return _generator.generate(element, buildStep);
  }
}
