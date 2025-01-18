import 'package:flutter/material.dart';
import 'package:user_profile_management/views/user_details_page.dart';
import 'package:user_profile_management/views/user_form_page.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';


class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() {
    users = ApiService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserFormPage(isEditing: false),
                ),
              ).then((_) => setState(() {
                fetchUsers();
              }));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ApiService().deleteUser(users[index].id!);
                    setState(() {
                      fetchUsers();
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsPage(user: users[index]),
                    ),
                  ).then((_) => setState(() {
                    fetchUsers();
                  }));
                },
              );
            },
          );
        },
      ),
    );
  }
}
