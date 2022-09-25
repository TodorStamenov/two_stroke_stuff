import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final IconData _icon;
  final Function _action;

  const IconActionButton({
    required IconData icon,
    required Function action,
  })  : _icon = icon,
        _action = action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
      ),
      child: Icon(
        _icon,
        color: Colors.white,
      ),
      onPressed: () => _action(),
    );
  }
}
