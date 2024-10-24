import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CourseStudentsScreen extends StatefulWidget {
  final String courseName;

  const CourseStudentsScreen({
    Key? key,
    required this.courseName,
  }) : super(key: key);

  @override
  State<CourseStudentsScreen> createState() => _CourseStudentsScreenState();
}

class _CourseStudentsScreenState extends State<CourseStudentsScreen> {
  final List<Map<String, String>> _students = [
    {
      'name': 'Ouedraogo Alice',
      'image': 'assets/images/student1.jpg',
    },
    {
      'name': 'Sawadogo Angelna',
      'image': 'assets/images/student2.jpg',
    },
    {
      'name': 'Ky Alexandre',
      'image': 'assets/images/student3.jpg',
    },
  ];

  // Liste des élèves disponibles (non inscrits au cours)
  final List<Map<String, String>> _allAvailableStudents = [
    {
      'id': '1',
      'name': 'Kabore Jean',
    },
    {
      'id': '2',
      'name': 'Zoungrana Marie',
    },
    {
      'id': '3',
      'name': 'Ouedraogo Paul',
    },
    {
      'id': '4',
      'name': 'Bambara Sophie',
    },
    {
      'id': '5',
      'name': 'Diallo Omar',
    },
  ];

  List<Map<String, String>> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStudents = List.from(_allAvailableStudents);
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _allAvailableStudents
          .where((student) =>
              student['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _confirmDelete(Map<String, String> student) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Voulez-vous vraiment retirer ${student['name']} de ce cours ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _students.remove(student);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Élève retiré avec succès'),
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
              child: const Text('Retirer'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentModal() {
    String? selectedStudentId;
    _searchController.clear();
    _filteredStudents = List.from(_allAvailableStudents);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ajouter un élève',
                          style: TextStyle(
                            fontSize: 18,
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
                    // Champ de recherche
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un élève...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filterStudents(value);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Sélectionner un élève'),
                          value: selectedStudentId,
                          items: _filteredStudents.map((student) {
                            return DropdownMenuItem(
                              value: student['id'],
                              child: Text(student['name']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStudentId = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedStudentId == null
                            ? null
                            : () {
                                // Vérifier si l'élève est déjà inscrit
                                final selectedStudent =
                                    _allAvailableStudents.firstWhere(
                                        (s) => s['id'] == selectedStudentId);
                                final isAlreadyEnrolled = _students.any((s) =>
                                    s['name'] == selectedStudent['name']);

                                if (isAlreadyEnrolled) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Cet élève est déjà inscrit au cours'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _students.add({
                                      'name': selectedStudent['name']!,
                                      'image':
                                          'assets/images/default_avatar.jpg',
                                    });
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Élève ajouté avec succès'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'AJOUTER',
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
          'Liste des élèves inscrits au cours',
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
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _showAddStudentModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Ajouter un élève',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
          Expanded(
            child: _students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun élève inscrit',
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
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(student['image']!),
                          ),
                          title: Text(
                            student['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _confirmDelete(student),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
