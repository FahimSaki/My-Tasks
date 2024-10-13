// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_tasks/util/custom_painter.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged; // Callback function when checkbox is toggled
  Function(BuildContext)?
      deleteFunction; // Callback function for deleting the task

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
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.5),
      child: Slidable(
        // Slidable widget for swipe actions
        endActionPane: ActionPane(
          motion: StretchMotion(), // Animation for the action pane
          children: [
            SlidableAction(
              onPressed: deleteFunction, // Callback to delete the task
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(
                  12), // Rounded corners for the action button
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 73, 150, 150),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Checkbox and task completion visual indicator
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blur effect when the task is completed
                    if (taskCompleted)
                      CustomPaint(
                        size: Size(24.0, 24.0),
                        painter: BlurredCirclePainter(
                          blurRadius: 20,
                        ),
                      ),
                    GestureDetector(
                      onTap: () => onChanged!(
                          !taskCompleted), // Toggle task completion on tap
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          color: taskCompleted
                              ? Colors.black45
                              : Colors.transparent,
                        ),
                        child: Icon(
                          taskCompleted
                              ? Icons.check
                              : null, // Show checkmark if completed
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              // Task name display
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
