import 'package:flutter/material.dart';

Future<dynamic> showExceptionDialog(
  BuildContext context, {
  required String content,
  String title = "A problem occurred.",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(children: [
          const Icon(
            Icons.warning,
            color: Colors.brown,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.brown,
            ),
          ),
        ]),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    },
  );
}
