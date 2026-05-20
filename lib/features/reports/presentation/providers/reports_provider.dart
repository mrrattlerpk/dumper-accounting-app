import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/trip_repository_impl.dart';
import '../../../../data/repositories/driver_repository_impl.dart';
import '../../../../data/repositories/customer_repository_impl.dart';
import '../../../../domain/usecases/report_use_cases.dart';

/// Provider that exposes the ReportUseCases instance.
final reportUseCasesProvider = Provider<ReportUseCases>((ref) {
  final tripRepo = ref.watch(tripRepositoryProvider);
  final driverRepo = ref.watch(driverRepositoryProvider);
  final customerRepo = ref.watch(customerRepositoryProvider);
  return ReportUseCases(tripRepo, driverRepo, customerRepo);
});