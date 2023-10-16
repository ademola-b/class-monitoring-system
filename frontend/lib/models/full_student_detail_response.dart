// To parse this JSON data, do
//
//     final fullStudentResponse = fullStudentResponseFromJson(jsonString);

import 'dart:convert';

FullStudentResponse fullStudentResponseFromJson(String str) => FullStudentResponse.fromJson(json.decode(str));

String fullStudentResponseToJson(FullStudentResponse data) => json.encode(data.toJson());

class FullStudentResponse {
    String? studentId;
    User? user;
    String? department;
    String? level;

    FullStudentResponse({
        this.studentId,
        this.user,
        this.department,
        this.level,
    });

    factory FullStudentResponse.fromJson(Map<String, dynamic> json) => FullStudentResponse(
        studentId: json["student_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        department: json["department"],
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "user": user?.toJson(),
        "department": department,
        "level": level,
    };
}

class User {
    String? pk;
    String? name;
    String? username;
    dynamic email;
    String? picMem;
    String? profilePic;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    User({
        this.pk,
        this.name,
        this.username,
        this.email,
        this.picMem,
        this.profilePic,
        this.isStaff,
        this.isStudent,
        this.isLecturer,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        pk: json["pk"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        picMem: json["pic_mem"],
        profilePic: json["profile_pic"],
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
        "profile_pic": profilePic,
        "is_staff": isStaff,
        "is_student": isStudent,
        "is_lecturer": isLecturer,
    };
}
