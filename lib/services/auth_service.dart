
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  String? _currentUser;

  String? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> checkLoginStatus() async {
    _currentUser = await _storageService.loadUser();
    notifyListeners();
  }

  Future<void> login(String nickname) async {
    _currentUser = nickname;
    await _storageService.saveUser(nickname);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await _storageService.clearUser();
    notifyListeners();
  }
}
