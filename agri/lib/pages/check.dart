import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For testing with images
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:tflite_flutter/tflite_flutter.dart'; // TFLite interpreter for Firebase model

class QualityDetectionPage extends StatefulWidget {
  @override
  _QualityDetectionPageState createState() => _QualityDetectionPageState();
}

class _QualityDetectionPageState extends State<QualityDetectionPage> {
  String _output = 'No result yet'; // Initial output text
  XFile? _image; // Updated type
// To handle loading state
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the Firebase custom model
  Future<void> loadModel() async {
    setState(() {
    });
    try {
      // Download the custom model from Firebase
      FirebaseCustomModel model = await FirebaseModelDownloader.instance
          .getModel("veg-detect", FirebaseModelDownloadType.localModelUpdateInBackground);

      // Load the model into the TFLite interpreter
      _interpreter = Interpreter.fromFile(File(model.file.path));
      print('Model loaded from Firebase: ${model.file.path}');
    } catch (e) {
      print('Error loading model: $e');
      setState(() {
        _output = 'Error loading model';
      });
    } finally {
      setState(() {
      });
    }
  }

  // Run inference on the image
  Future<void> runModelOnImage(XFile image) async {
    try {
      if (_interpreter == null) {
        setState(() {
          _output = 'Model not loaded';
        });
        return;
      }

      // Simulate model inference for now
      await Future.delayed(Duration(seconds: 2));

      // Replace with actual inference results
      List<String> categories = [
        'Single Overmature',
        'Single Mature',
        'Multiple Overmature',
        'Multiple Mature',
      ];

      // Simulate random category selection for demonstration purposes
      String simulatedResult = categories[(categories.length * (DateTime.now().millisecondsSinceEpoch % 100) / 100).toInt()];

      setState(() {
        _output = 'Quality: $simulatedResult'; // Update to reflect actual model output
      });
    } catch (e) {
      print('Error during inference: $e');
      setState(() {
        _output = 'Error during processing';
      });
    }
  }

  // Pick an image from the gallery for testing
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Updated method

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _output = 'Processing...'; // Show a temporary message while processing
      });
      await runModelOnImage(pickedFile); // Ensure the model runs after setting the image
    }
  }

  @override
  void dispose() {
    _interpreter?.close(); // Dispose of the interpreter when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Real-Time Quality Detection',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          // Gradient background with agri-themed colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image Display Box
                  if (_image != null)
                    Container(
                      width: 300, // Fixed size for image container
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade800, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green.shade100,
                        border: Border.all(color: Colors.green.shade800, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _output,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.green[800], 
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Pick an Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
