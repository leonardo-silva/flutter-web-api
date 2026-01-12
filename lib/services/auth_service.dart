import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class AuthService {
  //TODO: extract url to be used by all services
  static const String url = "http://192.168.1.4:3000/";

  http.Client client =
      InterceptedClient.build(interceptors: [HttpInterceptors()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}login'),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
        //break;
        default:
      }
      throw HttpException(response.body);
    }

    return true;
  }

  register({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}register'),
        body: {'email': email, 'password': password});
  }
}

class UserNotFoundException implements Exception {}
