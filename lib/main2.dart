import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[500],
        title: const Center(
          child: Text("Cennet"),
        ),
      ),
      body: Center(
        child: Image.network(
            "./atesiask/bahar11.jpeg"),
      ),
    ),
  ));
}
