import 'package:flutter/material.dart';

class XCodeScreen extends StatelessWidget {
  const XCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XCode'),
      ),
      body: const Center(
        child: Text('Page XCode en construction'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/admin-dashboard');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/mes-cours');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/ranks');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
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
}
