import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

class JoinmatrixOrgParser extends HomeserverListProvider {
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
        } catch (e, s) {
          log('Couldn\'t parse homeserver from $element', stackTrace: s);
        }
      }
      return homeservers;
    } catch (e, s) {
      log('Couldn\'t parse document because of: $e', stackTrace: s);
      return [];
    }
  }

  @override
  Uri errorReportUrl =
      Uri.parse('https://matrix.to/#/#public_servers:tchncs.de');

  @override
  Uri externalUri = Uri.parse('https://joinmatrix.org/servers/');
}
