import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.prefs = await SharedPreferences.getInstance();

  Widget unfocusOnTap(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  runApp(
    unfocusOnTap(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    ),
  );
}
