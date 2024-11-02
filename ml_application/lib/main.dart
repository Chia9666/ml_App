// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ml_application/homepage.dart';
import 'package:ml_application/login.dart';
import 'package:ml_application/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _isLoggedIn(),
        builder: (context, snapshot) 
          // display a loading screen with a scaffold
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } // show homepage if logged in, else login page else if (snapshot.hasData && snapshot.data == true) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}
