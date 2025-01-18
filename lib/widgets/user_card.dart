import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserCard({super.key, required this.user, required this.onDelete , required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
