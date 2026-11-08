import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  bool _isDarkMode = false;
  int _visitCount = 0;

  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    final favorites = prefs.getStringList('favorites') ?? [];

    int currentVisits = prefs.getInt('visit_count') ?? 0;
    int updatedVisits = currentVisits + 1;
    await prefs.setInt('visit_count', updatedVisits);

    _user = User(
      name: name,
      email: email,
      isLoggedIn: isLoggedIn,
      favorites: favorites,
    );
    _isDarkMode = isDarkMode;
    _visitCount = updatedVisits;
    _isLoading = false;

    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
  }

  // [Latihan 5] Simpan Profil dengan Simulasi Cek Email Terdaftar
  Future<bool> updateUser(User newUser) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // [Latihan 5] Simulasi Cek ketersediaan email di SharedPreferences
    String? existingEmail = prefs.getString('registered_email');
    if (existingEmail != null &&
        existingEmail == newUser.email &&
        _user.email != newUser.email) {
      _isLoading = false;
      notifyListeners();
      return false; // Validasi Gagal: Email sudah dipakai oleh akun lain
    }

    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setString(
      'registered_email',
      newUser.email,
    ); // Simpan email terdaftar
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);
    await prefs.setStringList('favorites', newUser.favorites);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
    return true; // Validasi Sukses
  }

  Future<void> addFavorite(String item) async {
    if (item.trim().isEmpty) return;
    List<String> updatedList = List.from(_user.favorites)..add(item.trim());
    User updatedUser = _user.copyWith(favorites: updatedList);
    await updateUser(updatedUser);
  }

  Future<void> removeFavorite(String item) async {
    List<String> updatedList = List.from(_user.favorites)..remove(item);
    User updatedUser = _user.copyWith(favorites: updatedList);
    await updateUser(updatedUser);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);

    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }
}
