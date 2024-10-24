import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Index pour la bottomNavigationBar (PROFILS)

  // Données de test pour l'utilisateur
  final Map<String, String> _userData = {
    'fullName': 'John Doe',
    'username': 'johndoe',
    'birthDate': '15/04/1990',
    'email': 'john.doe@example.com',
    'phone': '(+226) 70975644',
    'status': 'Administrateur',
  };

  void _onBottomNavTap(int index) {
    if (_selectedIndex != index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/mes-cours');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/xcode');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/ranks');
          break;
        case 4:
          // Déjà sur la page profil
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Photo de profil
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Informations de l'utilisateur
            _buildInfoCard(
              title: 'Nom complet',
              value: _userData['fullName']!,
              icon: Icons.person_outline,
            ),
            _buildInfoCard(
              title: "Nom d'utilisateur",
              value: _userData['username']!,
              icon: Icons.account_circle_outlined,
            ),
            _buildInfoCard(
              title: 'Date de naissance',
              value: _userData['birthDate']!,
              icon: Icons.calendar_today,
            ),
            _buildInfoCard(
              title: 'Adresse mail',
              value: _userData['email']!,
              icon: Icons.mail_outline,
            ),
            _buildInfoCard(
              title: 'Téléphone',
              value: _userData['phone']!,
              icon: Icons.phone_outlined,
            ),
            _buildInfoCard(
              title: 'Status',
              value: _userData['status']!,
              icon: Icons.admin_panel_settings_outlined,
              valueColor: Colors.grey,
            ),

            const SizedBox(height: 30),

            // Bouton Modifier
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Modifier',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.edit),
                ],
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

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
