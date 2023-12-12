class RequestPosData {
  RequestDTOWebPosDevice? pPosData;

  RequestPosData({this.pPosData});

  RequestPosData.fromJson(Map<String, dynamic> json) {
    pPosData = json['pPosData'] != null
        ? RequestDTOWebPosDevice.fromJson(json['pPosData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pPosData != null) {
      data['pPosData'] = pPosData!.toJson();
    }
    return data;
  }
}

class RequestDTOWebPosDevice {
  String? codPosDevice;
  int? idcState;
  String? idWebPersonClient;
  String? operation;
  String? posData;
  String? namePOS;
  RequestDTOWebPosDevice({
    this.codPosDevice,
    this.idWebPersonClient,
    this.idcState,
    this.operation,
    this.posData,
    this.namePOS,
  });
  RequestDTOWebPosDevice.fromJson(Map<String, dynamic> json) {
    codPosDevice = json['CodPosDevice'];
    idWebPersonClient = json['IdWebPersonClient'].toString();
    idcState = json['IdcState'];
    operation = json['Operation'];
    posData = (json['PosData']);
    namePOS = (json['NamePOS']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodPosDevice'] = codPosDevice;
    data['IdWebPersonClient'] = idWebPersonClient;
    data['IdcState'] = idcState;
    data['Operation'] = operation;
    data['PosData'] = posData;
    data['NamePOS'] = namePOS;
    return data;
  }
}

class DTOWebPosDevice {
  String? agencia;
  String? codPosDevice;
  int? idOffice;
  int? idUser;
  String? idWebPersonClient;
  String? idWebPosDevice;
  int? idcState;
  String? namePersonClient;
  String? operation;
  String? posData;
  String? processDate;
  String? processDatetxt;
  String? state;
  String? usuarioRegistro;

  DTOWebPosDevice(
      {this.agencia,
      this.codPosDevice,
      this.idOffice,
      this.idUser,
      this.idWebPersonClient,
      this.idWebPosDevice,
      this.idcState,
      this.namePersonClient,
      this.operation,
      this.posData,
      this.processDate,
      this.processDatetxt,
      this.state,
      this.usuarioRegistro});

  DTOWebPosDevice.fromJson(Map<String, dynamic> json) {
    agencia = json['Agencia'];
    codPosDevice = json['CodPosDevice'];
    idOffice = json['IdOffice'];
    idUser = json['IdUser'];
    idWebPersonClient = json['IdWebPersonClient'].toString();
    idWebPosDevice = json['IdWebPosDevice'].toString();
    idcState = json['IdcState'];
    namePersonClient = json['NamePersonClient'];
    operation = json['Operation'];
    posData = json['PosData'];
    processDate = json['ProcessDate'];
    processDatetxt = json['ProcessDatetxt'];
    state = json['State'];
    usuarioRegistro = json['UsuarioRegistro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Agencia'] = agencia;
    data['CodPosDevice'] = codPosDevice;
    data['IdOffice'] = idOffice;
    data['IdUser'] = idUser;
    data['IdWebPersonClient'] = idWebPersonClient;
    data['IdWebPosDevice'] = idWebPosDevice;
    data['IdcState'] = idcState;
    data['NamePersonClient'] = namePersonClient;
    data['Operation'] = operation;
    data['PosData'] = posData;
    data['ProcessDate'] = processDate;
    data['ProcessDatetxt'] = processDatetxt;
    data['State'] = state;
    data['UsuarioRegistro'] = usuarioRegistro;
    return data;
  }
}

//****resull*/
class ResulDTOWebPosDevice {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  DTOWebPosDevice? object;

  ResulDTOWebPosDevice(
      {this.codeBase, this.message, this.state, this.code, this.object});

  ResulDTOWebPosDevice.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'];
    message = json['Message'];
    state = json['State'];
    code = json['Code'];
    //object = json['Object'];
    object = (json['Object'] as Map<String, dynamic>?) != null
        ? DTOWebPosDevice.fromJson(json['Object'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodeBase'] = codeBase;
    data['Message'] = message;
    data['State'] = state;
    data['Code'] = code;
    data['Object'] = object;
    return data;
  }

  ResulDTOWebPosDevice errorRespuesta(int statusCode) {
    final respuesta = ResulDTOWebPosDevice();
    if (statusCode == 404) {
      respuesta.message = "servicio no encontrado";
      respuesta.state = 404;
    } else if (statusCode == 500) {
      respuesta.message = "No se puede acceder al servidor";
      respuesta.state = 500;
    } else {
      respuesta.message = "Error inesperado al consumir el servicio";
      respuesta.state = 600;
    }
    return respuesta;
  }
}
