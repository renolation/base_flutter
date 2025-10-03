import 'package:base_flutter/core/utils/utils.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/environment_config.dart';
import '../../../../core/services/api_service.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
}

class TodoRemoteDataSourceImpl extends BaseApiService
    implements TodoRemoteDataSource {
  TodoRemoteDataSourceImpl({required DioClient dioClient}) : super(dioClient);

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await dioClient.get(EnvironmentConfig.todosEndpoint);

    if (response.data is List) {
      final List<dynamic> todosJson = response.data as List<dynamic>;
      return todosJson
          .map((json) => TodoModel.fromJson(json as DataMap))
          .toList();
    } else {
      throw Exception('Expected List but got ${response.data.runtimeType}');
    }
  }
}
