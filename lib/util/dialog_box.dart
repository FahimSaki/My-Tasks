// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_tasks/util/dialog_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;

  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.cyan[100],
      content: Container(
        height: 120,
        child: Column(children: [
          // get user inputs
          TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add a new task",
              hintStyle: TextStyle(color: Colors.black),
              fillColor: Colors.white,
              filled: true,
            ),
          ),

          // buttons -> save + cancel
          Row(
            children: [
              // save button
              DialogButton(
                text: "Save",
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onSave();
                  } else {
                    // Show an error message if the input is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task cannot be empty'),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(width: 10),

              //cancel button
              DialogButton(text: "Cancel", onPressed: onCancel),
            ],
          )
        ]),
      ),
    );
  }
}
