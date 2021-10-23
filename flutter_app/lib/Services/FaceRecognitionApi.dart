
import 'dart:convert';
import 'dart:html';

import 'package:flutter/painting.dart';
import 'package:green_helth/Models/Student.dart';
import 'package:http/http.dart' as http;


class FaceRecognitionApi {
  static final String API_URL = "";

  Future<Student> recognizeFace(ImageProvider image) async {
    // final response = await http.post(
    //     Uri.parse(API_URL),
    //     body: json.encode({})
    // );
    return Student(studentID: "studentID", name: "name", email: "email", badgeLevel: BadgeLevel.GreenBadge);
  }
}