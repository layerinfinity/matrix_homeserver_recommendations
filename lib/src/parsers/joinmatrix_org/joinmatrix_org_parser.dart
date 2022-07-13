import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

/// Provides homeservers based on
/// [joinMatrix.org](https://joinmatrix.org/server)'s list.
class JoinmatrixOrgParser extends HomeserverListProvider {
  const JoinmatrixOrgParser();

  static const _jsonUrl = 'https://joinmatrix.org/servers.json';

  @override
  FutureOr<List<Homeserver>> fetchHomeservers() async {
    final response = await get(Uri.parse(_jsonUrl));
    if (response.statusCode != 200) {
      log('Canceling homeserver parsing as HTTP status code ${response.statusCode}');
      return [];
    }
    String document = response.body;
    try {
      final json = List.from(jsonDecode(document));
      final homeservers = <Homeserver>[];
      for (var element in json) {
        try {
          homeservers.add(
            JoinMatrixOrgServer.fromJson(element),
          );
        } catch (e) {
          log('Couldn\'t parse homeserver from $element');
        }
      }
      return homeservers;
    } catch (e, s) {
      log('Couldn\'t parse document because of: $e', stackTrace: s);
      return [];
    }
  }

  @override
  Uri get errorReportUrl =>
      Uri.parse('https://matrix.to/#/#public_servers:tchncs.de');

  @override
  Uri get externalUri => Uri.parse('https://joinmatrix.org/servers/');
}
