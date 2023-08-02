import 'credential.dart';

class CredentialVerifyUser {
  Credential credential;

  CredentialVerifyUser({
    required this.credential,
  });

  CredentialVerifyUser.fromJson(Map<String, dynamic> json)
      : credential =
            Credential.fromJson(json['credential'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {'credential': credential.toJson()};
}
