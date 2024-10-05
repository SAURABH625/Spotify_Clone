class CurrentUserModel {
  final String userName;
  final String email;

  CurrentUserModel({
    required this.userName,
    required this.email,
  });

  CurrentUserModel copyWith({
    String? userName,
    String? userEmail,
  }) {
    return CurrentUserModel(
      userName: userName ?? this.userName,
      email: email ?? email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
    };
  }

  factory CurrentUserModel.fromMap(Map<String, dynamic> map) {
    return CurrentUserModel(
      userName: map['userName'] as String,
      email: map['email'] as String,
    );
  }
}
