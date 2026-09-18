import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kalimati_app/features/home/domain/contracts/package_repo.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';

class PackagesJsonImp implements PackageRepo {
  List<LearningPackage> packages = [];

  @override
  Future<List<LearningPackage>> getAllPackages() async {
    final data = await rootBundle.loadString(
      "assets/data/packages.json",
    ); // string
    final List<dynamic> jsonBooksMap = jsonDecode(data); // list
    packages = jsonBooksMap
        .map((pack) => LearningPackage.fromJson(pack))
        .toList();
    return packages;
  }

  @override
  LearningPackage getById(String packageId) {
    return packages.firstWhere((pac) => pac.packageId == packageId);
  }
}
