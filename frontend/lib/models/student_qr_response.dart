// To parse this JSON data, do
//
//     final studentQrResponse = studentQrResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

List<StudentQrResponse> studentQrResponseFromJson(String str) => List<StudentQrResponse>.from(json.decode(str).map((x) => StudentQrResponse.fromJson(x)));

String studentQrResponseToJson(List<StudentQrResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentQrResponse {
    String? qrId;
    String? registrationNo;
    Uint8List? qrMem;
    String? qrImage;

    StudentQrResponse({
        this.qrId,
        this.registrationNo,
        this.qrMem,
        this.qrImage,
    });

    factory StudentQrResponse.fromJson(Map<String, dynamic> json) => StudentQrResponse(
        qrId: json["qr_id"],
        registrationNo: json["registration_no"],
        qrMem: base64Decode(json["qr_mem"]) ,
        qrImage: json["qr_image"],
    );

    Map<String, dynamic> toJson() => {
        "qr_id": qrId,
        "registration_no": registrationNo,
        "qr_mem": qrMem,
        "qr_image": qrImage,
    };
}
