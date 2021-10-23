import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_helth/Widgets/BadgeDetectionAndroid.dart';
import 'package:green_helth/Widgets/BadgeDetectionIOS.dart';

class BadgeDetectionScreen extends StatefulWidget {
  const BadgeDetectionScreen({Key? key}) : super(key: key);

  @override
  _BadgeDetectionScreenState createState() => _BadgeDetectionScreenState();
}

class _BadgeDetectionScreenState extends State<BadgeDetectionScreen> {
  @override
  Widget build(BuildContext context) {
    return  Platform.isAndroid?
              BadgeDetectionAndroid():
              BadgeDetectionIOS();
  }
}
