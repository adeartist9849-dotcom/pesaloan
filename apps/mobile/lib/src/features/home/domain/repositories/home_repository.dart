import 'package:pesaloan/src/features/home/domain/models/dashboard_model.dart';

abstract class HomeRepository {
  Future<DashboardModel> getDashboard();
}