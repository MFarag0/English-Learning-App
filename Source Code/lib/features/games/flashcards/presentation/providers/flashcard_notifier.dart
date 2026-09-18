import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kalimati_app/features/home/data/repository/packages_json_imp.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';
import 'package:kalimati_app/features/auth/data/repositories/json_teacher_package_repository.dart';


/// this notifier used to get the packages for the UI and in the UI we will get
/// package based on the provided package id

class FlashcardNotifier extends AsyncNotifier<List<LearningPackage>> {
  final repo = PackagesJsonImp();

  late List<LearningPackage> _allpackages;

  @override
  FutureOr<List<LearningPackage>> build() async {
    // Rebuild when packages are refreshed
    ref.watch(packageRefreshProvider);

    // Load packages from assets
    _allpackages = await repo.getAllPackages();

    // Also include teacher-created packages saved locally
    try {
      final teacherRepo = JsonTeacherPackageRepository();
      final teacherPackages = await teacherRepo.getAllPackages();
      final Map<String, LearningPackage> map = {
        for (var p in _allpackages) p.packageId: p,
      };
      for (var tp in teacherPackages) {
        map[tp.packageId] = tp;
      }
      _allpackages = map.values.toList();
    } catch (_) {
      // ignore
    }

    return _allpackages;
  }

  
}

final flashcardNotifierProvider =
    AsyncNotifierProvider<FlashcardNotifier, List<LearningPackage>>(
      () => FlashcardNotifier(),
    );
