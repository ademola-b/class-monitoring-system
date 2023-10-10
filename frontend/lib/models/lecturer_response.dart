// To parse this JSON data, do
//
//     final lecturerResponse = lecturerResponseFromJson(jsonString);

import 'dart:convert';

List<LecturerResponse> lecturerResponseFromJson(String str) => List<LecturerResponse>.from(json.decode(str).map((x) => LecturerResponse.fromJson(x)));

String lecturerResponseToJson(List<LecturerResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LecturerResponse {
    String? lectId;
    User? user;
    String? course;

    LecturerResponse({
        this.lectId,
        this.user,
        this.course,
    });

    factory LecturerResponse.fromJson(Map<String, dynamic> json) => LecturerResponse(
        lectId: json["lect_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        course: json["course"],
    );

    Map<String, dynamic> toJson() => {
        "lect_id": lectId,
        "user": user?.toJson(),
        "course": course,
    };
}

class User {
    String? pk;
    String? name;
    String? username;
    dynamic email;
    String? profilePic;
    String? picMem;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    User({
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

    factory User.fromJson(Map<String, dynamic> json) => User(
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
