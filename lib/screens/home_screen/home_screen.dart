import 'package:flutter/material.dart';
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
      body: (userId != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('accessToken');
      int? id = prefs.getInt('id');

      if (token != null && id != null) {
        setState(() {
          userId = id;
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
        });
      } else {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, 'login');
        }
      }
    });
  }
}
