import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:translate_ref_generator/src/builder.dart';

Builder translationReferenceBuilder(BuilderOptions options) {
  return LibraryBuilder(
    TranslationReferenceGenerator(),
    generatedExtension: '.lang.dart',
  );
}
