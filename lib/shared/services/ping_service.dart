import 'dart:io';

class PingResult {
  final bool isSuccess;
  final int rttMs;

  PingResult({required this.isSuccess, required this.rttMs});
}

class PingService {
  Future<PingResult> pingDevice(String ip) async {
    try {
      final result = await Process.run(
        'ping',
        ['-n', '1', '-w', '500', ip],
      );

      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final match = RegExp(r'time[=<](\d+)ms').firstMatch(output);
        final rtt = match != null ? int.parse(match.group(1)!) : 0;

        return PingResult(isSuccess: true, rttMs: rtt);
      }

      return PingResult(isSuccess: false, rttMs: 0);
    } catch (e) {
      return PingResult(isSuccess: false, rttMs: 0);
    }
  }
}
