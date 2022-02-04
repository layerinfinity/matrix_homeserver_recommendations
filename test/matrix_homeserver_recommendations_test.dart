import 'package:test/test.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

void main() {
  group('joinMatrix.org homeserver parser', () {
    var joinMatrixParser = JoinmatrixOrgParser();

    test('Fetching servers', () async {
      final homeservers = await joinMatrixParser.fetchHomeservers();

      expect(homeservers.isNotEmpty, isTrue);

      final benchmark = await HomeserverListProvider.benchmarkHomeserver(
          homeservers,
          timeout: Duration(seconds: 10));
      expect(benchmark.isNotEmpty, isTrue);
    });
  });
}
