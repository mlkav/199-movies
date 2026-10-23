import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.substring(0, dir.length - 5);
  }
  if (!dir.endsWith('/movie')) {
    dir = '$dir/movie';
  }
  return File('$dir/test/$name').readAsStringSync();
}
