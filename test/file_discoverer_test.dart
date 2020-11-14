import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';
import 'package:translate_ref_generator/src/file_discoverer.dart';

void main() async {
  group('LangFileDiscoverer.listFiles', () {
    test('should return empty list for non-existent dir', () async {
      final fs = MemoryFileSystem.test();
      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: 'lang');

      final files = await discoverer.listFiles();
      expect(files.isEmpty, true);
    });

    test('should list all matching files', () async {
      final fileNames = const ['en.lang.json', 'hi.lang.json'];
      final fs = MemoryFileSystem.test();
      await createFiles(fileNames, fs);

      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: '.');

      final discoveredFiles = await discoverer.listFiles();

      expect(discoveredFiles, hasLength(2));
      discoveredFiles.forEach((file) {
        expect(fileNames, contains(file.basename));
      });
    });

    test('should not list files which do not match', () async {
      final fileNames = const ['en.lang.json', 'hi.json'];
      final fs = MemoryFileSystem.test();
      await createFiles(fileNames, fs);

      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: '.');
      final discoveredFiles = await discoverer.listFiles();
      expect(discoveredFiles, hasLength(1));

      final names = discoveredFiles.map((f) => f.basename).toList();
      expect(names, isNot(contains('hi.json')));
    });

    test('should search in given directory only', () async {
      final fileNames = ['en/en.lang.json', 'hi/hi.lang.json'];
      final fs = MemoryFileSystem.test();
      await createFiles(fileNames, fs);

      final discoverer = LangFileDiscoverer(
        fileSystem: fs,
        dir: 'hi',
        isRecursive: true,
      );

      final discoveredFiles = await discoverer.listFiles();
      expect(discoveredFiles, hasLength(1));

      final names = discoveredFiles.map((f) => f.basename).toList();
      expect(names, contains('hi.lang.json'));
    });
    test('should search recursively when requested', () async {
      final fileNames = ['en/en.lang.json', 'hi/hi.lang.json'];
      final fs = MemoryFileSystem.test();
      await createFiles(fileNames, fs);

      final discoverer = LangFileDiscoverer(
        fileSystem: fs,
        dir: '.',
        isRecursive: true,
      );

      final discoveredFiles = await discoverer.listFiles();
      expect(discoveredFiles, hasLength(2));

      final names = discoveredFiles.map((f) => f.basename).toList();
      expect(names, contains('hi.lang.json'));
    });

    test('should skip sym-links', () async {
      final fileNames = ['en.lang.json', 'link/linked.lang.json'];
      final fs = MemoryFileSystem.test();
      await createFiles(fileNames, fs);

      await fs.link('link.lang.json').create('link/linked.lang.json');

      final discoverer = LangFileDiscoverer(
        fileSystem: fs,
        dir: '.',
      );

      final discoveredFiles = await discoverer.listFiles();
      expect(discoveredFiles, hasLength(1));

      final names = discoveredFiles.map((f) => f.basename).toList();
      expect(names, isNot(contains('linked.lang.json')));
    });
  });

  group('LangFileDiscoverer.discoverPaths', () {
    test('should return empty list for non-existent dir', () async {
      final fs = MemoryFileSystem.test();
      final discoverer = LangFileDiscoverer(fileSystem: fs, dir: 'lang');

      final paths = await discoverer.discoverPaths();
      expect(paths.isEmpty, true);
    });
  });
}

Future<List<File>> createFiles(List<String> fileNames, FileSystem fs) async {
  return Stream.fromIterable(fileNames)
      .asyncMap((fileName) => createFile(fileName, fs))
      .toList();
}

Future<File> createFile(String fileName, FileSystem fs) {
  return fs.file(fileName).create(recursive: true);
}
