import 'dart:async';
import 'dart:developer' as dev;

import 'package:build/build.dart';

const _TAG = 'TranslationReferenceBuilder';

class TranslationReferenceBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) {
    final langFile = buildStep.inputId.path;
    dev.log('Processing $langFile', name: _TAG);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.lang.json': ['.gr.dart'],
      };
}
