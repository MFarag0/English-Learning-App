import 'package:kalimati_app/features/auth/domain/entities/user.dart';

abstract class UserRepo {
  Future<List<User>> getAllUsers();
  User? authenticate(String email, String password);
}
