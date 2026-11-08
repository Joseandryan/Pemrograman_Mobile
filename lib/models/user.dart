class User {
  final String name;
  final String email;
  final bool isLoggedIn;
  final List<String> favorites; // [Latihan 3]

  User({
    required this.name,
    required this.email,
    this.isLoggedIn = false,
    this.favorites = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isLoggedIn': isLoggedIn,
      'favorites': favorites,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
      favorites: List<String>.from(map['favorites'] ?? []),
    );
  }

  User copyWith({
    String? name,
    String? email,
    bool? isLoggedIn,
    List<String>? favorites,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      favorites: favorites ?? this.favorites,
    );
  }
}
