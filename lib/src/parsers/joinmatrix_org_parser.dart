import 'dart:async';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:http/http.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

class JoinmatrixOrgParser extends HomeserverListProvider {
  static const _csvUrl =
      'https://raw.githubusercontent.com/austinhuang0131/joinmatrix/main/_includes/matrix_prod.md';

  @override
  FutureOr<List<Homeserver>> fetchHomeservers() async {
    final response = await get(Uri.parse(_csvUrl));
    if (response.statusCode != 200) {
      log('Canceling homeserver parsing as HTTP status code ${response.statusCode}');
      return [];
    }
    String document = response.body;
    try {
      // someone once told me it is a bad idea to parse HTML using regex. Maybe
      // parsing MarkDown is better?
      document =
          document.replaceFirst(RegExp(r'^###[^\|]+\|', multiLine: true), '');
      document =
          document.replaceFirst(RegExp(r'^###[\w\W]+$', multiLine: true), '');
      document = document.replaceFirst(
          RegExp(r'\|[\s\S\n]*- \|$', multiLine: true), '');
      document =
          document.replaceAll(RegExp(r'((^\|)|(\|$))', multiLine: true), '"');
      document = document.replaceAll('|', '"|"');

      final csv = CsvToListConverter(
        fieldDelimiter: '|',
        allowInvalid: false,
        textDelimiter: '"',
        shouldParseNumbers: false,
        eol: '\n',
      ).convert(document);

      csv.removeWhere((line) => line.isEmpty);

      final homeservers = <Homeserver>[];
      for (var element in csv) {
        try {
          homeservers.add(
            Homeserver(
              baseUrl: parseMarkdownLink(element[0])!,
              jurisdiction: element[1].trim(),
              rules: parseMarkdownLink(element[2]),
              privacyPolicy: parseMarkdownLink(element[3]),
              antiFeatures: element[4].trim(),
              description: element[5].trim(),
              registration: parseMarkdownLink(element[6]),
              registrationAllowed: true,
              homeserverSoftware: element[7],
            ),
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

  Uri? parseMarkdownLink(String markdown) {
    final match = RegExp(r'\[(.*)\]\((.+)\)').firstMatch(markdown);
    if (match == null) return null;
    return Uri.parse(match.group(2)!);
  }

  @override
  Uri errorReportUrl =
      Uri.parse('https://matrix.to/#/#public_servers:tchncs.de');

  @override
  Uri externalUri = Uri.parse('https://joinmatrix.org/servers/');
}