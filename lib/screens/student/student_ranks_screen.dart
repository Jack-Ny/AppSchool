import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class StudentRanksScreen extends StatefulWidget {
  const StudentRanksScreen({super.key});

  @override
  State<StudentRanksScreen> createState() => _StudentRanksScreenState();
}

class _StudentRanksScreenState extends State<StudentRanksScreen> {
  final int _selectedIndex = 3;
  String currentUserId = "3"; // ID de l'élève connecté

  final List<Map<String, dynamic>> _topThree = [
    {
      'id': '1',
      'name': 'Davis Curtis',
      'points': 2569,
      'position': 1,
      'backgroundColor': const Color(0xFF98FB98),
    },
    {
      'id': '2',
      'name': 'Alena Donin',
      'points': 1469,
      'position': 2,
      'backgroundColor': const Color(0xFFFFB6C1),
    },
    {
      'id': '3',
      'name': 'Craig Gouse',
      'points': 1053,
      'position': 3,
      'backgroundColor': const Color(0xFFADD8E6),
    },
  ];

  final List<Map<String, dynamic>> _otherRanks = [
    {
      'id': '4',
      'name': 'Madelyn Dias',
      'points': 590,
      'position': 4,
      'backgroundColor': const Color(0xFFE6E6FA),
    },
    {
      'id': '5',
      'name': 'Zain Vaccaro',
      'points': 448,
      'position': 5,
      'backgroundColor': const Color(0xFFFFE4E1),
    },
  ];

  void _onBottomNavTap(int index) {
    if (_selectedIndex != index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/student-dashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/student/courses');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/student/xcode');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Classement',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Podium
            Container(
              height: 450,
              margin: const EdgeInsets.only(bottom: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Podium - Placé en premier dans le stack
                  Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildPodiumStep('2', 120, Colors.indigo.shade100),
                        const SizedBox(width: 2),
                        _buildPodiumStep('1', 160, Colors.indigo.shade100),
                        const SizedBox(width: 2),
                        _buildPodiumStep('3', 80, Colors.indigo.shade100),
                      ],
                    ),
                  ),
                  // Participants - Positions ajustées
                  Positioned(
                    left: 20,
                    bottom: 140,
                    child: _buildTopThreeItem(_topThree[1]), // 2ème place
                  ),
                  Positioned(
                    bottom: 180,
                    child: _buildTopThreeItem(_topThree[0]), // 1ère place
                  ),
                  Positioned(
                    right: 20,
                    bottom: 100,
                    child: _buildTopThreeItem(_topThree[2]), // 3ème place
                  ),
                ],
              ),
            ),

            // Liste des autres rangs
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    itemCount: _otherRanks.length,
                    itemBuilder: (context, index) {
                      final rank = _otherRanks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: rank['id'] == currentUserId
                              ? AppColors.primaryBlue.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: Center(
                                child: Text(
                                  '${rank['position']}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: rank['backgroundColor'],
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rank['id'] == currentUserId
                                        ? 'Moi'
                                        : rank['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${rank['points']} points',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BORD'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'MES COURS'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'XCODE'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'RANGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILS'),
        ],
      ),
    );
  }

  Widget _buildTopThreeItem(Map<String, dynamic> user) {
    bool isCurrentUser = user['id'] == currentUserId;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user['position'] == 1)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.crop, color: Colors.white),
          ),
        const SizedBox(height: 8),
        CircleAvatar(
          radius: 35,
          backgroundColor: user['backgroundColor'],
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 8),
        Text(
          isCurrentUser ? 'Moi' : user['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${user['points']}',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumStep(String position, double height, Color color) {
    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          position,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
