import 'package:source_gen/source_gen.dart';

class Config {
  final String langDir;
  final bool shouldSearchRecursively;

  const Config(this.langDir, this.shouldSearchRecursively);

  factory Config.fromAnnotation(ConstantReader annotation) {
    final dir = annotation.peek('langDir').stringValue;
    final shouldSearchRecursively =
        annotation.peek('searchRecursively').boolValue;

    return Config(dir, shouldSearchRecursively);
  }
}
