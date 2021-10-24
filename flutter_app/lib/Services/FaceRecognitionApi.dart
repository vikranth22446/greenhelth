//@dart=2.9

import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:green_helth/Models/Student.dart';
import 'package:http/http.dart' as http;


class FaceRecognitionApi {
  static final String API_URL = "";

  static Future<Student> recognizeFace(ImageProvider image) async {
    // final response = await http.post(
    //     Uri.parse(API_URL),
    //     body: json.encode({})
    // );
    await Future.delayed(const Duration(seconds: 2), (){});
    return Student(studentID: "studentID", name: "name", email: "email", badgeLevel: BadgeLevel.GreenBadge, lastUpdated: DateTime.now());
  }

  static List<Student> getPreviousScans() {
    List<Student> result = List<Student>();

    result.add(Student(studentID: "3035125948", name: "John Doe", email: "johndoe@berkeley.edu", badgeLevel: BadgeLevel.GreenBadge, lastUpdated: DateTime.now()));
    result.add(Student(studentID: "3021185940", name: "Oski Bear", email: "oski@berkeley.edu", badgeLevel: BadgeLevel.YellowBadge, lastUpdated: DateTime.now().subtract(Duration(hours: 1))));
    result.add(Student(studentID: "3034025149", name: "Mary Jane", email: "mjane@berkeley.edu", badgeLevel: BadgeLevel.RedBadge, lastUpdated: DateTime.now().subtract(Duration(minutes: 5, hours: 5))));
    result.add(Student(studentID: "2235125985", name: "Tanner Johnson", email: "tannerj@berkeley.edu", badgeLevel: BadgeLevel.GreenBadge, lastUpdated: DateTime.now().subtract(Duration(minutes: 43, hours: 10))));

    return result;
  }
}