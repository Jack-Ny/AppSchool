import 'package:app_school/config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/module.dart';
import '../../models/quiz.dart';
import '../../models/tp.dart';
import '../../models/question.dart';
import '../../services/course_service.dart';

class ModuleFormData {
  final TextEditingController nameController;
  final TextEditingController? descriptionController;
  final List<Quiz> quizzes;
  final List<TP> tps;

  ModuleFormData({
    required this.nameController,
    this.descriptionController,
    this.quizzes = const [],
    this.tps = const [],
  });
}

class QuestionFormData {
  final TextEditingController questionController;
  final List<Answer> answers;

  QuestionFormData({
    required this.questionController,
    this.answers = const [],
  });
}

class Answer {
  final String text;
  bool isCorrect;

  Answer({
    required this.text,
    this.isCorrect = false,
  });
}

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _courseNameController = TextEditingController();
  final _courseDescriptionController = TextEditingController();
  final _courseService = CourseService();
  final List<ModuleFormData> _modules = [];
  bool _isLoading = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Validation des champs avant l'ajout du cours
  bool get _isFormValid {
    return _courseNameController.text.isNotEmpty &&
        _courseDescriptionController.text.isNotEmpty;
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

  // Sauvegarde du cours avec validation
  Future<void> _saveCourse() async {
    // if (!_isFormValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Veuillez remplir tous les champs')),
    //   );
    //   return;
    // }
    if(!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      final userId = SupabaseConfig.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      final modulesJson = _modules.map((moduleData) {
        return Module(
          name: moduleData.nameController.text,
          description: moduleData.descriptionController?.text,
          courseId: '', // CourseId à renseigner lors de la création finale
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          quizzes: moduleData.quizzes,
          tps: moduleData.tps,
        ).toJson(); // Sérialisation ici
      }).toList();

      await _courseService.createCourseWithModules(
        name: _courseNameController.text,
        description: _courseDescriptionController.text,
        modules: modulesJson, // On envoie maintenant des Map<String, dynamic>
        createdBy: '', // Cette partie à remplir si nécessaire
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cours créé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
        title: const Text('Créer un nouveau cours'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _saveCourse();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Créer le cours' : 'Continuer',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Informations générales'),
              content: _buildCourseInfoStep(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Modules'),
              content: _buildModulesStep(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Contenu des modules'),
              content: _buildModuleContentStep(),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }

  // widget creation de cours
  Widget _buildCourseInfoStep() {
    return Column(
      children: [
        TextFormField(
          controller: _courseNameController,
          decoration: InputDecoration(
            labelText: 'Nom du cours',
            hintText: 'Ex: Introduction à Flutter',
            prefixIcon: const Icon(Icons.school),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Le nom du cours est requis';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _courseDescriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Description du cours',
            hintText: 'Décrivez le contenu et les objectifs du cours...',
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // validator: (value) {
          //   if (value?.isEmpty ?? true) {
          //     return 'La description est requise';
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }

  // widget creation de module
  Widget _buildModulesStep() {
    return Column(
      children: [
        ..._modules.asMap().entries.map((entry) => _buildModuleCard(entry.key)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addModule,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un module'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // widget carte creation de module
  Widget _buildModuleCard(int index) {
    final module = _modules[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text('Module ${index + 1}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: module.nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du module',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (module.descriptionController != null) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: module.descriptionController!,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description du module',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => _removeModule(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Supprimer',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // widget creation de module contenu
  Widget _buildModuleContentStep() {
    return Column(
      children: _modules.asMap().entries.map((entry) {
        final moduleIndex = entry.key;
        final module = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(module.nameController.text.isEmpty
                ? 'Module ${moduleIndex + 1}'
                : module.nameController.text),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQuizSection(module),
                    const SizedBox(height: 16),
                    _buildTPSection(module),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Section des quizzes
  Widget _buildQuizSection(ModuleFormData module) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () => _showQuizDialog(module),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: module.quizzes.map((quiz) {
              return Chip(
                label: Text(quiz.title),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeQuiz(module, quiz),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Section des TPs
  Widget _buildTPSection(ModuleFormData module) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Travaux Pratiques',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () => _showTPDialog(module),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: module.tps.map((tp) {
              return Chip(
                label: Text(tp.title),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeTP(module, tp),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Ajout d'un module

  // Bouton d'enregistrement

  // Ajouter un module
  void _addModule() {
    setState(() {
      _modules.add(ModuleFormData(
        nameController: TextEditingController(),
        descriptionController: TextEditingController(),
        quizzes: [],
        tps: [],
      ));
    });
  }

  // suppresion module
  void _removeModule(int index) {
    setState(() {
      _modules.removeAt(index);
    });
  }

  // Dialogue pour ajouter un quiz
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
                          content: Text('Veuillez remplir tous les champs'),
                        ),
                      );
                      return;
                    }

                    final quiz = Quiz(
                      title: titleController.text,
                      description: [_courseDescriptionController.text],
                      questions: questions
                          .map((q) => Question(
                                quizId: '',
                                questionText: q.questionController.text,
                                questionType:
                                    'text', // Exemple de type de question
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

  // Dialogue pour ajouter un TP
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
                    deadlineController.text =
                        DateFormat('yyyy-MM-dd').format(date);
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

  // Carte de question dans un quiz
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
