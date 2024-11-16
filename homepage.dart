// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unused_local_variable, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grasg/api_connection/api_connection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:developer' as devtools;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String label = '';
  double confidence = 0.0;
  int? currentUserId;

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); //remove token to end session

    // navigate user back to login page
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _tfLteInit() async {
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  Future<void> _saveClassification(
      String image_name, String prediction_label, double confidence) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      print("User is not logged in.");
      return;
    }

    final response = await http.post(
      Uri.parse(API.savePrediction),
      body: {
        'user_id': currentUserId.toString(),
        'image_name': image_name,
        'prediction_label': prediction_label,
        'confidence': confidence.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Prediction saved: ${response.body}");
    } else {
      print("Error saving prediction: ${response.statusCode}");
    }
  }

  Future<void> _loadCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt("user_id");
    });
  }

  imgFromGallery() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);
    String imageName = path.basename(image.path); // to extract file name

    setState(() {
      _image = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.5, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });

    await _saveClassification(
        imageName, label, confidence); // use the extracted name
  }

  imgFromCamera() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);
    String imageName = path.basename(image.path);

    setState(() {
      _image = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });

    await _saveClassification(imageName, label, confidence);
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
    _loadCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 187, 1),
            foregroundColor: Colors.white,
            title: Text('Image Classification'),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _logout,
                icon: Icon(Icons.logout),
              ),
            ]),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Card(
                color: Colors.white,
                //color: const Color.fromARGB(255, 241, 203, 64),
                elevation: 30,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 425,
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        height: 375,
                        width: 375,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                              image: AssetImage('assets/upload.png')),
                        ),
                        child: _image == null
                            ? Text('')
                            : Image.file(_image!, fit: BoxFit.fill),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '$label: The Accuracy is ${confidence.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                  onPressed: () {
                    imgFromCamera();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white),
                  child: Text('Take a Photo')),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    imgFromGallery();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white),
                  child: Text('Upload photo from Gallery')),
            ],
          )),
        ));
  }
}
