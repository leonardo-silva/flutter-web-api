import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) {
  final currentContext = context;
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    if (currentContext.mounted) {
      Navigator.pushReplacementNamed(currentContext, 'login');
    }
  });
}
