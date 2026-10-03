import 'package:dio/dio.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/home/domain/repositories/home_repository.dart';
import 'package:pesaloan/src/features/home/domain/models/dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<DashboardModel> getDashboard() async {
    try {
      final response = await DioClient.instance.get('/loans/dashboard');
      return DashboardModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}