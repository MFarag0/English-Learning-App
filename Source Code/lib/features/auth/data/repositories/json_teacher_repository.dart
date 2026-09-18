import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kalimati_app/features/auth/domain/contracts/user_repo.dart';
import 'package:kalimati_app/features/auth/domain/entities/user.dart';

class JsonTeacherRepository implements UserRepo {
  List<User> teachers = [];

  // Load all teachers from users.json
  Future<List<User>> getAllTeachers() async {
    if (teachers.isNotEmpty) return teachers;

    final String data = await rootBundle.loadString("assets/data/users.json");
    final List<dynamic> usersMap = jsonDecode(data);

    teachers = usersMap
        .map((json) => User.fromJson(json))
        .where((user) => user.role.toLowerCase() == "teacher")
        .toList();

    return teachers;
  }

  @override
  User? authenticate(String email, String password) {
    if (teachers.isEmpty) return null;

    try {
      return teachers.firstWhere(
        (teacher) =>
            teacher.email.toLowerCase() == email.toLowerCase() &&
            teacher.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  // Return all teachers
  @override
  Future<List<User>> getAllUsers() async {
    return await getAllTeachers();
  }
}
