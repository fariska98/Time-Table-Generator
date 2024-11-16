// edit_course_dialog.dart

import 'package:flutter/material.dart';
import 'package:time_table_generation_app/models/course_model.dart';

class EditCourseDialog extends StatefulWidget {
  final Course course;
  final TextEditingController courseNameController;
  final List<TextEditingController> subjectControllers;
  final VoidCallback onUpdate;

  const EditCourseDialog({
    Key? key,
    required this.course,
    required this.courseNameController,
    required this.subjectControllers,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditCourseDialogState createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Course'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.courseNameController,
                decoration: const InputDecoration(
                  hintText: 'Course Name',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Subjects:'),
              Column(
                children: widget.subjectControllers.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Subject Name',
                      ),
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.subjectControllers.add(TextEditingController());
                  });
                },
                child: const Text('Add Subject'),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpdate();
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
