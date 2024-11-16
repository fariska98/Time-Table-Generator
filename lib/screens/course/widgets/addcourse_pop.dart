// add_course_dialog.dart

import 'package:flutter/material.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';

class AddCourseDialog extends StatefulWidget {
  final TextEditingController courseNameController;
  final List<TextEditingController> subjectControllers;
  final VoidCallback onSave;

  const AddCourseDialog({
    Key? key,
    required this.courseNameController,
    required this.subjectControllers,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add New Course',
        style: TextStyleClass.manrope600TextStyle(20, ColorClass.black),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color.fromARGB(255, 205, 204, 204))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: widget.courseNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Course Name',
                            hintStyle: TextStyleClass.manrope400TextStyle(
                                12, ColorClass.black)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: widget.subjectControllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                               border: Border.all(color: const Color.fromARGB(255, 205, 204, 204)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                          child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                  hintText: 'Subject Name',
                                  hintStyle: TextStyleClass.manrope400TextStyle(
                                      12, ColorClass.black)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorClass.primaryColor
                    ),
                    onPressed: () {
                      setState(() {
                        widget.subjectControllers.add(TextEditingController());
                      });
                    },
                    child:   Text('Add Subject',style: TextStyleClass.manrope500TextStyle(16, ColorClass.white),),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child:   Text('Cancel',
          style: TextStyleClass.manrope400TextStyle(12, ColorClass.black),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorClass.primaryColor
          ),
          onPressed: () {
            widget.onSave();
            Navigator.of(context).pop();
          },
          child:   Text('Save',
          style: TextStyleClass.manrope400TextStyle(12, ColorClass.white),),
        ),
      ],
    );
  }
}
