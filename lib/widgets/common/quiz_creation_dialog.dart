import 'package:flutter/material.dart';
import '../../models/quiz.dart';

class QuizCreationDialog extends StatefulWidget {
  final Function(Quiz) onQuizCreated;

  const QuizCreationDialog({
    Key? key,
    required this.onQuizCreated,
  }) : super(key: key);

  @override
  State<QuizCreationDialog> createState() => _QuizCreationDialogState();
}

class _QuizCreationDialogState extends State<QuizCreationDialog> {
  int _currentStep = 0;
  final _quizTitleController = TextEditingController();
  final List<Question> _questions = [];
  int _timeLimit = 0;
  int _passingScore = 75;
  String _selectedTimeUnit = 'Minutes';

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _optionController = TextEditingController();
  final List<String> _options = [];
  bool _trueFalseAnswer = true;
  QuestionType _selectedQuestionType = QuestionType.trueFalse;
  int _questionPoints = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStepperHeader(),
          const SizedBox(height: 30),
          Expanded(child: _buildStepContent()),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Row(
      children: [
        _buildStepIndicator('Infos du quiz', 0),
        _buildStepLine(0),
        _buildStepIndicator('Questions', 1),
        _buildStepLine(1),
        _buildStepIndicator('Réglages', 2),
      ],
    );
  }

  Widget _buildStepIndicator(String label, int step) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.blue : Colors.grey.shade300,
            ),
            child: Icon(
              step < _currentStep ? Icons.check : Icons.circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Container(
      width: 40,
      height: 2,
      color: isActive ? Colors.blue : Colors.grey.shade300,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildQuizInfoStep();
      case 1:
        return _buildQuestionsStep();
      case 2:
        return _buildSettingsStep();
      default:
        return Container();
    }
  }

  Widget _buildQuizInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Titre du quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _quizTitleController,
          decoration: InputDecoration(
            hintText: 'Tapez votre titre de quizz ici',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _questionController,
          decoration: InputDecoration(
            hintText: 'Tapez votre question ici',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sélectionner votre type de question',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildQuestionTypeSelector(),
              const SizedBox(height: 20),
              _buildAnswerSection(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Point pour cette réponse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _questionPoints.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: _questionPoints.toString(),
          onChanged: (value) {
            setState(() {
              _questionPoints = value.toInt();
            });
          },
        ),
        ElevatedButton.icon(
          onPressed: _addQuestion,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter la question'),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) =>
                _buildQuestionItem(_questions[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionTypeSelector() {
    return DropdownButton<QuestionType>(
      value: _selectedQuestionType,
      isExpanded: true,
      items: const [
        DropdownMenuItem(
          value: QuestionType.trueFalse,
          child: Text('Vrai/Faux'),
        ),
        DropdownMenuItem(
          value: QuestionType.singleAnswer,
          child: Text('Réponse unique'),
        ),
        DropdownMenuItem(
          value: QuestionType.selection,
          child: Text('Sélection'),
        ),
      ],
      onChanged: (QuestionType? type) {
        if (type != null) {
          setState(() {
            _selectedQuestionType = type;
            _resetAnswerFields();
          });
        }
      },
    );
  }

  Widget _buildAnswerSection() {
    switch (_selectedQuestionType) {
      case QuestionType.trueFalse:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sélectionnez la bonne réponse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Vrai'),
                    value: true,
                    groupValue: _trueFalseAnswer,
                    onChanged: (value) {
                      setState(() {
                        _trueFalseAnswer = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Faux'),
                    value: false,
                    groupValue: _trueFalseAnswer,
                    onChanged: (value) {
                      setState(() {
                        _trueFalseAnswer = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        );

      case QuestionType.singleAnswer:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrez la réponse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Saisissez la réponse correcte',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );

      case QuestionType.selection:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajouter des options',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _optionController,
                    decoration: InputDecoration(
                      hintText: 'Nouvelle option',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_optionController.text.isNotEmpty) {
                      setState(() {
                        _options.add(_optionController.text);
                        _optionController.clear();
                      });
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_options.isNotEmpty) ...[
              const Text(
                'Options ajoutées:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_options[index]),
                    leading: Radio<String>(
                      value: _options[index],
                      groupValue: _answerController.text,
                      onChanged: (value) {
                        setState(() {
                          _answerController.text = value!;
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          if (_answerController.text == _options[index]) {
                            _answerController.clear();
                          }
                          _options.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        );
    }
  }

  Widget _buildQuestionItem(Question question, int index) {
    String answerText = '';
    switch (question.type) {
      case QuestionType.trueFalse:
        answerText = question.answer ? 'Vrai' : 'Faux';
        break;
      case QuestionType.singleAnswer:
      case QuestionType.selection:
        answerText = question.answer.toString();
        break;
    }

    return Card(
      child: ListTile(
        title: Text(question.questionText),
        subtitle: Text(
            'Type: ${question.type.name}\nRéponse: $answerText\nPoints: ${question.points}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _questions.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  Widget _buildSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Limite de temps',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _timeLimit = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedTimeUnit,
              items: ['Secondes', 'Minutes', 'Heures']
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedTimeUnit = value;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Note de passage(%)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _passingScore = int.tryParse(value) ?? 75;
            });
          },
          controller: TextEditingController(text: _passingScore.toString()),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          TextButton(
            onPressed: () => setState(() => _currentStep--),
            child: const Text('Retour'),
          ),
        TextButton(
          onPressed: _currentStep < 2
              ? () => setState(() => _currentStep++)
              : _createQuiz,
          child: Text(_currentStep < 2 ? 'Suivant' : 'Enregistrer'),
        ),
      ],
    );
  }

  void _resetAnswerFields() {
    setState(() {
      _answerController.clear();
      _options.clear();
      _trueFalseAnswer = true;
    });
  }

  void _addQuestion() {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir une question')),
      );
      return;
    }

    // Validation spécifique selon le type
    switch (_selectedQuestionType) {
      case QuestionType.selection:
        if (_options.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez ajouter des options')),
          );
          return;
        }
        if (_answerController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Veuillez sélectionner la bonne réponse')),
          );
          return;
        }
        break;
      case QuestionType.singleAnswer:
        if (_answerController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez saisir la réponse')),
          );
          return;
        }
        break;
      case QuestionType.trueFalse:
        // Pas besoin de validation supplémentaire
        break;
    }

    setState(() {
      _questions.add(Question(
        questionText: _questionController.text,
        type: _selectedQuestionType,
        answer: _selectedQuestionType == QuestionType.trueFalse
            ? _trueFalseAnswer
            : _answerController.text,
        points: _questionPoints,
        choices: _selectedQuestionType == QuestionType.selection
            ? List.from(_options)
            : null,
      ));

      // Réinitialiser les champs
      _questionController.clear();
      _answerController.clear();
      _options.clear();
    });
  }

  void _createQuiz() {
    if (_quizTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un titre pour le quiz')),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins une question')),
      );
      return;
    }

    if (_timeLimit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez définir une limite de temps valide')),
      );
      return;
    }

    final quiz = Quiz(
      title: _quizTitleController.text,
      questions: _questions,
      timeLimit: _timeLimit,
      timeUnit: _selectedTimeUnit,
      passingScore: _passingScore,
    );

    widget.onQuizCreated(quiz);
  }

  @override
  void dispose() {
    _quizTitleController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    _optionController.dispose();
    super.dispose();
  }
}
