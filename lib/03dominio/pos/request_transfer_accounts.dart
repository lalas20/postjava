class RequestTransferAccounts {
  ObjParameter? objParameter;

  RequestTransferAccounts({
    this.objParameter,
  });

  RequestTransferAccounts.fromJson(Map<String, dynamic> json) {
    objParameter = (json['ObjParameter'] as Map<String,dynamic>?) != null ? ObjParameter.fromJson(json['ObjParameter'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['ObjParameter'] = objParameter?.toJson();
    return json;
  }
}

class ObjParameter {
  String? codeSavingAccount;
  String? idMoneyTrans;
  double? amountTrans;
  String? codeSavingAccountTarget;

  ObjParameter({
    this.codeSavingAccount,
    this.idMoneyTrans,
    this.amountTrans,
    this.codeSavingAccountTarget,
  });

  ObjParameter.fromJson(Map<String, dynamic> json) {
    codeSavingAccount = json['CodeSavingAccount'] as String?;
    idMoneyTrans = json['IdMoneyTrans'] as String?;
    amountTrans = json['AmountTrans'] as double?;
    codeSavingAccountTarget = json['CodeSavingAccountTarget'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['CodeSavingAccount'] = codeSavingAccount;
    json['IdMoneyTrans'] = idMoneyTrans;
    json['AmountTrans'] = amountTrans;
    json['CodeSavingAccountTarget'] = codeSavingAccountTarget;
    return json;
  }
}