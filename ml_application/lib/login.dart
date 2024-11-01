// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ml_application/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final usernameEmail = _usernameEmailController.text;
    final password = _passwordController.text;

    final loginResult = await http.post(
      Uri.parse(API.login),
      body: {
        "usernameEmail": usernameEmail,
        "password": password,
      },
    );

    final resultBody = jsonDecode(loginResult.body);

    if (resultBody['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", resultBody["token"]);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful!'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
      // redirect user to home page after successfully logging in
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('login failed'),
        ),
      );
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
              controller: _usernameEmailController,
              decoration:
                  InputDecoration(labelText: 'Please enter username or email'),
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
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
