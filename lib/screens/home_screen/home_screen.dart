import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/screens/common/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  // In this case we need to use int? because the userId can be null for a few moments, until the SharedPreferences have the information
  int? userId;
  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                logout(context);
              },
              title: Text('Log out'),
              leading: Icon(Icons.logout),
            )
          ],
        ),
      ),
      body: (userId != null && userToken != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
                token: userToken!,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void refresh() {
    final currentContext = context; // Capture context here!

    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('accessToken');
      int? id = prefs.getInt('id');

      if (token != null && id != null) {
        setState(() {
          userId = id;
          userToken = token;
        });
        service
            .getAll(id: id.toString(), token: token)
            .then((List<Journal> listJournal) {
          setState(() {
            // database = generateRandomDatabase(maxGap: windowPage, amount: 3);
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        }).catchError(
          (error) {
            if (currentContext.mounted) {
              logout(currentContext);
            }
          },
          test: (error) => error is TokenNotValidException,
        ).catchError(
          (error) {
            if (currentContext.mounted) {
              HttpException innerError = error;
              showExceptionDialog(currentContext, content: innerError.message);
            }
          },
          test: (error) => error is HttpException,
        );
      } else {
        if (currentContext.mounted) {
          Navigator.pushReplacementNamed(currentContext, 'login');
        }
      }
    });
  }
}
