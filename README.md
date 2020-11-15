# Translation Reference Generator

For a Flutter project that contains translation strings in JSON files, it can be a challenge to correctly reference string key names inside Dart code because:

- Key names might change over time as translations are added/removed
- Spelling mistakes in key names can be hard to detect
- Multiple language files contain strings of the same keys, but some files might contain extra/fewer keys

This package aims to solve these problems by creating a Dart file at compile time which contains these key names as constants.

```text
# Project structure
- app
  - lib
    - lang
      - en.lang.json
      - hi.lang.json
    - translations.dart
```

```json
// en.json
{
  "greeting": "hello"
}

// hi.lang.json
{
  "greeting": "नमस्कार"
}
```

```dart
// translations.dart
@TranslationsReference
class $MyTranslations {}
```

This setup would generate a file `translations.lang.dart` containing:

```dart
class MyTranslations {
  static const String greeting = 'greeting';
}
```

Depending on your setup, this class can then be used inside your Flutter app:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final greeting = AppLocalizations.of(context).translate(MyTranslations.greeting);
    return Text(greeting);
  }
}
```
