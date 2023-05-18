import 'package:shared_preferences/shared_preferences.dart';

class UtilPreferences {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

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
}
