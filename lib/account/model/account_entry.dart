import 'dart:convert';


List<UserAccount> userAccountFromJson(String str) =>
    List<UserAccount>.from(
      json.decode(str).map((x) => UserAccount.fromJson(x)),
    );

String userAccountToJson(List<UserAccount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAccount {
  String model;
  int pk;
  Fields fields;

  UserAccount({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  factory UserAccount.fromLoginJson(Map<String, dynamic> json) => UserAccount(
        model: "account.account",
        pk: 0,
        fields: Fields.fromLoginJson(json),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String? nickname;
  int? age;
  String? profilePicture;
  String roles;
  List<int> favorites;

  Fields({
    required this.user,
    required this.nickname,
    required this.age,
    required this.profilePicture,
    required this.roles,
    required this.favorites,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        nickname: json["nickname"],
        age: json["age"],
        profilePicture: json["profile_picture"],
        roles: json["roles"],
        favorites: json["favorites"] == null
            ? []
            : List<int>.from(json["favorites"]),
      );

  factory Fields.fromLoginJson(Map<String, dynamic> json) => Fields(
        user: 0,
        nickname: json["nickname"],
        age: json["age"],
        profilePicture: json["profile_picture"],
        roles: json["role"] ?? "User",
        favorites: json["favorites"] == null
            ? []
            : List<int>.from(json["favorites"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "nickname": nickname,
        "age": age,
        "profile_picture": profilePicture,
        "roles": roles,
        "favorites": List<dynamic>.from(favorites),
      };
}
