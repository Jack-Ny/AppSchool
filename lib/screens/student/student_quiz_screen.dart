import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class StudentQuizScreen extends StatefulWidget {
  final String moduleTitle;
  final String courseTitle;

  const StudentQuizScreen({
    Key? key,
    required this.moduleTitle,
    required this.courseTitle,
  }) : super(key: key);

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.moduleTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Quiz pour le cours: ${widget.courseTitle}'),
      ),
    );
  }
}
