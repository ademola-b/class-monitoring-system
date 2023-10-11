// To parse this JSON data, do
//
//     final fullUserDetailResponse = fullUserDetailResponseFromJson(jsonString);

import 'dart:convert';

FullUserDetailResponse fullUserDetailResponseFromJson(String str) => FullUserDetailResponse.fromJson(json.decode(str));

String fullUserDetailResponseToJson(FullUserDetailResponse data) => json.encode(data.toJson());

class FullUserDetailResponse {
    String? pk;
    String? name;
    String? username;
    dynamic email;
    String? picMem;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    FullUserDetailResponse({
        this.pk,
        this.name,
        this.username,
        this.email,
        this.picMem,
        this.isStaff,
        this.isStudent,
        this.isLecturer,
    });

    factory FullUserDetailResponse.fromJson(Map<String, dynamic> json) => FullUserDetailResponse(
        pk: json["pk"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
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
        "pic_mem": picMem,
        "is_staff": isStaff,
        "is_student": isStudent,
        "is_lecturer": isLecturer,
    };
}
