import '../../models/homeserver.dart';

/// creates a [Homeserver] parsed from
/// [joinMatrix.org](https://joinMatrix.org/)'s raw data
class JoinMatrixOrgServer extends Homeserver {
  JoinMatrixOrgServer.fromJson(Map<String, dynamic> json)
      : super(
          baseUrl: Uri.parse('https://' + json['domain']),
          aboutUrl: Uri.tryParse(json['info']),
          jurisdiction: json['jurisdiction'],
          rules: Uri.tryParse(json['tos']),
          privacyPolicy: Uri.tryParse(json['privacy']),
          registrationAllowed: json['open'],
          description: json['remarks'],
          antiFeatures: json['antifeature'],
          registration: Uri.tryParse(json['reg_link']),
          homeserverSoftware: json['software'] + ' ' + json['version'],
        );
}
