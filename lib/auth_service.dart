import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const _kEmail = 'auth_email';
  static const _kPassword = 'auth_password';
  static const _kLoggedIn = 'auth_logged_in';

  String? _email;
  String? _password;
  bool _loggedIn = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString(_kEmail);
    _password = prefs.getString(_kPassword);
    _loggedIn = prefs.getBool(_kLoggedIn) ?? false;
  }

  bool get hasAccount => _email != null && _password != null;
  bool get isLoggedIn => _loggedIn;
  String? get savedEmail => _email;

  // Đăng ký: LƯU tài khoản nhưng KHÔNG tự đăng nhập
  Future<void> register({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    _email = email;
    _password = password;
    _loggedIn = false;

    await prefs.setString(_kEmail, email);
    await prefs.setString(_kPassword, password);
    await prefs.setBool(_kLoggedIn, false);
  }

  Future<bool> login({required String email, required String password}) async {
    if (!hasAccount) return false;

    final ok = (_email == email && _password == password);
    final prefs = await SharedPreferences.getInstance();

    _loggedIn = ok;
    await prefs.setBool(_kLoggedIn, ok);

    return ok;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = false;
    await prefs.setBool(_kLoggedIn, false);
  }
}