import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  http.Client client = Webclient().client;
  String url = Webclient.url;

  static const String resource = "journals/";

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonJournal,
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse('${url}users/$id/$resource'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) {
      if (json.decode(response.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var map in listDynamic) {
      list.add(Journal.fromMap(map));
    }

    return list;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(Uri.parse("${getUrl()}$id"),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) {
      if (json.decode(response.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }
}

class TokenNotValidException implements Exception {}
