import 'dart:io';

String getTestDirPath() {
  var path = Directory.current.path;
  return path += path.endsWith('test') ? '' : '/test';
}

String fixture(String name) {
  var testDir = getTestDirPath();
  return File("$testDir/fixtures/$name").readAsStringSync();
}
