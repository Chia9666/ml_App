// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = 'result here';

  File? _image;
  late ImagePicker imagePicker;

  imgFromGallery() async {
    // pick an image
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); //remove token to end session

    // navigate user back to login page
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            _image == null
                ? Icon(
                    Icons.image,
                    size: 200.00,
                  )
                : Image.file(
                    _image!,
                    width: 600,
                    height: 600,
                  ), // condition is _image == null, then is ?, else is :
            ElevatedButton(
              onPressed: () {
                imgFromGallery();
              },
              child: Text('Capture or Open Gallery'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              result,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
