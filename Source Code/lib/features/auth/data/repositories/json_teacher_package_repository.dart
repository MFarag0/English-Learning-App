import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';

class JsonTeacherPackageRepository {
  List<LearningPackage> _packages = [];
  static const String _assetPath = 'assets/data/packages.json';

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/teacher_packages.json');
  }

  Future<void> _loadPackages() async {
    final file = await _getLocalFile();

    if (await file.exists()) {
      // Read from local file
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      _packages = jsonList.map((e) => LearningPackage.fromJson(e)).toList();
    } else {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      _packages = jsonList.map((e) => LearningPackage.fromJson(e)).toList();
      await _savePackages();
    }
  }

  Future<void> _savePackages() async {
    final file = await _getLocalFile();
    final jsonList = _packages.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<LearningPackage>> getAllPackages() async {
    if (_packages.isEmpty) {
      await _loadPackages();
    }
    return _packages;
  }

  Future<void> addPackage(LearningPackage newPackage) async {
    await _loadPackages();
    _packages.add(newPackage);
    await _savePackages();
  }

  Future<void> updatePackage(LearningPackage updatedPackage) async {
    await _loadPackages();
    final index =
        _packages.indexWhere((p) => p.packageId == updatedPackage.packageId);
    if (index != -1) {
      _packages[index] = updatedPackage;
      await _savePackages();
    }
  }

  Future<void> deletePackage(String id) async {
    await _loadPackages();
    _packages.removeWhere((p) => p.packageId == id);
    await _savePackages();
  }
}
