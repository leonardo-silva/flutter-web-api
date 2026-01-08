import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = "http://192.168.1.4:3000/";
  static const String resource = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [HttpInterceptors()]);

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {"Content-Type": "application/json"},
      body: jsonJournal,
    );
    return (response.statusCode == 201);
  }

  Future<bool> edit(String id, Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonJournal,
    );
    return (response.statusCode == 200);
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));

    if (response.statusCode != 200) {
      throw Exception();
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var map in listDynamic) {
      list.add(Journal.fromMap(map));
    }

    return list;
  }

  Future<bool> delete(String id) async {
    http.Response response = await http.delete(Uri.parse("${getUrl()}$id"));
    return (response.statusCode == 200);
  }
}
