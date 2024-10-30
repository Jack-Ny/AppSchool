// lib/screens/student/quiz/student_quiz_screen.dart
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../models/quiz_models.dart';
import 'quiz_result_screen.dart';

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
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  final List<String?> _userAnswers = [];
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _initQuestions();
    // Initialiser le tableau des réponses avec null
    _userAnswers.addAll(List.filled(_questions.length, null));
  }

  void _initQuestions() {
    _questions = [
      QuizQuestion(
        questionText: "Qu'est ce qu'une fonction récursive ?",
        type: QuestionType.multipleChoice,
        options: [
          "Une fonction qui s'appelle elle meme",
          "Une fonction qui s'auto-incrémente",
          "Une fonction qui retourne une valeur nulle",
          "Une fonction qui retourne NaN"
        ],
        correctAnswer: "Une fonction qui s'appelle elle meme",
        questionNumber: 1,
        totalQuestions: 10,
      ),
      QuizQuestion(
        questionText: "Qu'est ce qu'une fonction récursive ?",
        type: QuestionType.multipleChoice,
        options: [
          "Une fonction qui s'appelle elle meme",
          "Une fonction qui s'auto-incrémente",
          "Une fonction qui retourne une valeur nulle",
          "Une fonction qui retourne NaN"
        ],
        correctAnswer: "Une fonction qui s'appelle elle meme",
        questionNumber: 2,
        totalQuestions: 10,
      ),
      QuizQuestion(
        questionText: "Qu'est ce qu'une fonction récursive ?",
        type: QuestionType.multipleChoice,
        options: [
          "Une fonction qui s'appelle elle meme",
          "Une fonction qui s'auto-incrémente",
          "Une fonction qui retourne une valeur nulle",
          "Une fonction qui retourne NaN"
        ],
        correctAnswer: "Une fonction qui s'appelle elle meme",
        questionNumber: 3,
        totalQuestions: 10,
      ),
      // Ajouter d'autres questions ici
    ];
  }

  void _handleSelection(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _handleNext() {
    if (_selectedAnswer != null) {
      setState(() {
        if (_currentQuestionIndex == _questions.length - 1) {
          _showResults();
        } else {
          _currentQuestionIndex++;
          _selectedAnswer = _userAnswers[_currentQuestionIndex];
        }
      });
    }
  }

  void _handlePrevious() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _userAnswers[_currentQuestionIndex];
      });
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quitter le quiz ?'),
            content: const Text(
              'Êtes-vous sûr de vouloir quitter ? Votre progression ne sera pas sauvegardée.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Non'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Oui, quitter'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showResults() {
    int score = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctAnswer) {
        score++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: score,
          totalQuestions: _questions.length,
          userName: "Ouédraogo Zakaria",
          onReturnPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => _onWillPop().then((value) {
              if (value) Navigator.pop(context);
            }),
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
        body: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _buildQuestionCard(_questions[_currentQuestionIndex]),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question : ${question.questionNumber}/${question.totalQuestions}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildAnswerOptions(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(QuizQuestion question) {
    return Column(
      children: question.options.map((option) {
        final isSelected = _selectedAnswer == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () => _handleSelection(option),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? AppColors.primaryBlue : Colors.white,
              foregroundColor: isSelected ? Colors.white : Colors.black87,
              elevation: 0,
              side: BorderSide(
                color:
                    isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentQuestionIndex > 0)
            ElevatedButton(
              onPressed: _handlePrevious,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('Précédent'),
            )
          else
            const SizedBox(width: 100),
          ElevatedButton(
            onPressed: _selectedAnswer != null ? _handleNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: Text(
              _currentQuestionIndex == _questions.length - 1
                  ? 'Terminer'
                  : 'Suivant',
            ),
          ),
        ],
      ),
    );
  }
}
