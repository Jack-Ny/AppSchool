import 'package:app_school/screens/users/users_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  String _selectedFilter = 'Tout';

  final List<Map<String, dynamic>> _statsCards = [
    {
      'title': 'UTILISATEURS',
      'count': '22',
      'icon': Icons.people,
      'color': AppColors.userCard,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF246BFD), Color(0xFF1E5AE9)],
      ),
    },
    {
      'title': 'COURS',
      'count': '22',
      'icon': Icons.school,
      'color': AppColors.courseCard,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)],
      ),
    },
    {
      'title': 'TPS',
      'count': '22',
      'icon': Icons.assignment,
      'color': AppColors.tpCard,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
      ),
    },
    {
      'title': 'QUIZZ',
      'count': '22',
      'icon': Icons.quiz,
      'color': AppColors.quizCard,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFB74D), Color(0xFFFFA000)],
      ),
    },
  ];

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Conception de programme',
      'category': 'Informatique',
      'instructor': 'Mr Ouédraogo',
      'students': 12,
    },
    // Ajoutez d'autres cours ici
  ];

  void _onBottomNavTap(int index) {
    if (_selectedIndex != index) {
      switch (index) {
        case 0: // BORD
          setState(() => _selectedIndex = 0);
          break;
        case 1: // MES COURS
          Navigator.pushReplacementNamed(context, '/mes-cours');
          break;
        case 2: // XCODE
          Navigator.pushReplacementNamed(context, '/xcode');
          break;
        case 3: // RANGS
          Navigator.pushReplacementNamed(context, '/ranks');
          break;
        case 4: // PROFILS
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tableau de bord',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Grille des statistiques avec scroll horizontal si nécessaire
            SizedBox(
              height: 140, // Hauteur fixe pour les cartes
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _statsCards.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                    width: 160, // Largeur fixe pour les cartes
                    child: _buildStatCard(_statsCards[index]),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Section "Tout les cours"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tout les cours',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/mes-cours');
                          },
                          child: Row(
                            children: const [
                              Text(
                                'VOIR TOUS',
                                style: TextStyle(color: Colors.blue),
                              ),
                              Icon(Icons.chevron_right, color: Colors.blue),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Filtres
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Tout'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Informatique'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Liste des cours
                    Expanded(
                      child: ListView.builder(
                        itemCount: _courses.length,
                        itemBuilder: (context, index) =>
                            _buildCourseCard(_courses[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'BORD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'MES COURS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'XCODE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'RANGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILS',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> card) {
    return GestureDetector(
      onTap: () {
        if (card['title'] == 'UTILISATEURS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UsersScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: card['gradient'],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: card['color'].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                card['icon'],
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              card['count'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card['title'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? label : 'Tout';
        });
      },
      backgroundColor: isSelected ? AppColors.accent : Colors.grey[100],
      selectedColor: AppColors.accent,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      elevation: isSelected ? 2 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF246BFD), Color(0xFF1E5AE9)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.code, color: Colors.white),
        ),
        title: Text(
          course['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                course['category'],
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(
                  '${course['students']}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  course['instructor'],
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.bookmark_border,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
