import 'dart:convert';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = "http://192.168.1.6:3000/";
  static const String resource = "learnhttp";

  http.Client client =
      InterceptedClient.build(interceptors: [HttpInterceptors()]);

  String getUrl() {
    return "$url$resource";
  }

  register(String content) {
    print("register: $content");
    // String completeUrl = getUrl();
    // print("completeUrl = $completeUrl");
    // http.post(Uri.parse(completeUrl), body: {"content": content});
    // print(response.statusCode);
    client.post(
      Uri.parse(getUrl()),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"content": content}),
    );
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    return response.body;
  }
}
