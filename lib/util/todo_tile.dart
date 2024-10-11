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
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 73, 150, 150),
            //color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Checkbox with blurred circle
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
                              20, // Adjust blur based on task completion
                        ),
                      ),
                    GestureDetector(
                      onTap: () => onChanged!(!taskCompleted),
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
                          taskCompleted ? Icons.check : null,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
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
                  softWrap: true, // softwrap and overflow to fix text overflow
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
