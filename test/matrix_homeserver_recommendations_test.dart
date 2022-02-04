import 'package:test/test.dart';

import 'package:matrix_homeserver_recommendations/src/parsers/joinmatrix_org_parser.dart';

void main() {
  group('joinMatrix.org homeserver parser', () {
    var joinMatrixParser = JoinmatrixOrgParser();

    test('Fetching servers', () async {
      final homeservers = await joinMatrixParser.fetchHomeservers();

      expect(homeservers.isNotEmpty, isTrue);
    });
  });
}
