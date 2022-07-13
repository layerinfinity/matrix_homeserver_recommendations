import 'dart:developer';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

part 'homeserver_locale_map.dart';

/// Provides homeservers based on the provided [countryCode]
///
/// Always returns only a single [Homeserver] or an empty list.
class LocalHomeserverParser extends HomeserverListProvider {
  /// the country code the find the [Homeserver] for
  final String? countryCode;

  const LocalHomeserverParser(this.countryCode);

  @override
  List<Homeserver> fetchHomeservers() {
    if (countryCode == null) return [];
    String? hostname;
    final country = countryCode!.toLowerCase();
    try {
      if (_homeserverByLocale.containsKey(country)) {
        hostname = _homeserverByLocale[country];
      } else if (_countryCodeContinent.containsKey(country)) {
        final continent = _countryCodeContinent[country];
        hostname = _homeserverByContinent[continent];
      }
    } catch (e) {
      log('Error matching country code $country',
          name: 'matrix_homeserver_recommendations');
    }
    if (hostname != null) {
      return [Homeserver(baseUrl: Uri.https(hostname, ''))];
    }
    return [];
  }

  @override
  Uri get errorReportUrl => Uri.parse(
      'https://gitlab.com/TheOneWithTheBraid/matrix_homeserver_recommendations/-/issues/new');

  @override
  final Uri? externalUri = null;
}
