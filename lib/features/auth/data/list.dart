import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leontech/core/utils/function_string.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final List<Map<String, dynamic>> types = [
    {'value': 1, 'label': 'Administrator'},
    {'value': 2, 'label': 'Pelanggan'},
    {'value': 3, 'label': 'Pengguna Baru'}
  ];

  // Menampilkan daftar pengguna
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            dp('Error: ${snapshot.error}');
            // return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            dp('!snapshot.hasData || snapshot.data!.docs.isEmpty');
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final String displayName = user['displayName'] ?? 'No name';
              final String email = user['email'] ?? 'No email';
              final String photoURL = user['photoURL'] ?? '';
              final DateTime createdAt = user['createdAt']?.toDate() ?? DateTime.now();
              final int type = user['type'] ?? 3; // Default to 'Pengguna Baru'

              return ListTile(
                leading: photoURL.isNotEmpty
                    ? CircleAvatar(
                      radius: 20.0, // Ukuran avatar (opsional)
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: photoURL,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_gettypeLabel(type)),
                        Text(createdAt.toLocal().toString()),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showEdittypeDialog(user.id, type);
                },
              );
            },
          );
        },
      ),
    );
  }

  String _gettypeLabel(int type) {
    switch (type) {
      case 1:
        return 'Administrator';
      case 2:
        return 'Pelanggan';
      case 3:
      default:
        return 'Pengguna Baru';
    }
  }

  // Menampilkan dialog untuk memilih type pengguna
  Future<void> _showEdittypeDialog(String userId, int currenttype) async {
    int selectedType = currenttype;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User harus memilih atau menutup dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Type'),
          content: DropdownButtonFormField<int>(
            value: selectedType,
            onChanged: (int? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: types.map((type) {
              return DropdownMenuItem<int>(
                value: type['value'],
                child: Text(type['label']),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Select User Type'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updatetype(userId, selectedType);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memperbarui type pengguna di Firestore
  Future<void> _updatetype(String userId, int type) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'type': type,
      });
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User type updated successfully.')),
      );
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
