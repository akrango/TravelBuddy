class UserModel {
  final String uid;
  final String email;
  final String role;
  final String displayName;
  final String photoURL;

  UserModel(
      {required this.uid,
      required this.email,
      required this.role,
      required this.displayName,
      required this.photoURL});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
