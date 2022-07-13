import 'dart:async';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

/// implements to fetch a [List] of [Homeserver] and provides metadata
abstract class HomeserverListProvider {
  const HomeserverListProvider();

  /// an Uri to report errors to
  ///
  /// Might be an HTTPS link, Email or Matrix-ID e.g.
  Uri? get errorReportUrl;

  /// the location to find the list standalone
  Uri? get externalUri;

  /// lists all homeversers of this provider
  FutureOr<List<Homeserver>> fetchHomeservers();

  /// performs a response time benchmark
  ///
  /// returns a sorted [List] of [HomeserverBenchmarkResult]
  ///
  /// [homeservers]: all [Homeserver] to test
  /// [timeout]: the maximum [Duration] the benchmark may take
  /// [includeFailed]: whether to include results completed with error
  /// [filter]: the [MatrixHomeserverFilter] function to filter the homeserver
  /// by the given API
  static Future<List<HomeserverBenchmarkResult>> benchmarkHomeserver(
    List<Homeserver> homeservers, {
    Duration timeout = const Duration(seconds: 30),
    bool includeFailed = false,
    MatrixHomeserverFilter? filter,
  }) async =>
      Future.wait(homeservers
              .map(
                (e) => HomeserverBenchmarkResult.benchmarkHomeserver(
                  e,
                  timeout: timeout,
                  filter: filter,
                ),
              )
              .toList())
          .then(
        (completedBenchmarks) {
          if (!includeFailed) {
            completedBenchmarks = completedBenchmarks
                .where(
                  (benchmark) =>
                      benchmark.responseTime != null && benchmark.error == null,
                )
                .toList();
          }
          completedBenchmarks.sort();
          return completedBenchmarks;
        },
      );
}
