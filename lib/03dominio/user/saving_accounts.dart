class SavingAccounts {
  final double? accountAvailableBalance;
  final double? accountBalance;
  final bool? belongsCard;
  final String? codeAccount;
  final String? moneyDescription;
  final List<ColHolders>? colHolders;
  final String? idSavingsAccount;
  final int? idcManagementWay;
  final int? idcPersonType;
  final dynamic message;
  final String? productName;
  final int? stateReal;
  final String? stateStateDescription;
  final int? vStateAccount;

  SavingAccounts({
    this.accountAvailableBalance,
    this.accountBalance,
    this.belongsCard,
    this.codeAccount,
    this.moneyDescription,
    this.colHolders,
    this.idSavingsAccount,
    this.idcManagementWay,
    this.idcPersonType,
    this.message,
    this.productName,
    this.stateReal,
    this.stateStateDescription,
    this.vStateAccount,
  });

  SavingAccounts.fromJson(Map<String, dynamic> json)
      : accountAvailableBalance = json['AccountAvailableBalance'] as double?,
        accountBalance = json['AccountBalance'] as double?,
        belongsCard = json['BelongsCard'] as bool?,
        codeAccount = json['CodeAccount'] as String?,
        moneyDescription = json['MoneyDescription'] as String?,
        colHolders = (json['ColHolders'] as List?)?.map((dynamic e) => ColHolders.fromJson(e as Map<String,dynamic>)).toList(),
        idSavingsAccount = json['IdSavingsAccount'] as String?,
        idcManagementWay = json['IdcManagementWay'] as int?,
        idcPersonType = json['IdcPersonType'] as int?,
        message = json['Message'],
        productName = json['ProductName'] as String?,
        stateReal = json['StateReal'] as int?,
        stateStateDescription = json['StateStateDescription'] as String?,
        vStateAccount = json['vStateAccount'] as int?;

  Map<String, dynamic> toJson() => {
    'AccountAvailableBalance' : accountAvailableBalance,
    'AccountBalance' : accountBalance,
    'BelongsCard' : belongsCard,
    'CodeAccount' : codeAccount,
    'MoneyDescription' : moneyDescription,
    'ColHolders' : colHolders?.map((e) => e.toJson()).toList(),
    'IdSavingsAccount' : idSavingsAccount,
    'IdcManagementWay' : idcManagementWay,
    'IdcPersonType' : idcPersonType,
    'Message' : message,
    'ProductName' : productName,
    'StateReal' : stateReal,
    'StateStateDescription' : stateStateDescription,
    'vStateAccount' : vStateAccount
  };
}

class ColHolders {
  final String? codeCustomer;
  final String? idPerson;
  final String? identityCardNumber;
  final bool? isAuthorized;
  final String? name;
  final bool? isExternalPerson;

  ColHolders({
    this.codeCustomer,
    this.idPerson,
    this.identityCardNumber,
    this.isAuthorized,
    this.name,
    this.isExternalPerson,
  });

  ColHolders.fromJson(Map<String, dynamic> json)
      : codeCustomer = json['CodeCustomer'] as String?,
        idPerson = json['IdPerson'] as String?,
        identityCardNumber = json['IdentityCardNumber'] as String?,
        isAuthorized = json['IsAuthorized'] as bool?,
        name = json['Name'] as String?,
        isExternalPerson = json['IsExternalPerson'] as bool?;

  Map<String, dynamic> toJson() => {
    'CodeCustomer' : codeCustomer,
    'IdPerson' : idPerson,
    'IdentityCardNumber' : identityCardNumber,
    'IsAuthorized' : isAuthorized,
    'Name' : name,
    'IsExternalPerson' : isExternalPerson
  };
}