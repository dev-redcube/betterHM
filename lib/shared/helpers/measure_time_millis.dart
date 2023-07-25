Future<Duration> measureTimeMillis(Future<void> Function() fn) async {
  final stopwatch = Stopwatch()..start();
  await fn.call();
  stopwatch.stop();
  return stopwatch.elapsed;
}
