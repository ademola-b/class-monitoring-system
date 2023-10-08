// To parse this JSON data, do
//
//     final userDetailsResponse = userDetailsResponseFromJson(jsonString);

import 'dart:convert';

UserDetailsResponse userDetailsResponseFromJson(String str) => UserDetailsResponse.fromJson(json.decode(str));

String userDetailsResponseToJson(UserDetailsResponse data) => json.encode(data.toJson());

class UserDetailsResponse {
    String? pk;
    String? name;
    String? username;
    dynamic email;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    UserDetailsResponse({
        this.pk,
        this.name,
        this.username,
        this.email,
        this.isStaff,
        this.isStudent,
        this.isLecturer,
    });

    factory UserDetailsResponse.fromJson(Map<String, dynamic> json) => UserDetailsResponse(
        pk: json["pk"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        isStaff: json["is_staff"],
        isStudent: json["is_student"],
        isLecturer: json["is_lecturer"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "name": name,
        "username": username,
        "email": email,
        "is_staff": isStaff,
        "is_student": isStudent,
        "is_lecturer": isLecturer,
    };
}
