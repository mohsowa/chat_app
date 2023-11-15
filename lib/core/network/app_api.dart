import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/features/auth/auth_di.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String _baseUrl = dotenv.env['API_URL'] ?? '';
final client = sl.get<http.Client>();
final authCubit = sl.get<AuthCubit>();

Future<http.StreamedResponse> appApiRequest({Map<String, String>? data, http.MultipartFile? file, required String endPoint, required String method, bool isAuth = true}) async {
  try{
    final token = authCubit.user.access_token;
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(method, Uri.parse(_baseUrl + endPoint));

    if (data != null) {
      request.fields.addAll(data);
    }

    if (file != null) {
      request.files.add(file);
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await client.send(request);

    if(response.statusCode == 401){
      if(isAuth){
        //authCubit.add(LogOutEvent(navigatorKey.currentState!.context));
      } else {
        throw Exception('Unauthorized');
      }
    }

    if(response.statusCode == 404){
      throw Exception('Not Found');
    }

    if(response.statusCode == 500){
      throw Exception('Internal Server Error');
    }

    if(response.statusCode == 503){
      throw Exception('Service Unavailable');
    }

    if(response.statusCode == 504){
      throw Exception('Gateway Timeout');
    }

    return response;
  } on Exception catch (e) {
    throw ServerException(message: e.toString());
  }

}




