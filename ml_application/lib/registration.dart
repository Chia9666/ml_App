// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ml_application/api_connection/api_connection.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
    // get data from textfields
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    // email validation
    final emailValidationResult = await http.post(
      Uri.parse(API.validateEmail),
      body: {
        "email": email,
      },
    );

    // check what is returned by post request above
    final resultBody = jsonDecode(emailValidationResult.body);
    print('Response body: ${resultBody}');

    if (resultBody['emailFound'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email has already been used!'),
        ),
      );
    } else {
      //resultBody['emailFound'] == false
      // signUp process or register user to our user table
      final signUpResult = await http.post(
        Uri.parse(API.signUp),
        body: {
          "username": username,
          "email": email,
          "password": password,
        },
      );
      final res = jsonDecode(signUpResult.body);
      print('registration message: ${res['message']}');

      if (res['success'] == true) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Failed!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Please enter username'),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Please enter email'),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Please enter password'),
              obscureText: true,
            ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}
