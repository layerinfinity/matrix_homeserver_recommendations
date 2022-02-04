import 'package:matrix_api_lite/matrix_api_lite.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:matrix_homeserver_recommendations/src/models/homeserver.dart';

/// represents a [Homeserver] response time benchmark
class HomeserverBenchmarkResult extends Comparable {
  /// the [Homeserver] to be tested
  final Homeserver homeserver;

  /// the response time of the benchmark
  final Duration? responseTime;

  /// potential errors
  final BenchmarkErrorInformation? error;

  HomeserverBenchmarkResult(
      {required this.homeserver, this.responseTime, this.error});

  @override
  String toString() {
    return 'HomeserverBenchmarkResult( ${homeserver.baseUrl}: ${responseTime ?? error} )';
  }

  /// performs a response time benchmark
  ///
  /// [homeserver]: the [Homeserver] to test against
  /// [timeout]: the maximum [Duration] the benchmark may take
  static Future<HomeserverBenchmarkResult> benchmarkHomeserver(
      Homeserver homeserver,
      {Duration timeout = const Duration(seconds: 30)}) async {
    try {
      final api = MatrixApi(homeserver: homeserver.baseUrl);
      final startTime = DateTime.now();
      // performing the connection test with the given timeout
      await api.getVersions().timeout(timeout);
      final endTime = DateTime.now();

      final difference = startTime.difference(endTime);

      return HomeserverBenchmarkResult(
          homeserver: homeserver, responseTime: difference);
    } catch (e, s) {
      return HomeserverBenchmarkResult(
          homeserver: homeserver, error: BenchmarkErrorInformation(e, s));
    }
  }

  @override
  int compareTo(dynamic other) {
    if (other is! HomeserverBenchmarkResult ||
        responseTime == other.responseTime) return 0;
    if (responseTime == null) return 1;
    if (other.responseTime == null) return -1;
    return other.responseTime!.compareTo(responseTime!);
  }
}

/// error information in a non-working benchmark
class BenchmarkErrorInformation extends Error {
  /// the captured error
  final Object? error;
  @override
  final StackTrace stackTrace;

  BenchmarkErrorInformation(this.error, this.stackTrace);

  @override
  String toString() => error?.toString() ?? '';
}
