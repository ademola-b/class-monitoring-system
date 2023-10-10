// To parse this JSON data, do
//
//     final attendanceReportResponse = attendanceReportResponseFromJson(jsonString);

import 'dart:convert';

List<AttendanceReportResponse> attendanceReportResponseFromJson(String str) => List<AttendanceReportResponse>.from(json.decode(str).map((x) => AttendanceReportResponse.fromJson(x)));

String attendanceReportResponseToJson(List<AttendanceReportResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceReportResponse {
    DateTime? date;
    Student? student;
    Course? course;

    AttendanceReportResponse({
        this.date,
        this.student,
        this.course,
    });

    factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) => AttendanceReportResponse(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        student: json["student"] == null ? null : Student.fromJson(json["student"]),
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
    );

    Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "student": student?.toJson(),
        "course": course?.toJson(),
    };
}

class Course {
    String? courseId;
    String? code;
    String? title;

    Course({
        this.courseId,
        this.code,
        this.title,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseId: json["course_id"],
        code: json["code"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "code": code,
        "title": title,
    };
}

class Student {
    String? pk;
    String? name;
    String? username;
    dynamic email;
    String? profilePic;
    String? picMem;
    bool? isStaff;
    bool? isStudent;
    bool? isLecturer;

    Student({
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

    factory Student.fromJson(Map<String, dynamic> json) => Student(
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
