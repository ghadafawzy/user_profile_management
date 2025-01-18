import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://gorest.co.in/public/v2',
      headers: {
        'Authorization': '9d728d612ea08b05ddf2dab1bb1a48639df56c6ac20bb66431ea437bf35823e6',
      },
    ),
  );

  Future<List<User>> fetchUsers() async {
    try {
      final response = await dio.get('/users');
      return (response.data as List).map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await dio.post('/users', data: user.toJson());
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(int id, User user) async {
    try {
      final response = await dio.put('/users/$id', data: user.toJson());
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await dio.delete('/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
