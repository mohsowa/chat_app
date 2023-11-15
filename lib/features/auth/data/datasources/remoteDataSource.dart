import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<bool> checkToken(String token);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<bool> checkToken(String token) async {
    final res = await appApiRequest(
      endPoint: '/user/verify',
      method: 'GET',
    );


    if(res.statusCode == 200){
      return Future.value(true);
    } else if (res.statusCode == 401){
      return Future.value(false);
    } else {
      throw ServerException(message: 'Token check failed');
    }

  }
}