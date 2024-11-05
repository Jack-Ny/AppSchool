import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../models/quiz.dart';
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
  late Quiz quiz;
  int _currentQuestionIndex = 0;
  final List<String?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  void _initQuiz() {
    quiz = Quiz(
      title: widget.moduleTitle,
      questions: [
        Question(
          questionText: "Qu'est ce qu'une fonction récursive ?",
          type: QuestionType.selection,
          answer: "Une fonction qui s'appelle elle meme",
          points: 1,
          choices: [
            "Une fonction qui s'appelle elle meme",
            "Une fonction qui s'auto-incrémente",
            "Une fonction qui retourne une valeur nulle",
            "Une fonction qui retourne NaN"
          ],
        ),
        Question(
          questionText: "Qu'est ce qu'une fonction récursive ?",
          type: QuestionType.selection,
          answer: "Une fonction qui s'appelle elle meme",
          points: 1,
          choices: [
            "Une fonction qui s'appelle elle meme",
            "Une fonction qui s'auto-incrémente",
            "Une fonction qui retourne une valeur nulle",
            "Une fonction qui retourne NaN"
          ],
        ),
        Question(
          questionText: "Qu'est ce qu'une fonction récursive ?",
          type: QuestionType.selection,
          answer: "Une fonction qui s'appelle elle meme",
          points: 1,
          choices: [
            "Une fonction qui s'appelle elle meme",
            "Une fonction qui s'auto-incrémente",
            "Une fonction qui retourne une valeur nulle",
            "Une fonction qui retourne NaN"
          ],
        ),
      ],
      timeLimit: 30,
      timeUnit: 'minutes',
    );
    _userAnswers.addAll(List.filled(quiz.questions.length, null));
  }

  void _handleSelection(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _handleNext() {
    if (_userAnswers[_currentQuestionIndex] != null) {
      setState(() {
        if (_currentQuestionIndex == quiz.questions.length - 1) {
          _showResults();
        } else {
          _currentQuestionIndex++;
        }
      });
    }
  }

  void _handlePrevious() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
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
                onPressed: () => Navigator.of(context).pop(true),
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
    for (var i = 0; i < quiz.questions.length; i++) {
      if (_userAnswers[i] == quiz.questions[i].answer) {
        score += quiz.questions[i].points;
      }
    }

    quiz.isCompleted = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: score,
          totalQuestions: quiz.questions.length,
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
    final currentQuestion = quiz.questions[_currentQuestionIndex];

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
            quiz.title,
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
              value: (_currentQuestionIndex + 1) / quiz.questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _buildQuestionCard(currentQuestion),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
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
              'Question : ${_currentQuestionIndex + 1}/${quiz.questions.length}',
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
            if (question.choices != null) _buildAnswerOptions(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question question) {
    return Column(
      children: question.choices!.map((option) {
        final isSelected = _userAnswers[_currentQuestionIndex] == option;
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
            onPressed: _userAnswers[_currentQuestionIndex] != null
                ? _handleNext
                : null,
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
              _currentQuestionIndex == quiz.questions.length - 1
                  ? 'Terminer'
                  : 'Suivant',
            ),
          ),
        ],
      ),
    );
  }
}
