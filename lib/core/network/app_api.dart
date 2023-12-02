import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/features/auth/auth_di.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String _baseUrl = dotenv.env['API_URL'] ?? 'https://chat.mohsowa.com/api';
final client = sl.get<http.Client>();
final authCubit = sl.get<AuthCubit>();

Future<http.StreamedResponse> appApiRequest({Map<String, String>? data, http.MultipartFile? file, required String endPoint,bool? auth, required String method, bool isAuth = true, String? token}) async {

  try{

    late var headers;

    if(auth == true){
      final token = authCubit.user.access_token;
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }else if(token != null){
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    else{
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    }


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
        await authCubit.logout();
        throw Exception('Unauthorized');
      } else {
        throw Exception('Unauthorized');
      }
    }

    if(response.statusCode == 400){
      throw Exception('Bad Request');
    }

    if(response.statusCode == 403){
      throw Exception('Forbidden');
    }

    if(response.statusCode == 503){
      throw Exception('Service Unavailable');
    }

    if(response.statusCode == 504){
      throw Exception('Gateway Timeout');
    }

    return response;
  } on Exception catch (e) {
    print(e.toString());
    throw ServerException(message: e.toString());
  }

}




