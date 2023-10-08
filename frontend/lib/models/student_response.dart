// To parse this JSON data, do
//
//     final studentResponse = studentResponseFromJson(jsonString);

import 'dart:convert';

List<StudentResponse> studentResponseFromJson(String str) => List<StudentResponse>.from(json.decode(str).map((x) => StudentResponse.fromJson(x)));

String studentResponseToJson(List<StudentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentResponse {
    User? user;
    String? department;
    String? level;

    StudentResponse({
        this.user,
        this.department,
        this.level,
    });

    factory StudentResponse.fromJson(Map<String, dynamic> json) => StudentResponse(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        department: json["department"],
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "department": department,
        "level": level,
    };
}

class User {
    String? name;
    String? username;
    dynamic email;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    User({
        this.name,
        this.username,
        this.email,
        this.isStaff,
        this.isStudent,
        this.isLecturer,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        isStaff: json["is_staff"],
        isStudent: json["is_student"],
        isLecturer: json["is_lecturer"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "email": email,
        "is_staff": isStaff,
        "is_student": isStudent,
        "is_lecturer": isLecturer,
    };
}
