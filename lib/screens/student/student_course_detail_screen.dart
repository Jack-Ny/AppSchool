// lib/screens/student/student_course_detail_screen.dart
import 'package:app_school/screens/student/tp/student_tp_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/course_module.dart';

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
  late List<CourseModule> _modules;

  @override
  void initState() {
    super.initState();
    _initModules();
  }

  void _initModules() {
    _modules = [
      CourseModule(
        title: 'Module 1 : Introduction',
        contents: [
          ModuleContent(
            title: 'QUIZZ : Algorithme',
            type: ContentType.quiz,
            isCompleted: true,
          ),
          ModuleContent(
            title: 'TPs : Algorithme',
            type: ContentType.tp,
            isCompleted: true,
          ),
        ],
      ),
      CourseModule(
        title: 'Module 2 : Algorithme',
        contents: [
          ModuleContent(
            title: 'QUIZZ : Algorithme',
            type: ContentType.quiz,
          ),
          ModuleContent(
            title: 'TPs : Algorithme',
            type: ContentType.tp,
          ),
        ],
      ),
    ];
  }

  void _navigateToContent(ModuleContent content) {
    if (!content.isCompleted) {
      if (content.type == ContentType.quiz) {
        Navigator.pushNamed(
          context,
          '/student/quiz',
          arguments: {
            'title': content.title,
            'courseTitle': widget.courseTitle,
          },
        );
      } else if (content.type == ContentType.tp) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentTPScreen(
              moduleTitle: content.title,
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

    for (var module in _modules) {
      for (var content in module.contents) {
        total++;
        if (content.isCompleted) completed++;
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
              Stack(
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
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
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
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _modules.map((module) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...module.contents
                            .map((content) => _buildContent(content)),
                        const SizedBox(height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
              if (progress < 1.0)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      for (var module in _modules) {
                        for (var content in module.contents) {
                          if (!content.isCompleted) {
                            _navigateToContent(content);
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
                      progress == 0 ? 'Commencer' : 'Continuer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  Widget _buildContent(ModuleContent content) {
    return InkWell(
      onTap: () => _navigateToContent(content),
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
              content.type == ContentType.quiz ? Icons.quiz : Icons.description,
              color: content.isCompleted ? Colors.green : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                content.title,
                style: TextStyle(
                  color: content.isCompleted ? Colors.green : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: content.isCompleted ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
