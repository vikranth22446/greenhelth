// @dart=2.9
import 'package:flutter/material.dart';
import 'package:green_helth/Screens/auth_screen.dart';
import 'package:green_helth/Screens/badge_detection_screen.dart';
import 'package:green_helth/Screens/home_screen.dart';
import 'package:green_helth/Services/Auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenHelth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primaryColorDark: Color.fromRGBO(167, 223, 76, 1),
            accentColor: Color.fromRGBO(255, 255, 250, 1),
          ),
        ),
        home: AuthScreen(),
        routes: {
          "auth_screen": (ctx) => AuthScreen(),
          "home": (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
