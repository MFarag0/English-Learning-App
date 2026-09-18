import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';

abstract class PackageRepo {
  Future<List<LearningPackage>> getAllPackages();
  LearningPackage getById(String packageId);
}
