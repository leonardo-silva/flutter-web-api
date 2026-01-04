import 'dart:convert';

import 'package:http/http.dart' as http;

class JournalService {
  static const String url = "http://192.168.1.6:3000/";
  static const String resource = "learnhttp";

  String getUrl() {
    return "$url$resource";
  }

  register(String content) {
    print("register: $content");
    // String completeUrl = getUrl();
    // print("completeUrl = $completeUrl");
    // http.post(Uri.parse(completeUrl), body: {"content": content});
    // print(response.statusCode);
    http.post(
      Uri.parse(getUrl()),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"content": content}),
    );
  }

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
