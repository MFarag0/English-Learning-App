import 'package:kalimati_app/features/auth/data/repositories/user_json_imp.dart';
import 'package:kalimati_app/features/auth/domain/entities/user.dart';
import 'package:kalimati_app/features/home/data/repository/packages_json_imp.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';

class DataServices {
  static final DataServices _instance = DataServices._internal();
  factory DataServices() => _instance;
  DataServices._internal();
  List<User> users = [];
  List<LearningPackage> packages = [];

  // repository instance
  late final UserJsonImp userRepo;
  late final PackagesJsonImp packageRepo;

  bool _isInitialized = false;
  Future<void>? _initializing;

  /// Initialize all repositories and pre-load data
  /// Call this once at app startup
  Future<void> initialize() async {
    if (_isInitialized) return;
    // Prevent concurrent initialization attempts
    if (_initializing != null) return await _initializing!;

    _initializing = () async {
      try {
        // Create repository instances
        userRepo = UserJsonImp();
        packageRepo = PackagesJsonImp();
        // Pre-load all data into cache
        users = await userRepo.getAllUsers();
        packages = await packageRepo.getAllPackages();

        _isInitialized = true;
      } catch (e) {
        throw Exception('Failed to initialize data: $e');
      } finally {
        // clear initializing future
        _initializing = null;
      }
    }();

    return await _initializing;
  }

  // match user email with the package author to delete it
  // void deletePackage(String packageId,String email) {

  // }
  // List<LearningPackage> searchPackageByLevel(String query) {

  //   return packages
  //       .where((pac) => pac.level.toLowerCase().contains(query.toLowerCase()))
  //       .toList() ;
  // }

  User? authenticate(String email, String password) {
    _ensureInitialized();
    try {
      return userRepo.users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('DataService not initialized. Call initialize() first.');
    }
  }
}
