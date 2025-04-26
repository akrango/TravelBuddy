class UserModel {
  final String uid;
  final String email;
  final String role;
  final String displayName;
  final String photoURL;
  final String? profession;
  final int? yearsOfHosting;

  UserModel(
      {required this.uid,
      required this.email,
      required this.role,
      required this.displayName,
      required this.photoURL,
      this.profession,
      this.yearsOfHosting});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName,
      'photoURL': photoURL,
      'profession': profession,
      'yearsOfHosting': yearsOfHosting,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      profession: map['profession'],
      yearsOfHosting: map['yearsOfHosting'],
    );
  }
}
