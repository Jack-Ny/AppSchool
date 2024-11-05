import 'package:app_school/screens/student/tp/student_tp_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../models/quiz.dart';
import '../../models/tp.dart';

class StudentCourseDetailScreen extends StatefulWidget {
  final String courseTitle;

  const StudentCourseDetailScreen({
    Key? key,
    required this.courseTitle,
  }) : super(key: key);

  @override
  State<StudentCourseDetailScreen> createState() =>
      _StudentCourseDetailScreenState();
}

class _StudentCourseDetailScreenState extends State<StudentCourseDetailScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    _initCourse();
  }

  void _initCourse() {
    course = Course(
      name: widget.courseTitle,
      modules: [
        Module(
          name: 'Module 1 : Introduction',
          quizzes: [
            Quiz(
              title: 'QUIZZ : Algorithme',
              questions: [],
              timeLimit: 30,
              timeUnit: 'minutes',
              isCompleted: true,
            ),
          ],
          tps: [
            TP(
              title: 'TPs : Algorithme',
              description: 'Exercices pratiques sur les algorithmes',
              isCompleted: true,
            ),
          ],
        ),
        Module(
          name: 'Module 2 : Algorithme',
          quizzes: [
            Quiz(
              title: 'QUIZZ : Algorithme',
              questions: [],
              timeLimit: 30,
              timeUnit: 'minutes',
            ),
          ],
          tps: [
            TP(
              title: 'TPs : Algorithme',
              description: 'Exercices pratiques sur les algorithmes',
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToContent(String contentTitle, String type, bool isCompleted) {
    if (!isCompleted) {
      if (type == 'quiz') {
        Navigator.pushNamed(
          context,
          '/student/quiz',
          arguments: {
            'title': contentTitle,
            'courseTitle': widget.courseTitle,
          },
        );
      } else if (type == 'tp') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentTPScreen(
              moduleTitle: contentTitle,
              courseTitle: widget.courseTitle,
            ),
          ),
        );
      }
    }
  }

  double _calculateProgress() {
    int total = 0;
    int completed = 0;

    for (var module in course.modules) {
      for (var quiz in module.quizzes) {
        total++;
        if (quiz.isCompleted) completed++;
      }
      for (var tp in module.tps) {
        total++;
        if (tp.isCompleted) completed++;
      }
    }

    return total > 0 ? completed / total : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(progress),
              const SizedBox(height: 20),
              _buildModulesList(),
              if (progress < 1.0) _buildContinueButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(double progress) {
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage('assets/images/code_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.courseTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}% complété',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModulesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: course.modules.map((module) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                module.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...module.quizzes.map((quiz) =>
                  _buildContentItem(quiz.title, 'quiz', quiz.isCompleted)),
              ...module.tps.map(
                  (tp) => _buildContentItem(tp.title, 'tp', tp.isCompleted)),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentItem(String title, String type, bool isCompleted) {
    return InkWell(
      onTap: () => _navigateToContent(title, type, isCompleted),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              type == 'quiz' ? Icons.quiz : Icons.description,
              color: isCompleted ? Colors.green : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          for (var module in course.modules) {
            for (var quiz in module.quizzes) {
              if (!quiz.isCompleted) {
                _navigateToContent(quiz.title, 'quiz', false);
                return;
              }
            }
            for (var tp in module.tps) {
              if (!tp.isCompleted) {
                _navigateToContent(tp.title, 'tp', false);
                return;
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          _calculateProgress() == 0 ? 'Commencer' : 'Continuer',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/student-dashboard');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/student/xcode');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/student/ranks');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/student/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BORD'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'MES COURS'),
        BottomNavigationBarItem(icon: Icon(Icons.code), label: 'XCODE'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'RANGS'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILS'),
      ],
    );
  }
}
