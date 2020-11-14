import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:glob/glob.dart';
import 'package:build/build.dart';

class TranslationReferenceBuilder extends Builder {
  final _glob = Glob('*.lang.json');

  @override
  FutureOr<void> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$package$': ['lib/translation_references.lang.dart'],
      };
}
