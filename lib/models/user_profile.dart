/// User account and profile information.
class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String defaultAddress;
  final List<String> savedAddresses;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.defaultAddress,
    required this.savedAddresses,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? defaultAddress,
    List<String>? savedAddresses,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      savedAddresses: savedAddresses ?? this.savedAddresses,
    );
  }
}
