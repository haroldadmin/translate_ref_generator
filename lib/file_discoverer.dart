import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;

const _LangExtensions = ['.lang.json'];
const _DefaultDir = 'lib/lang/';

/// Finds language translation files in the project.
///
/// Example:
/// ```dart
/// final discoverer = LangFileDiscoverer(dir: 'lib/lang/');
/// final langFiles = await discoverer.listFiles();
/// ```
class LangFileDiscoverer {
  final FileSystem fileSystem;
  final String dir;
  final bool isRecursive;

  LangFileDiscoverer({
    this.fileSystem = const LocalFileSystem(),
    this.dir = _DefaultDir,
    this.isRecursive = false,
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

    return fileList;
  }
}
