import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  const JournalCard(
      {super.key,
      this.journal,
      required this.showedDate,
      required this.refreshFunction});

  @override
  Widget build(BuildContext context) {
    if (journal != null && journal!.content.isNotEmpty) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt.weekday).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate.weekday).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  // {Journal? journal} = optional parameter
  void callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal innerJournal = journal ??
        Journal(
            id: const Uuid().v1(),
            content: "",
            createdAt: showedDate,
            updatedAt: showedDate);

    Map<String, dynamic> map = {};
    map["journal"] = innerJournal;
    map["is_editing"] = (journal != null);

    Navigator.pushNamed(context, 'add-journal', arguments: map).then((value) {
      refreshFunction();
      if (context.mounted) {
        if (value != null) {
          if (value == true) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Register successfully saved!!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error!! Register unsuccessful!")));
          }
        }
      }
    });
  }

  void removeJournal(BuildContext context) {
    JournalService service = JournalService();
    if (journal != null) {
      showConfirmationDialog(context,
              content:
                  "Do you really want to delete this journal created on ${WeekDay(journal!.createdAt.weekday)}",
              affirmativeOption: "Remove")
          .then((value) {
        if (value != null) {
          if (value) {
            service.delete(journal!.id).then((value) {
              if (value && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item successfully removed!")));

                refreshFunction();
              }
            });
          }
        }
      });
    }
  }
}
