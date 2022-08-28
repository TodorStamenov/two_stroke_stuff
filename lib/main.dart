import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/pages/calculator.dart';

void main() {
  Widget unfocusOnTap(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  runApp(
    unfocusOnTap(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const Calculator(),
      ),
    ),
  );
}
