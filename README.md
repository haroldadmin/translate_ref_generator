# Translation Reference Generator

Dart code generator for keys in translation JSON files.

For Flutter projects that contain translation strings in JSON files, it can be a challenge to correctly reference string key names inside Dart code because:

- Key names might change over time as translations are added/removed
- Spelling mistakes in key names can cause errors at runtime
- Different translation files might contain extra/fewer keys than others

This package aims to solve these problems by creating a Dart file at compile time which contains these key names as constants.

## Usage

Place your translation string files with `.lang.json` extension in the `lib/lang` directory.

```text
# Project structure
- app
  - lib
    - lang
      - en.lang.json
      - hi.lang.json
```

```json
// Example en.json
{
  "greeting": "hello"
}

// Example hi.lang.json
{
  "greeting": "नमस्कार"
}
```

Create a class annotated with `@TranslationReferences` and prefix the name with the `$` sign.

```dart
@TranslationsReference(
  langDir: 'lib/lang',
)
class $MyTranslations {}
```

Finally, run `flutter pub run build_runner build` to run the code generator.

The setup in this example would generate a file `translations.lang.dart` with the following contents:

```dart
// Generated code
class MyTranslations {
  static const String greeting = 'greeting';
}
```

This class can then be used inside your Flutter app for localization:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final greeting = AppLocalizations.of(context).translate(MyTranslations.greeting);
    return Text(greeting);
  }
}
```

## Status

This package is not yet published to `pub.dev`. No guarantees are made regarding API stability. Use at your own risk.

## Contributions

Found a bug or have a feature request? Open an issue!
Want to contribute new features or bug fixes? Open an issue and the create a Pull Request.

## License

`<TBD>`