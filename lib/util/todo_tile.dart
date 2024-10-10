// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_tasks/util/custom_painter.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          //child: Text('Make Tutorials'),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // checkbox with blurred circle
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (taskCompleted)
                      CustomPaint(
                        size: Size(24.0, 24.0),
                        painter: BlurredCirclePainter(
                          blurRadius:
                              10, // Adjust blur based on task completion
                        ),
                      ),
                    //Opacity(
                    //opacity: taskCompleted ? 1.0 : 0,
                    Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                      activeColor: Colors.black45,
                      checkColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              ),

              // task name
              //Text('Make Tutorials'),
              Text(
                taskName,
                style: TextStyle(
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
