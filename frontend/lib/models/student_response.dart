// To parse this JSON data, do
//
//     final studentResponse = studentResponseFromJson(jsonString);

import 'dart:convert';

// List<StudentResponse> studentResponseFromJson(String str) => List<StudentResponse>.from(json.decode(str).map((x) => StudentResponse.fromJson(x)));

StudentResponse studentResponseFromJson(String str) => StudentResponse.fromJson(json.decode(str));

String studentResponseToJson(StudentResponse data) => json.encode(data.toJson());

class StudentResponse {
    String? studentId;
    User? user;
    String? department;
    String? level;

    StudentResponse({
        this.studentId,
        this.user,
        this.department,
        this.level,
    });

    factory StudentResponse.fromJson(Map<String, dynamic> json) => StudentResponse(
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
