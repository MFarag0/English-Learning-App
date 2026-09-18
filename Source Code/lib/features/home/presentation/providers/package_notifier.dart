import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:kalimati_app/features/home/data/repository/packages_json_imp.dart';
import 'package:kalimati_app/features/auth/data/repositories/json_teacher_package_repository.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';

class PackageNotifier extends AsyncNotifier<List<LearningPackage>> {
  final repo = PackagesJsonImp();

  late List<LearningPackage> _allpackages;

  @override
  FutureOr<List<LearningPackage>> build() async {
    // Depend on refresh provider so callers can trigger a rebuild by incrementing it
    ref.watch(packageRefreshProvider);
    // Load packages from assets
    _allpackages = await repo.getAllPackages();

    // Also include any teacher-created packages saved locally so Learn shows them too
    try {
      final teacherRepo = JsonTeacherPackageRepository();
      final teacherPackages = await teacherRepo.getAllPackages();
      // Merge, preferring teacher packages when ids collide
      final Map<String, LearningPackage> map = {
        for (var p in _allpackages) p.packageId: p,
      };
      for (var tp in teacherPackages) {
        map[tp.packageId] = tp;
      }
      _allpackages = map.values.toList();
    } catch (_) {
      // ignore teacher repo errors and return asset packages
    }
    return _allpackages;
  }

  void search(String query) {
    if (query.isEmpty) {
      state = AsyncData(_allpackages);
      return;
    }

    state = AsyncData(
      _allpackages
          .where((pac) => pac.level.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );
  }
}

final packageRefreshProvider = StateProvider<int>((ref) => 0);

final packageNotifierProvider =
    AsyncNotifierProvider<PackageNotifier, List<LearningPackage>>(
      () => PackageNotifier(),
    );
