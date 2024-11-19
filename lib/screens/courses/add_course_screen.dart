import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../models/quiz.dart';
import '../../models/tp.dart';
import '../../models/answer.dart';
import '../../models/question.dart';
import '../../services/course_service.dart';

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

class QuestionFormData {
  final TextEditingController questionController;
  final List<Answer> answers;

  QuestionFormData({
    required this.questionController,
    required this.answers,
  });
}

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _courseNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _courseService = CourseService();
  final List<ModuleFormData> _modules = [];
  bool _isLoading = false;

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

  Future<void> _saveCourse() async {
    if (_courseNameController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      final modules = _modules
          .map((moduleData) => Module(
                name: moduleData.nameController.text,
                quizzes: moduleData.quizzes,
                tps: moduleData.tps,
                courseId: '',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ))
          .toList();

      await _courseService.createCourseWithModules(
        name: _courseNameController.text,
        category: _categoryController.text,
        modules: modules,
        userId: userId,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cours créé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCourseInfo(),
                const SizedBox(height: 20),
                ..._modules.map((module) => _buildModuleCard(module)),
                _buildAddModuleButton(),
                const SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          TextField(
            controller: _courseNameController,
            decoration: const InputDecoration(
              hintText: 'Nom du cours',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              hintText: 'Catégorie',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
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
      onPressed: _isLoading ? null : _saveCourse,
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
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final List<QuestionFormData> questions = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre du quiz',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ...questions
                    .map((question) => _buildQuestionCard(question, setState)),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      questions.add(QuestionFormData(
                        questionController: TextEditingController(),
                        answers: [],
                      ));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une question'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty || questions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Veuillez remplir tous les champs')),
                      );
                      return;
                    }

                    final quiz = Quiz(
                      title: titleController.text,
                      description: descriptionController.text,
                      questions: questions
                          .map((q) => Question(
                                quizId: '',
                                questionText: '',
                                questionType: '',
                                answer: '',
                                createdAt: DateTime.now(),
                                text: '',
                              ))
                          .toList(),
                      moduleId: '',
                      timeLimit: 0,
                      timeUnit: '',
                      createdAt: DateTime.now(),
                    );

                    moduleData.quizzes.add(quiz);
                    Navigator.pop(context);
                  },
                  child: const Text('Enregistrer le quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTPDialog(ModuleFormData moduleData) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final deadlineController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre du TP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: deadlineController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date limite',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    deadlineController.text = date.toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      deadlineController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                    return;
                  }

                  final tp = TP(
                    title: titleController.text,
                    description: descriptionController.text,
                    deadline: DateTime.parse(deadlineController.text),
                    moduleId: '',
                    createdAt: DateTime.now(),
                  );
                  moduleData.tps.add(tp);
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer le TP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionFormData question, StateSetter setState) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: question.questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ...question.answers.asMap().entries.map((entry) => Row(
                  children: [
                    Checkbox(
                      value: entry.value.isCorrect,
                      onChanged: (value) {
                        setState(() {
                          question.answers[entry.key] = Answer(
                            text: entry.value.text,
                            isCorrect: value ?? false,
                          );
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: entry.value.text),
                        onChanged: (value) {
                          setState(() {
                            question.answers[entry.key] = Answer(
                              text: value,
                              isCorrect: entry.value.isCorrect,
                            );
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Réponse ${entry.key + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          question.answers.removeAt(entry.key);
                        });
                      },
                    ),
                  ],
                )),
            TextButton(
              onPressed: () {
                setState(() {
                  question.answers.add(Answer(text: '', isCorrect: false));
                });
              },
              child: const Text('Ajouter une réponse'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  question.answers.clear();
                });
              },
              child: const Text('Supprimer toutes les réponses'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
