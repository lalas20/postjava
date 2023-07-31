

class SavingsAccountExtractDataTransactionableResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  ObjDataTrans? object;

  SavingsAccountExtractDataTransactionableResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.object,
  });

  SavingsAccountExtractDataTransactionableResult.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'];
    message = json['Message'] as String?;
    state = json['State'] as int?;
    code = json['Code'];
    object = (json['Object'] as Map<String,dynamic>?) != null ? ObjDataTrans.fromJson(json['Object'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['CodeBase'] = codeBase;
    json['Message'] = message;
    json['State'] = state;
    json['Code'] = code;
    json['Object'] = object?.toJson();
    return json;
  }

  SavingsAccountExtractDataTransactionableResult errorRespuesta(int statusCode) {
    final respuesta = SavingsAccountExtractDataTransactionableResult();
    if (statusCode == 404) {
      respuesta.message = "servicio no encontrado";
      respuesta.state = 404;
    } else if (statusCode == 500) {
      respuesta.message = "No se puede acceder al servidor";
      respuesta.state = 500;
    } else {
      respuesta.message =
      "Error inesperado al consumir el servicio";
      respuesta.state = 600;
    }
    return respuesta;
  }
}

class ObjDataTrans {
  double? accountAvailableBalance;
  double? accountBalance;
  String? codeSavingsAccount;
  List<ColDetailsMovemment>? colDetailsMovemment;
  List<ColDetailsMovemment>? colMovemmentPendings;
  String? messageInvoicingProof;
  String? moneyCode;
  String? processDate;

  ObjDataTrans({
    this.accountAvailableBalance,
    this.accountBalance,
    this.codeSavingsAccount,
    this.colDetailsMovemment,
    this.colMovemmentPendings,
    this.messageInvoicingProof,
    this.moneyCode,
    this.processDate,
  });

  ObjDataTrans.fromJson(Map<String, dynamic> json) {
    accountAvailableBalance = json['AccountAvailableBalance'] as double?;
    accountBalance = json['AccountBalance'] as double?;
    codeSavingsAccount = json['CodeSavingsAccount'] as String?;
    colDetailsMovemment = (json['ColDetailsMovemment'] as List?)?.map((dynamic e) => ColDetailsMovemment.fromJson(e as Map<String,dynamic>)).toList();
    colMovemmentPendings = (json['ColMovemmentPendings'] as List?)?.map((dynamic e) => ColDetailsMovemment.fromJson(e as Map<String,dynamic>)).toList();
    messageInvoicingProof = json['MessageInvoicingProof'] as String?;
    moneyCode = json['MoneyCode'] as String?;
    processDate = json['ProcessDate'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['AccountAvailableBalance'] = accountAvailableBalance;
    json['AccountBalance'] = accountBalance;
    json['CodeSavingsAccount'] = codeSavingsAccount;
    json['ColDetailsMovemment'] = colDetailsMovemment?.map((e) => e.toJson()).toList();
    json['ColMovemmentPendings'] = colMovemmentPendings?.map((e) => e.toJson()).toList();
    json['MessageInvoicingProof'] = messageInvoicingProof;
    json['MoneyCode'] = moneyCode;
    json['ProcessDate'] = processDate;
    return json;
  }
}

class ColDetailsMovemment {
  double? amountBalance;
  String? dateTransaction;
  double? deposit;
  String? descriptionOperation;
  String? officeTransaction;
  String? reference;
  double? withdrawal;

  ColDetailsMovemment({
    this.amountBalance,
    this.dateTransaction,
    this.deposit,
    this.descriptionOperation,
    this.officeTransaction,
    this.reference,
    this.withdrawal,
  });

  ColDetailsMovemment.fromJson(Map<String, dynamic> json) {
    amountBalance =json['AmountBalance']==0? 0.toDouble():json['AmountBalance'] as double?;
    dateTransaction = json['DateTransaction'] as String?;
    deposit = json['Deposit']==0? 0.toDouble():json['Deposit'] as double?;
    descriptionOperation = json['DescriptionOperation'] as String?;
    officeTransaction = json['OfficeTransaction'] as String?;
    reference = json['Reference'] as String?;
    withdrawal = json['Withdrawal']==0? 0.toDouble(): json['Withdrawal'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['AmountBalance'] = amountBalance;
    json['DateTransaction'] = dateTransaction;
    json['Deposit'] = deposit;
    json['DescriptionOperation'] = descriptionOperation;
    json['OfficeTransaction'] = officeTransaction;
    json['Reference'] = reference;
    json['Withdrawal'] = withdrawal;
    return json;
  }
}