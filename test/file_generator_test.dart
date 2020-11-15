import 'package:file/memory.dart';
import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_discoverer.dart';
import 'package:translate_ref_generator/src/file_generator.dart';
import 'package:translate_ref_generator/src/translation.dart';

void main() {
  group('ReferenceFileGenerator', () {
    test('should generate source file with correct class name', () async {
      final fs = MemoryFileSystem.test();
      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: '/');
      final generator = ReferenceFileGenerator(discoverer);

      final className = 'ReferenceFileGeneratorTest';

      final source = await generator.createSourceString(className, []);
      expect(source, isNotEmpty);
      expect(source, startsWith('class $className'));
    });

    test('should generate source file all translation keys', () async {
      final fs = MemoryFileSystem.test();
      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: '/');
      final generator = ReferenceFileGenerator(discoverer);
      final className = 'ReferenceFileGeneratorTest';

      final translations = <Translation>[
        Translation(
            'en.lang.json', {'greeting': 'hello', 'farewell': 'goodbye'}),
        Translation('hi.lang.json', {'greeting': 'नमस्कार'}),
      ];

      final source =
          await generator.createSourceString(className, translations);
      expect(source, isNotEmpty);
      expect(source, startsWith('class $className'));

      expect(
        source,
        allOf([
          contains('static const String greeting = \'greeting\''),
          contains('static const String farewell = \'farewell\''),
        ]),
      );
    });
  });
}
