import 'package:app_school/screens/student/quiz/student_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/colors.dart';
import 'student_tp_screen.dart';

class StudentCourseDetailScreen extends StatefulWidget {
  final String tpId;
  final String courseId;
  final String courseTitle;

  const StudentCourseDetailScreen({
    super.key,
    required this.tpId,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<StudentCourseDetailScreen> createState() =>
      _StudentCourseDetailScreenState();
}

class _StudentCourseDetailScreenState extends State<StudentCourseDetailScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _modules = [];
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  Future<void> _loadCourseData() async {
    try {
      // Charger les modules
      final modulesData = await _supabase.from('modules').select('''
           *,
           quizzes:quizzes(*),
           tps:tps(*)
         ''').eq('course_id', widget.courseId);

      // Charger la progression de l'étudiant
      final userId = _supabase.auth.currentUser?.id;
      final quizAttempts = await _supabase
          .from('quiz_attempts')
          .select()
          .eq('student_id', userId);

      final tpSubmissions = await _supabase
          .from('tp_submissions')
          .select()
          .eq('student_id', userId);

      setState(() {
        _modules = List<Map<String, dynamic>>.from(modulesData);
        _calculateProgress(quizAttempts, tpSubmissions);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _calculateProgress(
      List<dynamic> quizAttempts, List<dynamic> tpSubmissions) {
    int totalItems = 0;
    int completedItems = 0;

    for (var module in _modules) {
      final quizzes = List<Map<String, dynamic>>.from(module['quizzes'] ?? []);
      final tps = List<Map<String, dynamic>>.from(module['tps'] ?? []);

      totalItems += quizzes.length + tps.length;

      for (var quiz in quizzes) {
        if (quizAttempts.any((attempt) => attempt['quiz_id'] == quiz['id'])) {
          completedItems++;
        }
      }

      for (var tp in tps) {
        if (tpSubmissions
            .any((submission) => submission['tp_id'] == tp['id'])) {
          completedItems++;
        }
      }
    }

    _progress = totalItems > 0 ? completedItems / totalItems : 0.0;
  }

  void _navigateToContent(
      String contentId, String type, bool isCompleted, String moduleTitle) {
    if (!isCompleted) {
      if (type == 'quiz') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentQuizScreen(
              quizId: contentId,
              moduleId: moduleTitle,
              moduleTitle: moduleTitle,
              courseTitle: widget.courseTitle,
            ),
          ),
        );
      } else if (type == 'tp') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentTPScreen(
              moduleTitle: moduleTitle,
              courseTitle: widget.courseTitle,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildModulesList(),
              if (_progress < 1.0) _buildContinueButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
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
                value: _progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 4),
              Text(
                '${(_progress * 100).toInt()}% complété',
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
        children: _modules.map((module) {
          final quizzes =
              List<Map<String, dynamic>>.from(module['quizzes'] ?? []);
          final tps = List<Map<String, dynamic>>.from(module['tps'] ?? []);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                module['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...quizzes.map((quiz) => _buildContentItem(
                    quiz['id'],
                    quiz['title'],
                    'quiz',
                    false, // TODO: Check completion status
                    module['name'],
                  )),
              ...tps.map((tp) => _buildContentItem(
                    tp['id'],
                    tp['title'],
                    'tp',
                    false, // TODO: Check completion status
                    module['name'],
                  )),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentItem(
    String id,
    String title,
    String type,
    bool isCompleted,
    String moduleTitle,
  ) {
    return InkWell(
      onTap: () => _navigateToContent(id, type, isCompleted, moduleTitle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
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
          // Trouver le premier item non complété
          for (var module in _modules) {
            final quizzes =
                List<Map<String, dynamic>>.from(module['quizzes'] ?? []);
            final tps = List<Map<String, dynamic>>.from(module['tps'] ?? []);

            for (var quiz in quizzes) {
              if (!quiz['completed']) {
                _navigateToContent(quiz['id'], 'quiz', false, module['name']);
                return;
              }
            }

            for (var tp in tps) {
              if (!tp['completed']) {
                _navigateToContent(tp['id'], 'tp', false, module['name']);
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
          _progress == 0 ? 'Commencer' : 'Continuer',
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
