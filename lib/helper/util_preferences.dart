import 'package:shared_preferences/shared_preferences.dart';

class UtilPreferences {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const _keysIdPerson = 'sIdPerson';
  static Future setsIdPerson(String psIdPerson) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keysIdPerson, psIdPerson);
  }

  static String getsIdPerson({String defValue = '0'}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keysIdPerson) ?? defValue;
  }

  static const _keyIdUsuario = 'IdUsuario';
  static Future setIdUsuario(String pIdUsuario) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyIdUsuario, pIdUsuario);
  }

  static String getIdUsuario({String defValue = '0'}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyIdUsuario) ?? defValue;
  }

  static const _keyIdWebPersonClient = 'IdWebPersonClient';
  static Future setIdWebPersonClient(String pIdWebPersonClient) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyIdWebPersonClient, pIdWebPersonClient);
  }

  static String getIdWebPersonClient({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyIdWebPersonClient) ?? defValue;
  }

  static const _keyUser = 'User';
  static Future setUser(String pUser) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyUser, pUser);
  }

  static String getUser({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyUser) ?? defValue;
  }

  static const _keyToken = 'token';
  static Future setToken(String pToken) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyToken, pToken);
  }

  static String getToken({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyToken) ?? defValue;
  }

  static const _keyIdOperationEntity = 'IdOperationEntity';
  static Future setIdOperationEntity(int pIdOperationEntity) async {
    if (_preferences == null) return null;
    await _preferences!.setInt(_keyIdOperationEntity, pIdOperationEntity);
  }

  static int getIdOperationEntity({int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences!.getInt(_keyIdOperationEntity) ?? defValue;
  }

  static const _keyClientePos = 'ClientePos';
  static Future setClientePos(String pClientePos) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyClientePos, pClientePos);
  }

  static String getClientePos({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyClientePos) ?? defValue;
  }

  static const _keyAcount = 'Acount';
  static Future setAcount(String pAcount) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyAcount, pAcount);
  }

  static String getAcount({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyAcount) ?? defValue;
  }

  static const _keyCodMoney = 'CodMoney';
  static Future setCodMoney(String pCodMoney) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyCodMoney, pCodMoney);
  }

  static String getCodMoney({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyCodMoney) ?? defValue;
  }

/*name pos*/
  static const _keyNamePos = 'NamePos';
  static Future setNamePos(String pNamePos) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyNamePos, pNamePos);
  }

  static String getNamePos({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyNamePos) ?? defValue;
  }

  static const _keyIsSetting = 'IsSetting';
  static Future setIsSetting(bool pIsSetting) async {
    if (_preferences == null) return null;
    await _preferences!.setBool(_keyIsSetting, pIsSetting);
  }

  static bool getIsSetting() {
    if (_preferences == null) return false;
    return _preferences!.getBool(_keyIsSetting) ?? false;
  }

  static const _keyIdPosDevice = 'IdPosDevice';
  static Future setIdPosDevice(String? pIdPosDevice) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyIdPosDevice, pIdPosDevice ?? '');
  }

  static String getIdPosDevice({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyIdPosDevice) ?? defValue;
  }

  static const _keyCodPosDevice = 'CodPosDevice';
  static Future setCoddPosDevice(String? pCodPosDevice) async {
    if (_preferences == null) return null;
    await _preferences!.setString(_keyCodPosDevice, pCodPosDevice ?? '');
  }

  static String getCodPosDevice({String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(_keyCodPosDevice) ?? defValue;
  }
}
