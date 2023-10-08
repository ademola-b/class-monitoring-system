// To parse this JSON data, do
//
//     final departmentResponse = departmentResponseFromJson(jsonString);

import 'dart:convert';

List<DepartmentResponse> departmentResponseFromJson(String str) => List<DepartmentResponse>.from(json.decode(str).map((x) => DepartmentResponse.fromJson(x)));

String departmentResponseToJson(List<DepartmentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepartmentResponse {
    String? deptId;
    String? deptName;

    DepartmentResponse({
        this.deptId,
        this.deptName,
    });

    factory DepartmentResponse.fromJson(Map<String, dynamic> json) => DepartmentResponse(
        deptId: json["dept_id"],
        deptName: json["deptName"],
    );

    Map<String, dynamic> toJson() => {
        "dept_id": deptId,
        "deptName": deptName,
    };
}
