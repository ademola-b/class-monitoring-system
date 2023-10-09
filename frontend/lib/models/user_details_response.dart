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
    String? profilePic;
    String? picMem;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    UserDetailsResponse({
        this.pk,
        this.name,
        this.username,
        this.email,
        this.profilePic,
        this.picMem,
        this.isStaff,
        this.isStudent,
        this.isLecturer,
    });

    factory UserDetailsResponse.fromJson(Map<String, dynamic> json) => UserDetailsResponse(
        pk: json["pk"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        profilePic: json["profile_pic"],
        picMem: json["pic_mem"],
        isStaff: json["is_staff"],
        isStudent: json["is_student"],
        isLecturer: json["is_lecturer"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "name": name,
        "username": username,
        "email": email,
        "profile_pic": profilePic,
        "pic_mem": picMem,
        "is_staff": isStaff,
        "is_student": isStudent,
        "is_lecturer": isLecturer,
    };
}
