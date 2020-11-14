import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translate_ref_generator/src/builder.dart';

const _DefaultTranslationsDir = 'lib/lang';

Builder translationReferenceBuilder(BuilderOptions options) {
  final String dirName =
      options.config['translationsDir'] ?? _DefaultTranslationsDir;

  return LibraryBuilder(
    TranslationReferenceGenerator(dirName),
    generatedExtension: '.lang.dart',
  );
}
