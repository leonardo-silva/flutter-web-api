import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class Webclient {
  static const String url = "http://192.168.1.4:3000/";

  http.Client client = InterceptedClient.build(
      interceptors: [HttpInterceptors()], requestTimeout: Duration(seconds: 5));
}
