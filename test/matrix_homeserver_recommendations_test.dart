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

  group('local homeserver parser', () {
    test('NO WAR!!!', () async {
      var server = LocalHomeserverParser('ua').fetchHomeservers().first;
      expect(server.baseUrl.host, 'gemeinsam.jetzt');
    });

    test('United States', () async {
      var server = LocalHomeserverParser('us').fetchHomeservers().first;
      expect(server.baseUrl.host, 'buyvm.net');
    });

    test('Russia', () async {
      var server = LocalHomeserverParser('ru').fetchHomeservers().first;
      expect(server.baseUrl.host, 'rumatrix.org');
    });

    test('Germany', () async {
      var server = LocalHomeserverParser('de').fetchHomeservers().first;
      expect(server.baseUrl.host, 'envs.de');
    });

    test('Invalid code', () async {
      var server = LocalHomeserverParser('tlh').fetchHomeservers();
      expect(server.isEmpty, isTrue);
    });
  });
}
