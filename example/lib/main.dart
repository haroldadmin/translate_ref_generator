import 'package:example/main.lang.dart';
import 'package:translate_ref_generator/translate_ref_generator.dart';

void main(List<String> args) {
  print('Keys: [${TranslationsExample.name}, ${TranslationsExample.project}]');
}

@TranslationReferences()
class $TranslationsExample {}
