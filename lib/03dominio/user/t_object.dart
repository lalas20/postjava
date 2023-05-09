import 'aditional_item.dart';

class TObject {
  final List<AditionalItems>? aditionalItems;
  final String? user;
  final String? token;

  TObject({
    this.aditionalItems,
    this.user,
    this.token,
  });

  TObject.fromJson(Map<String, dynamic> json)
      : aditionalItems = (json['AditionalItems'] as List?)
            ?.map((dynamic e) =>
                AditionalItems.fromJson(e as Map<String, dynamic>))
            .toList(),
        user = json['User'] as String?,
        token = json['token'] as String?;

  Map<String, dynamic> toJson() => {
        'AditionalItems': aditionalItems?.map((e) => e.toJson()).toList(),
        'User': user,
        'token': token
      };
}
