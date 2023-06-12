class ResulGetUserSessionInfo {
  GetUserSessionInfoResult? getUserSessionInfoResult;

  ResulGetUserSessionInfo({
    this.getUserSessionInfoResult,
  });

  ResulGetUserSessionInfo.fromJson(Map<String, dynamic> json)
      : getUserSessionInfoResult =
            (json['GetUserSessionInfoResult'] as Map<String, dynamic>?) != null
                ? GetUserSessionInfoResult.fromJson(
                    json['GetUserSessionInfoResult'] as Map<String, dynamic>)
                : null;

  Map<String, dynamic> toJson() =>
      {'GetUserSessionInfoResult': getUserSessionInfoResult?.toJson()};

  ResulGetUserSessionInfo errorRespuesta(int statusCode) {
    final respuesta = ResulGetUserSessionInfo();
    respuesta.getUserSessionInfoResult = GetUserSessionInfoResult();
    if (statusCode == 404) {
      respuesta.getUserSessionInfoResult?.message = "servicio no encontrado";
      respuesta.getUserSessionInfoResult?.state = 404;
    } else if (statusCode == 500) {
      respuesta.getUserSessionInfoResult?.message =
          "No se puede acceder al servidor";
      respuesta.getUserSessionInfoResult?.state = 500;
    } else {
      respuesta.getUserSessionInfoResult?.message =
          "Error inesperado al consumir el servicio";
      respuesta.getUserSessionInfoResult?.state = 600;
    }
    return respuesta;
  }
}

class GetUserSessionInfoResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  ObjectGetUserSessionInfoResult? objectGetUserSessionInfoResult;

  GetUserSessionInfoResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.objectGetUserSessionInfoResult,
  });

  GetUserSessionInfoResult.fromJson(Map<String, dynamic> json)
      : codeBase = json['CodeBase'] as String?,
        message = json['Message'] as String?,
        state = json['State'] as int?,
        code = json['Code'] as String?,
        objectGetUserSessionInfoResult =
            (json['Object'] as Map<String, dynamic>?) != null
                ? ObjectGetUserSessionInfoResult.fromJson(
                    json['Object'] as Map<String, dynamic>)
                : null;

  Map<String, dynamic> toJson() => {
        'CodeBase': codeBase,
        'Message': message,
        'State': state,
        'Code': code,
        'Object': objectGetUserSessionInfoResult?.toJson()
      };
}

class ObjectGetUserSessionInfoResult {
  String? cellPhoneNumber;
  String? contractMessage;
  double? currencyExchangeBuy;
  double? currencyExchangeSell;
  String? email;
  String? estado;
  bool? hasContractPending;
  String? identityCardNumber;
  bool? isCallCenter;
  bool? isETV;
  bool? isEmployee;
  bool? isPersonNatural;
  List<ListAds>? listAds;
  // List<dynamic>? listCodeCreditLine;
  // List<dynamic>? listCodeLoanFlowCredit;
  List<ListCodeSavingsAccount>? listCodeSavingsAccount;
  //List<dynamic>? listElectronicWallet;
  double? maximumAmount;
  //double? maximumElectronicWalletAmount;
  String? personName;
  String? processDate;
  bool? sendEmailNotification;
  String? userName;
  String? sIdPerson;
  String? sIdWebClient;
  String? sIdcQuestion;
  String? sUserId;

  ObjectGetUserSessionInfoResult({
    this.cellPhoneNumber,
    this.contractMessage,
    this.currencyExchangeBuy,
    this.currencyExchangeSell,
    this.email,
    this.estado,
    this.hasContractPending,
    this.identityCardNumber,
    this.isCallCenter,
    this.isETV,
    this.isEmployee,
    this.isPersonNatural,
    this.listAds,
    // this.listCodeCreditLine,
    // this.listCodeLoanFlowCredit,
    this.listCodeSavingsAccount,
    //this.listElectronicWallet,
    this.maximumAmount,
    //this.maximumElectronicWalletAmount,
    this.personName,
    this.processDate,
    this.sendEmailNotification,
    this.userName,
    this.sIdPerson,
    this.sIdWebClient,
    this.sIdcQuestion,
    this.sUserId,
  });

