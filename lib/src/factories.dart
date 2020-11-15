import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translate_ref_generator/src/builder.dart';
import 'package:translate_ref_generator/src/file_discoverer.dart';
import 'package:translate_ref_generator/src/file_generator.dart';

const _DefaultTranslationsDir = 'lib/lang/';

Builder translationReferenceBuilder(BuilderOptions options) {
  final String dirName =
      options.config['translationsDir'] ?? _DefaultTranslationsDir;
  final bool isRecursive = options.config['isRecursive'] ?? false;

  final fileDiscoverer = LangFileDiscoverer(
    dir: dirName,
    isRecursive: isRecursive,
  );
  final fileGenerator = ReferenceFileGenerator(fileDiscoverer);
  final generator = TranslationReferenceGenerator(fileGenerator);

  return LibraryBuilder(generator, generatedExtension: '.lang.dart');
}
