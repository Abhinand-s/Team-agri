import 'package:agri/pages/selection.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri App',
     
        
      home: SelectionPage(),
    );
  }
}
