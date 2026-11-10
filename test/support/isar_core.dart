/// One-time, race-free setup of the Isar native library for tests.
///
/// `Isar.initializeIsarCore(download: true)` downloads the library next to
/// the running script and loads it. Under `dart test` every test file runs
/// in its own isolate, so parallel files raced on the same half-written
/// file and failed with "file does not start with MH_MAGIC" or "missing
/// compatible architecture". This helper downloads once into
/// `.dart_tool/isar_core/<version>/` under an exclusive file lock; the other
/// isolates wait, then load the finished file. Network access is needed only
/// on the first run after a checkout or an Isar upgrade.
library;

import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/isar.dart';

/// Initializes Isar core for this isolate. Safe to call from every `setUp`.
Future<void> initIsarCoreForTests() async {
  final sep = Platform.pathSeparator;
  final dir = Directory(
      '${Directory.current.path}$sep.dart_tool${sep}isar_core$sep${Isar.version}');
  await dir.create(recursive: true);
  final libraryPath = '${dir.path}$sep${_libraryFileName()}';

  final lock =
      await File('${dir.path}${sep}download.lock').open(mode: FileMode.write);
  await lock.lock(FileLock.blockingExclusive);
  try {
    try {
      await _initialize(libraryPath);
    } catch (_) {
      // A partial or stale download from an interrupted run: fetch again.
      final file = File(libraryPath);
      if (await file.exists()) await file.delete();
      await _initialize(libraryPath);
    }
  } finally {
    await lock.unlock();
    await lock.close();
  }
}

Future<void> _initialize(String libraryPath) => Isar.initializeIsarCore(
      download: true,
      libraries: {Abi.current(): libraryPath},
    );

String _libraryFileName() {
  if (Platform.isMacOS) return 'libisar.dylib';
  if (Platform.isWindows) return 'isar.dll';
  return 'libisar.so';
}
