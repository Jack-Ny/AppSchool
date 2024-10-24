// lib/screens/users/users_screen.dart
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  void _showAddUserModal(BuildContext context) {
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedUserType = 'Élèves';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AJOUTER UN UTILISATEUR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Nom complet
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Nom complet de l\'utilisateur',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Type d'utilisateur
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedUserType,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'Élèves', child: Text('Élèves')),
                            DropdownMenuItem(
                                value: 'Parent', child: Text('Parent')),
                            DropdownMenuItem(
                                value: 'Formateur', child: Text('Formateur')),
                            DropdownMenuItem(
                                value: 'Administrateur',
                                child: Text('Administrateur')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedUserType = value!;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Adresse mail de l\'utilisateur',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),
                // Bouton d'enregistrement
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validation des champs
                      if (fullNameController.text.isEmpty ||
                          emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez remplir tous les champs'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Ajouter le nouvel utilisateur
                      setState(() {
                        _users.add({
                          'name': fullNameController.text,
                          'email': emailController.text,
                          'type': selectedUserType,
                        });
                        _filterUsers(); // Mettre à jour la liste filtrée
                      });

                      // Fermer le modal et afficher un message de succès
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Utilisateur ajouté avec succès'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'ENREGISTRER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final _searchController = TextEditingController();
  List<Map<String, String>> _users = [
    {
      'name': 'Ouedraogo Alasse',
      'email': 'alass12@gmail.com',
      'type': 'Élève',
    },
    {
      'name': 'Kabore Jean',
      'email': 'jean.k@gmail.com',
      'type': 'Formateur',
    },
    // Ajoutez d'autres utilisateurs
  ];
  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _users;
    _searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        return user['name']!.toLowerCase().contains(query) ||
            user['email']!.toLowerCase().contains(query) ||
            user['type']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _confirmDelete(Map<String, String> user) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Voulez-vous vraiment supprimer l\'utilisateur ${user['name']} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _users.remove(user);
                  _filterUsers();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Utilisateur supprimé avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Utilisateurs',
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un utilisateur...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showAddUserModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun utilisateur trouvé',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.primaryBlue.withOpacity(0.1),
                            child: Text(
                              user['name']![0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(user['email']!),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['type']!,
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Implémenter la modification
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(user),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
