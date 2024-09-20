import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart'; // For testing with images

class QualityDetectionPage extends StatefulWidget {
  @override
  _QualityDetectionPageState createState() => _QualityDetectionPageState();
}

class _QualityDetectionPageState extends State<QualityDetectionPage> {
  String _output = 'No result yet'; // Initial output text
  XFile? _image; // Updated type
  bool _busy = false; // To handle loading state

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    setState(() {
      _busy = true;
    });
    try {
      String? res = await Tflite.loadModel(
        model: "assets/fruit_vegetable_quality_detector.tflite",
      );
      print('Model loaded: $res');
    } catch (e) {
      print('Error loading model: $e');
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  // Run inference on the image
  Future<void> runModelOnImage(XFile image) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: image.path, // path to the image file
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 1, // Top prediction result
        threshold: 0.5, // Confidence threshold
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _output = 'Quality: ${recognitions[0]['label']}'; // Display label
        });
      } else {
        setState(() {
          _output = 'Could not detect quality';
        });
      }
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
    Tflite.close(); // Dispose of the model when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Quality Detection'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            if (_image != null) 
              Positioned.fill(
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.cover,
                ),
              ),
            if (_busy)
              Center(
                child: CircularProgressIndicator(),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    _output,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text('Pick an Image'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
