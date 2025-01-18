import 'package:flutter/material.dart';
import 'package:user_profile_management/views/user_form_page.dart';
import '../models/user_model.dart';


class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Gender: ${user.gender}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Status: ${user.status}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserFormPage(user: user, isEditing: true),
                  ),
                ).then((_) => Navigator.pop(context));
              },
              child: const Text('Edit User'),
            ),
          ],
        ),
      ),
    );
  }
}