import 'package:app_school/screens/courses/add_quiz_screen.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../models/quiz.dart';
import '../../models/tp.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _courseNameController = TextEditingController();
  final List<ModuleFormData> _modules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ajoutez cours'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCourseNameField(),
            const SizedBox(height: 20),
            ..._modules.map((module) => _buildModuleCard(module)),
            _buildAddModuleButton(),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseNameField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _courseNameController,
        decoration: const InputDecoration(
          hintText: 'Nom du cours',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildModuleCard(ModuleFormData moduleData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: moduleData.nameController,
              decoration: const InputDecoration(
                hintText: 'Nom du module',
                suffixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            _buildQuizzesSection(moduleData),
            const SizedBox(height: 15),
            _buildTPsSection(moduleData),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizzesSection(ModuleFormData moduleData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('QUIZZ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ...moduleData.quizzes.map((quiz) => Chip(
                    label: Text(quiz.title),
                    onDeleted: () => _removeQuiz(moduleData, quiz),
                  )),
              ActionChip(
                label: const Text('+ QUIZZ'),
                onPressed: () => _showQuizDialog(moduleData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTPsSection(ModuleFormData moduleData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TPs', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ...moduleData.tps.map((tp) => Chip(
                    label: Text(tp.title),
                    onDeleted: () => _removeTP(moduleData, tp),
                  )),
              ActionChip(
                label: const Text('+ TPs'),
                onPressed: () => _showTPDialog(moduleData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddModuleButton() {
    return ElevatedButton.icon(
      onPressed: _addModule,
      icon: const Icon(Icons.add),
      label: const Text('Ajouter un module'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0E6952),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveCourse,
      child: const Text('Enregistrez'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  void _addModule() {
    setState(() {
      _modules.add(ModuleFormData(
        nameController: TextEditingController(),
        quizzes: [],
        tps: [],
      ));
    });
  }

  void _showQuizDialog(ModuleFormData moduleData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => QuizCreationDialog(
        onQuizCreated: (quiz) {
          setState(() {
            moduleData.quizzes.add(quiz);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTPDialog(ModuleFormData moduleData) {
    // Implement TP creation dialog
  }

  void _removeQuiz(ModuleFormData moduleData, Quiz quiz) {
    setState(() {
      moduleData.quizzes.remove(quiz);
    });
  }

  void _removeTP(ModuleFormData moduleData, TP tp) {
    setState(() {
      moduleData.tps.remove(tp);
    });
  }

  void _saveCourse() {
    if (_courseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir le nom du cours')),
      );
      return;
    }

    final course = Course(
      name: _courseNameController.text,
      modules: _modules
          .map((moduleData) => Module(
                name: moduleData.nameController.text,
                quizzes: moduleData.quizzes,
                tps: moduleData.tps,
              ))
          .toList(),
    );

    // TODO: Save course to database or state management
    Navigator.pop(context);
  }
}

// Helper class for form data
class ModuleFormData {
  final TextEditingController nameController;
  final List<Quiz> quizzes;
  final List<TP> tps;

  ModuleFormData({
    required this.nameController,
    required this.quizzes,
    required this.tps,
  });
}