  ObjectGetUserSessionInfoResult.fromJson(Map<String, dynamic> json)
      : cellPhoneNumber = json['CellPhoneNumber'] as String?,
        contractMessage = json['ContractMessage'] as String?,
        currencyExchangeBuy = json['CurrencyExchangeBuy'] == 0
            ? json['CurrencyExchangeBuy'].toDouble()
            : json['CurrencyExchangeBuy'] as double?,
        currencyExchangeSell = json['CurrencyExchangeSell'] == 0
            ? json['CurrencyExchangeSell'].toDouble()
            : json['CurrencyExchangeSell'] as double?,
        email = json['Email'] as String?,
        estado = json['Estado'] as String?,
        hasContractPending = json['HasContractPending'] as bool?,
        identityCardNumber = json['IdentityCardNumber'] as String?,
        isCallCenter = json['IsCallCenter'] as bool?,
        isETV = json['IsETV'] as bool?,
        isEmployee = json['IsEmployee'] as bool?,
        isPersonNatural = json['IsPersonNatural'] as bool?,
        listAds = (json['ListAds'] as List?)
            ?.map((dynamic e) => ListAds.fromJson(e as Map<String, dynamic>))
            .toList(),
        // listCodeCreditLine = json['ListCodeCreditLine'] as List?,
        // listCodeLoanFlowCredit = json['ListCodeLoanFlowCredit'] as List?,
        listCodeSavingsAccount = (json['ListCodeSavingsAccount'] as List?)
            ?.map((dynamic e) =>
                ListCodeSavingsAccount.fromJson(e as Map<String, dynamic>))
            .toList(),
        // listElectronicWallet = json['ListElectronicWallet'] as List?,
        maximumAmount = json['MaximumAmount'].toDouble(),
        //maximumElectronicWalletAmount =json['MaximumElectronicWalletAmount'] as Int?,
        personName = json['PersonName'] as String?,
        processDate = json['ProcessDate'] as String?,
        sendEmailNotification = json['SendEmailNotification'] as bool?,
        userName = json['UserName'] as String?,
        sIdPerson = json['sIdPerson'] as String?,
        sIdWebClient = json['sIdWebClient'] as String?,
        sIdcQuestion = json['sIdcQuestion'] as String?,
        sUserId = json['sUserId'] as String?;

  Map<String, dynamic> toJson() => {
        'CellPhoneNumber': cellPhoneNumber,
        'ContractMessage': contractMessage,
        'CurrencyExchangeBuy': currencyExchangeBuy,
        'CurrencyExchangeSell': currencyExchangeSell,
        'Email': email,
        'Estado': estado,
        'HasContractPending': hasContractPending,
        'IdentityCardNumber': identityCardNumber,
        'IsCallCenter': isCallCenter,
        'IsETV': isETV,
        'IsEmployee': isEmployee,
        'IsPersonNatural': isPersonNatural,
        'ListAds': listAds?.map((e) => e.toJson()).toList(),
        // 'ListCodeCreditLine': listCodeCreditLine,
        // 'ListCodeLoanFlowCredit': listCodeLoanFlowCredit,
        'ListCodeSavingsAccount':
            listCodeSavingsAccount?.map((e) => e.toJson()).toList(),
        //'ListElectronicWallet': listElectronicWallet,
        'MaximumAmount': maximumAmount,
        //'MaximumElectronicWalletAmount': maximumElectronicWalletAmount,
        'PersonName': personName,
        'ProcessDate': processDate,
        'SendEmailNotification': sendEmailNotification,
        'UserName': userName,
        'sIdPerson': sIdPerson,
        'sIdWebClient': sIdWebClient,
        'sIdcQuestion': sIdcQuestion,
        'sUserId': sUserId
      };
}

class ListAds {
  String? imageUrl;
  String? linkToGo;
  int? orderSequence;
  int? typeToLink;
  bool? withAnimation;

  ListAds({
    this.imageUrl,
    this.linkToGo,
    this.orderSequence,
    this.typeToLink,
    this.withAnimation,
  });

  ListAds.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'] as String?,
        linkToGo = json['linkToGo'] as String?,
        orderSequence = json['orderSequence'] as int?,
        typeToLink = json['typeToLink'] as int?,
        withAnimation = json['withAnimation'] as bool?;

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'linkToGo': linkToGo,
        'orderSequence': orderSequence,
        'typeToLink': typeToLink,
        'withAnimation': withAnimation
      };
}

class ListCodeSavingsAccount {
  double? availableAmount;
  String? codMoney;
  int? idMoney;
  int? idOffice;
  int? idOperationEntity;
  String? operationCode;

  ListCodeSavingsAccount({
    this.availableAmount,
    this.codMoney,
    this.idMoney,
    this.idOffice,
    this.idOperationEntity,
    this.operationCode,
  });

  ListCodeSavingsAccount.fromJson(Map<String, dynamic> json)
      : availableAmount = json['AvailableAmount'] as double?,
        codMoney = json['CodMoney'] as String?,
        idMoney = json['IdMoney'] as int?,
        idOffice = json['IdOffice'] as int?,
        idOperationEntity = json['IdOperationEntity'] as int?,
        operationCode = json['OperationCode'] as String?;

  Map<String, dynamic> toJson() => {
        'AvailableAmount': availableAmount,
        'CodMoney': codMoney,
        'IdMoney': idMoney,
        'IdOffice': idOffice,
        'IdOperationEntity': idOperationEntity,
        'OperationCode': operationCode
      };
}
