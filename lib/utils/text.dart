import 'dart:io';

String getFileNameFromPath(String path) {
  return path.split(Platform.pathSeparator).last;
}