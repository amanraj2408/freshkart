import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/mock_data_service.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  guest,
}

/// Manages user authentication state, profiles, and delivery addresses.
class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.authenticated; // Default authenticated for frictionless demo
  UserProfile? _user = MockDataService.getDefaultProfile();

  AuthStatus get status => _status;
  UserProfile? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _status == AuthStatus.guest;

  String get activeDeliveryAddress =>
      _user?.defaultAddress ?? 'Select or add delivery address';

  bool loginWithPhone({required String phone, required String password}) {
    if (phone.trim().length >= 10 && password.isNotEmpty) {
      _user = UserProfile(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Varsha Sharma',
        phone: phone.trim(),
        email: 'customer@freshkart.in',
        defaultAddress: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru - 560103',
        savedAddresses: const [
          'Flat 402, Green Glen Layout, Bellandur, Bengaluru - 560103',
          'Tower B, Sector 62, Electronic City Phase 1, Bengaluru - 560100',
        ],
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    if (name.trim().isNotEmpty && phone.trim().length >= 10 && email.contains('@')) {
      _user = UserProfile(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim(),
        defaultAddress: 'Default Address, Bengaluru',
        savedAddresses: const [
          'Default Address, Bengaluru',
        ],
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    return false;
  }

  void continueAsGuest() {
    _status = AuthStatus.guest;
    _user = const UserProfile(
      id: 'guest',
      name: 'Guest Shopper',
      phone: '+91 90000 00000',
      email: 'guest@freshkart.in',
      defaultAddress: 'HSR Layout, Sector 2, Bengaluru - 560102',
      savedAddresses: [
        'HSR Layout, Sector 2, Bengaluru - 560102',
      ],
    );
    notifyListeners();
  }

  void setDefaultAddress(String address) {
    if (_user != null) {
      _user = _user!.copyWith(defaultAddress: address);
      notifyListeners();
    }
  }

  void addAddress(String newAddress) {
    if (_user != null) {
      final updatedList = List<String>.from(_user!.savedAddresses)..add(newAddress);
      _user = _user!.copyWith(
        savedAddresses: updatedList,
        defaultAddress: newAddress,
      );
      notifyListeners();
    }
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }
}
