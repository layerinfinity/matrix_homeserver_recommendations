import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:matrix_homeserver_recommendations/src/parsers/joinmatrix_org_parser.dart';

Future<int> main() async {
  print('Loading homeservers from joinMatrix.org...');
  var joinMatrixParser = JoinmatrixOrgParser();
  final homeservers = await joinMatrixParser.fetchHomeservers();

  print('Found the following homeservers:');
  for (var server in homeservers) {
    print(server);
  }

  print('Performing response time benchmark...');
  final result = await HomeserverListProvider.benchmarkHomeserver(
    homeservers,
    timeout: Duration(seconds: 10),
    includeFailed: false,
  );
  print('The following response times were captured:');
  for (var benchmark in result) {
    print(benchmark);
  }
  print('Example completed.');
  return 0;
}
