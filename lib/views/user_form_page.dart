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
    _initializeUserDetails();
  }

  void _initializeUserDetails() {
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
            const SnackBar(content: Text('User updated successfully!'),backgroundColor: Colors.green,),
    );
        } else {
          // Create new user
          await ApiService().createUser(user);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully!'),backgroundColor: Colors.green),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user: $e'),backgroundColor: Colors.red),
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
              _buildTextFormField(
                labelText: 'Name',
                initialValue: name,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                labelText: 'Email',
                initialValue: email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 10),
              _buildDropdownButtonFormField(
                labelText: 'Gender',
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (value) => setState(() => gender = value!),
                onSaved: (value) => gender = value!,
              ),
              const SizedBox(height: 10),
              _buildDropdownButtonFormField(
                labelText: 'Status',
                value: status,
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) => setState(() => status = value!),
                onSaved: (value) => status = value!,
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
  Widget _buildTextFormField({
    required String labelText,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownButtonFormField({
    required String labelText,
    required String value,
    required List<DropdownMenuItem<String>> items,
    ValueChanged<String?>? onChanged,
    FormFieldSetter<String>? onSaved,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: labelText),
      items: items,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
