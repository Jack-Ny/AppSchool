import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  int _selectedIndex = 3; // Index pour la bottomNavigationBar (RANGS)

  final List<Map<String, dynamic>> _topThree = [
    {
      'name': 'Davis Curtis',
      'points': 2569,
      'image': 'assets/avatars/avatar1.png',
      'position': 1,
      'backgroundColor': const Color(0xFF98FB98),
    },
    {
      'name': 'Alena Donin',
      'points': 1469,
      'image': 'assets/avatars/avatar2.png',
      'position': 2,
      'backgroundColor': const Color(0xFFFFB6C1),
    },
    {
      'name': 'Craig Gouse',
      'points': 1053,
      'image': 'assets/avatars/avatar3.png',
      'position': 3,
      'backgroundColor': const Color(0xFFADD8E6),
    },
  ];

  final List<Map<String, dynamic>> _otherRanks = [
    {
      'name': 'Madelyn Dias',
      'points': 590,
      'image': 'assets/avatars/avatar4.png',
      'position': 4,
      'backgroundColor': const Color(0xFFE6E6FA),
    },
    {
      'name': 'Zain Vaccaro',
      'points': 448,
      'image': 'assets/avatars/avatar5.png',
      'position': 5,
      'backgroundColor': const Color(0xFFFFE4E1),
    },
  ];

  void _onBottomNavTap(int index) {
    if (_selectedIndex != index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/admin/courses');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/admin/xcode');
          break;
        case 3:
          // Déjà sur l'écran des rangs
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/admin/profile');
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
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/admin-dashboard'),
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Podium
          SizedBox(
            height: 450,
            child: Stack(
              alignment: Alignment.center,
              children: [
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
                // Participants - Repositionnés au-dessus du podium
                Positioned(
                  left: 20,
                  bottom: 140, // Ajusté pour être au-dessus du podium
                  child: _buildTopThreeItem(_topThree[1], 180), // 2ème place
                ),
                Positioned(
                  bottom: 180, // Ajusté pour être au-dessus du podium
                  child: _buildTopThreeItem(_topThree[0], 220), // 1ère place
                ),
                Positioned(
                  right: 20,
                  bottom: 100, // Ajusté pour être au-dessus du podium
                  child: _buildTopThreeItem(_topThree[2], 160), // 3ème place
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Liste des autres rangs
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _otherRanks.length,
              itemBuilder: (context, index) {
                final rank = _otherRanks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rank['name'],
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
        ],
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

  Widget _buildTopThreeItem(Map<String, dynamic> user, double height) {
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
        const SizedBox(height: 12),
        Text(
          user['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
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
