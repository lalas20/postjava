import 't_object.dart';

class VerifyUserResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  TObject? object;

  VerifyUserResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.object,
  });

  VerifyUserResult.fromJson(Map<String, dynamic> json)
      : codeBase = json['CodeBase'],
        message = json['Message'],
        state = json['State'] as int?,
        code = json['Code'] as String?,
        object = (json['Object'] as Map<String, dynamic>?) != null
            ? TObject.fromJson(json['Object'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'CodeBase': codeBase,
        'Message': message,
        'State': state,
        'Code': code,
        'Object': object?.toJson()
      };
}
