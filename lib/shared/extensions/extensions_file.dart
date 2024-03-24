import 'dart:io';

extension FileExtension on File {
  String get filename => path.split(Platform.pathSeparator).last;

  String get filenameWithoutExtension => filename.split(".").first;
}
