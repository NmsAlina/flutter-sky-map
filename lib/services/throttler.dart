typedef VoidCallback = dynamic Function();

class Throttler {
  final int throttleGapInMillis;
  Throttler({required this.throttleGapInMillis});

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          throttleGapInMillis) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
