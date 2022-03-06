/// provides information about a Matrix homeserver
class Homeserver {
  /// the server's API base URL
  final Uri baseUrl;

  /// a link to get information about the service at
  final Uri? aboutUrl;

  /// a description for the homeserver
  final String? description;

  /// the homeserver software used
  final String? homeserverSoftware;

  /// a link to the server's rules
  final Uri? rules;

  /// a link to the server's privacy policy
  final Uri? privacyPolicy;

  /// the jurisdication of the server
  final String? jurisdiction;

  /// reasons not to use the server
  final String? antiFeatures;

  /// whether the server allows registration
  final bool? registrationAllowed;

  /// in case required, an external registration link
  final Uri? registration;

  const Homeserver({
    required this.baseUrl,
    this.aboutUrl,
    this.description,
    this.homeserverSoftware,
    this.rules,
    this.privacyPolicy,
    this.jurisdiction,
    this.antiFeatures,
    this.registrationAllowed,
    this.registration,
  });

  @override
  String toString() =>
      "Homeserver( $baseUrl, $aboutUrl, $description, $homeserverSoftware, $rules, $privacyPolicy, $jurisdiction, $antiFeatures, $registrationAllowed, $registration )";
}
