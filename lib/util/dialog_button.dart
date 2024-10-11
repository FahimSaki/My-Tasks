// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  DialogButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      //color: Theme.of(context).primaryColor,
      color: Colors.cyan[400],
      child: Text(text),
    );
  }
}
