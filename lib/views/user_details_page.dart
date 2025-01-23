import 'package:flutter/material.dart';
import 'package:user_profile_management/views/user_form_page.dart';
import '../models/user_model.dart';


class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

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
            _buildUserInfo('Name', user.name),
            _buildUserInfo('Email', user.email),
            _buildUserInfo('Gender', user.gender),
            _buildUserInfo('Status', user.status),
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

  Widget _buildUserInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
