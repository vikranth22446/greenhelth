import 'package:flutter/material.dart';
import 'package:green_helth/Models/Student.dart';

class StudentInfo extends StatefulWidget {
  late final Student student;

  StudentInfo({Key? key, required Student student}): super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState(student: student);
}

class _StudentInfoState extends State<StudentInfo> {
  late final Student student;

  _StudentInfoState({required Student student});

  @override
  Widget build(BuildContext context) {
    return Text("Fe");
  }
}
