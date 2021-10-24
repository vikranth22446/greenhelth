// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_helth/Services/Auth.dart';
import 'package:green_helth/Services/HttpException.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode authMode = AuthMode.Login;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(emailController.text, passwordController.text);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            emailController.text,
            passwordController.text,
            emailController.text);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
      setState(() {
        isLoading = false;
      });
      return;
    } catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      setState(() {
        isLoading = false;
      });
      return;
    }
    Navigator.of(context).pushReplacementNamed("home");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(255, 255, 250, 1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Logo"),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.asset(
                          'assets/Textures/green_logo_mesh_texture.png',
                          fit: BoxFit.fitWidth),
                    ),
                    Text(
                      "GRENHLTH",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Text(
                      authMode == AuthMode.Login ? "Log In" : "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primaryVariant,
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(196, 196, 196, 1),
                              width: 2.0),
                        ),
                        filled: true,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        hintText: "Email",
                        fillColor: Color.fromRGBO(255, 255, 250, 1),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primaryVariant,
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(196, 196, 196, 1),
                              width: 2.0),
                        ),
                        filled: true,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        hintText: "Password",
                        fillColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white
                                    )
                                  : Text(
                                      authMode == AuthMode.Login
                                          ? "LOG IN"
                                          : "SIGN UP",
                                      style: TextStyle(fontSize: 17),
                                    ),
                            ),
                            onPressed: () {
                              submit();
                            },
                            style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.primaryVariant,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                elevation: 0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (authMode == AuthMode.Signup) {
                          setState(() {
                            authMode = AuthMode.Login;
                          });
                        } else {
                          setState(() {
                            authMode = AuthMode.Signup;
                          });
                        }
                      },
                      child: Text(
                        authMode == AuthMode.Signup ? "Log In" : "Sign Up",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primaryVariant),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
