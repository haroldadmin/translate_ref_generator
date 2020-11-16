/// Represents the annotation to be applied to marker class
/// for translation references.
///
/// The marker class name must start with a '$' sign, and
/// must not be empty. A corresponding class without the '$'
/// sign name will be generated that contains static properties
/// representing translation keys.
///
/// Example:
/// ```
/// import 'package:translate_ref_generator/translate_ref_generator.dart'
///
/// @TranslationReferences(
///   langDir: 'lib/translations/',
///   searchRecursively: false
/// )
/// class $MyTranslations {}
/// ```
class TranslationReferences {
  final String langDir;
  final bool searchRecursively;

  const TranslationReferences({
    this.langDir = _DefaultLangDir,
    this.searchRecursively = false,
  });
}

const _DefaultLangDir = 'lib/lang/';
