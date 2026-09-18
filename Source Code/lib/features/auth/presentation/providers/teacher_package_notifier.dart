import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';
import 'package:kalimati_app/features/auth/data/repositories/json_teacher_package_repository.dart';

final teacherPackageRepoProvider = Provider((ref) => JsonTeacherPackageRepository());

final teacherPackageProvider =
    StateNotifierProvider<TeacherPackageNotifier, AsyncValue<List<LearningPackage>>>(
  (ref) => TeacherPackageNotifier(ref.read(teacherPackageRepoProvider)),
);

class TeacherPackageNotifier extends StateNotifier<AsyncValue<List<LearningPackage>>> {
  final JsonTeacherPackageRepository _repo;

 TeacherPackageNotifier(this._repo) : super(const AsyncValue.loading()) {
  loadPackages();
}


  Future<void> loadPackages() async {
    final packages = await _repo.getAllPackages();
    if (mounted) {
      state = AsyncData(packages);
    }
  }

  Future<void> addPackage(LearningPackage pkg) async {
    try {
      await _repo.addPackage(pkg);
      await loadPackages();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updatePackage(LearningPackage pkg) async {
    try {
      await _repo.updatePackage(pkg);
      await loadPackages();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deletePackage(String id) async {
    try {
      await _repo.deletePackage(id);
      await loadPackages();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
  
}
