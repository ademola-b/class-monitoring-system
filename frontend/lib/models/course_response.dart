// To parse this JSON data, do
//
//     final coursesResponse = coursesResponseFromJson(jsonString);

import 'dart:convert';

List<CoursesResponse> coursesResponseFromJson(String str) => List<CoursesResponse>.from(json.decode(str).map((x) => CoursesResponse.fromJson(x)));

String coursesResponseToJson(List<CoursesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesResponse {
    String? courseId;
    String? code;
    String? title;

    CoursesResponse({
        this.courseId,
        this.code,
        this.title,
    });

    factory CoursesResponse.fromJson(Map<String, dynamic> json) => CoursesResponse(
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
