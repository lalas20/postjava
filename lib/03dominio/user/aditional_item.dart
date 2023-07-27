class AditionalItems {
   String? groupName;
   String? key;
   String? value;

  AditionalItems({
    this.groupName,
    this.key,
    this.value,
  });

  AditionalItems.fromJson(Map<String, dynamic> json)
      : groupName = json['GroupName'] as String?,
        key = json['Key'] as String?,
        value = json['Value'] as String?;

  Map<String, dynamic> toJson() =>
      {'Key': key, 'Value': value, 'GroupName': groupName};
}
