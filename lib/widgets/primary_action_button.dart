import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final String _text;
  final Function _action;

  const PrimaryActionButton({
    required String text,
    required Function action,
  })  : _text = text,
        _action = action;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => _action(),
    );
  }
}
