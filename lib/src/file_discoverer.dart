import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;

const _LangExtensions = ['.lang.json'];

/// Traverses [dir] in the given [fileSystem] to find files
/// that match supported language file extensions.
class LangFileDiscoverer {
  final FileSystem fileSystem;
  final String dir;
  final bool isRecursive;

  const LangFileDiscoverer({
    this.fileSystem = const LocalFileSystem(),
    this.isRecursive = false,
    this.dir,
  });

  Future<List<File>> listFiles() async {
    if (!(await fileSystem.isDirectory(dir))) {
      return List<File>.empty();
    }

    final fileList = await fileSystem
        .directory(dir)
        .list(recursive: isRecursive, followLinks: false)
        .where((fsEntity) => !(fsEntity is Link))
        .where((fsEntity) {
          final ext = path.extension(fsEntity.path, 2);
          return _LangExtensions.contains(ext);
        })
        .map((fsEntity) => fileSystem.file(fsEntity.path))
        .toList();

    return List<File>.unmodifiable(fileList);
  }

  Future<List<String>> discoverPaths() async {
    if (!(await fileSystem.isDirectory(dir))) {
      return List<String>.empty();
    }

    final files = await listFiles();
    return files.map((file) => file.path).toList();
  }
}
