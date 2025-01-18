import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://gorest.co.in/public/v2',
      headers: {
        'Authorization': 'Bearer 9d728d612ea08b05ddf2dab1bb1a48639df56c6ac20bb66431ea437bf35823e6',
      },
    ),
  );

  Future<List<User>> fetchUsers() async {
    try {
      final response = await dio.get('/users');
      debugPrint(response.data.toString());
      return (response.data as List).map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await dio.post('/users', data: user.toJson());
      debugPrint(response.data.toString());
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(int id, User user) async {
    try {
      final response = await dio.put('/users/$id', data: user.toJson());
      debugPrint(response.data.toString());
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await dio.delete('/users/$id');
      debugPrint('User deleted successfully');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete user: $e');
    }
  }
}
