import 'package:app_school/screens/student/student_course_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class StudentCoursesScreen extends StatefulWidget {
  const StudentCoursesScreen({Key? key}) : super(key: key);

  @override
  State<StudentCoursesScreen> createState() => _StudentCoursesScreenState();
}

class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
  int _selectedIndex = 1; // Pour la bottom navigation bar

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Graphic Design Advanced',
      'category': 'Codage informatique',
      'students': 12,
      'rating': 4.2,
      'status': 'En cours',
      'image': 'assets/images/course1.jpg',
      'isStarted': true,
    },
    {
      'title': 'Graphic Design Advanced',
      'category': 'Codage informatique',
      'students': 12,
      'rating': 4.2,
      'status': 'Non commencer',
      'image': 'assets/images/course2.jpg',
      'isStarted': false,
    },
  ];

  void _onBottomNavTap(int index) {
    if (_selectedIndex != index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/student-dashboard');
          break;
        case 1:
          // Déjà sur la page des cours
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cours',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return _buildCourseCard(course);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
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

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentCourseDetailScreen(
                courseTitle: course['title'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Stack(
              children: [
                // Image du cours
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    course['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.blue.withOpacity(0.1),
                      child: Icon(
                        Icons.code,
                        size: 50,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ),
                ),
                // Bookmark icon
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course['category'],
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Titre du cours
                  Text(
                    course['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Informations du cours
                  Row(
                    children: [
                      // Nombre d'élèves
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 16),
                          const SizedBox(width: 4),
                          Text('${course['students']}'),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Note
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${course['rating']}'),
                        ],
                      ),
                      const Spacer(),

                      // Statut et bouton
                      ElevatedButton(
                        onPressed: () {
                          // Action en fonction du statut
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course['isStarted']
                              ? AppColors.primaryBlue
                              : Colors.grey[200],
                          foregroundColor:
                              course['isStarted'] ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          course['status'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
