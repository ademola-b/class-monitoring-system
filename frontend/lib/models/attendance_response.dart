// To parse this JSON data, do
//
//     final attendanceResponse = attendanceResponseFromJson(jsonString);

import 'dart:convert';

AttendanceResponse attendanceResponseFromJson(String str) => AttendanceResponse.fromJson(json.decode(str));

String attendanceResponseToJson(AttendanceResponse data) => json.encode(data.toJson());

class AttendanceResponse {
    String? attId;
    DateTime? date;
    String? student;
    String? course;

    AttendanceResponse({
        this.attId,
        this.date,
        this.student,
        this.course,
    });

    factory AttendanceResponse.fromJson(Map<String, dynamic> json) => AttendanceResponse(
        attId: json["att_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        student: json["student"],
        course: json["course"],
    );

    Map<String, dynamic> toJson() => {
        "att_id": attId,
        "date": date?.toIso8601String(),
        "student": student,
        "course": course,
    };
}
