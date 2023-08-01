import 'package:flutter/material.dart';

class MyDetection extends StatefulWidget {
  const MyDetection({super.key});

  @override
  State<MyDetection> createState() => _MyDetectionState();
}

class _MyDetectionState extends State<MyDetection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(159, 203, 114, 1),
        title: const Center(child: Text('ค้นหาสุนัข')),
      ),
      body: Center(
        child: Text('My Detection'),
      ),
    );
  }
}
