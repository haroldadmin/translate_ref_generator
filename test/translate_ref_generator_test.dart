import 'package:translate_ref_generator/builder.dart';
import 'package:test/test.dart';

void main() {
  test('should use *.lang.en build extensions', () {
    final builder = TranslationReferenceBuilder();
    expect(builder.buildExtensions, {
      '.lang.json': ['.gr.dart'],
    });
  });
}
