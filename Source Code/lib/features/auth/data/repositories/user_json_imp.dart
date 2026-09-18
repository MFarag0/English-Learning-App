import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kalimati_app/features/auth/domain/contracts/user_repo.dart';
import 'package:kalimati_app/features/auth/domain/entities/user.dart';

class UserJsonImp implements UserRepo {
  List<User> users = [];
  @override
  @override
  Future<List<User>> getAllUsers() async {
    final String data = await rootBundle.loadString(
      "assets/data/users.json",
    ); // string

    final List<dynamic> usersMap = jsonDecode(data); // list
    users = usersMap.map((pack) => User.fromJson(pack)).toList();
    return users;
  }

  @override
  User? authenticate(String email, String password) {
    try {
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
