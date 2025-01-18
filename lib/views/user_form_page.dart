import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';


class UserFormPage extends StatefulWidget {
  final User? user;
  final bool isEditing;

  const UserFormPage({super.key, this.user, required this.isEditing});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  late String gender;
  late String status;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.user != null) {
      name = widget.user!.name;
      email = widget.user!.email;
      gender = widget.user!.gender;
      status = widget.user!.status;
    } else {
      name = '';
      email = '';
      gender = 'male';
      status = 'active';
    }
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = User(
        id: widget.user?.id ?? 0,
        name: name,
        email: email,
        gender: gender,
        status: status,
      );

      try {
        if (widget.isEditing) {
          // Only update if editing=true
          await ApiService().updateUser(user.id!, user);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );
        } else {
          // Create new user
          await ApiService().createUser(user);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully!')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a name' : null,
                onSaved: (value) {
                  name = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                onSaved: (value) {
                  gender = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                onSaved: (value) {
                  status = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text(widget.isEditing ? 'Update User' : 'Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
