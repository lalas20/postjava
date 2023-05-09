import 'aditional_item.dart';

class Credential {
  String user;
  String password;
  int channel;
  List<AditionalItems> aditionalItems;

  Credential({
    required this.user,
    required this.password,
    required this.channel,
    required this.aditionalItems,
  });
  Credential.fromJson(Map<String, dynamic> json)
      : user = json['User'] as String,
        password = json['Password'] as String,
        channel = json['Channel'] as int,
        aditionalItems = (json['AditionalItems'] as List)
            .map((dynamic e) =>
                AditionalItems.fromJson(e as Map<String, dynamic>))
            .toList();

  // Credential.fromJson(Map<String, dynamic> json)
  //     : user = json['User'] as String?,
  //       password = json['Password'] as String?,
  //       channel = json['Channel'] as int?,
  //       aditionalItems = (json['AditionalItems'] as List?)
  //           ?.map((dynamic e) =>
  //               AditionalItems.fromJson(e as Map<String, dynamic>))
  //           .toList();

  Map<String, dynamic> toJson() => {
        'User': user,
        'Password': password,
        'Channel': channel,
        'AditionalItems': aditionalItems.map((e) => e.toJson()).toList()
      };
}
