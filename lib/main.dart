import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/widgets/home.dart';

void main() {
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
