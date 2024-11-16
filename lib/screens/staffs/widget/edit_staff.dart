import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';
import 'package:time_table_generation_app/models/staff_model.dart';

class EditStaffDialog extends StatefulWidget {
  final Staff staff;
  final TextEditingController staffNameController;
  final String? selectedSubject;

  const EditStaffDialog({
    super.key,
    required this.staff,
    required this.staffNameController,
    this.selectedSubject,
  });

  @override
  _EditStaffDialogState createState() => _EditStaffDialogState();
}

class _EditStaffDialogState extends State<EditStaffDialog> {
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    widget.staffNameController.text = widget.staff.name;
    selectedSubject = widget.selectedSubject ?? widget.staff.subjectIds.first;
  }

  @override
  Widget build(BuildContext context) {
    final timetableProvider = context.watch<TimetableProvider>();

    return AlertDialog(
      title: const Text('Edit Staff Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.staffNameController,
            decoration: const InputDecoration(hintText: 'Staff Name'),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: timetableProvider.subjects.map((subject) {
              bool isSelected = selectedSubject == subject.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSubject = subject.id;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey!,
                    ),
                  ),
                  child: Text(
                    subject.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Attempting to edit/delete staff with ID: ${widget.staff.id}');

            if (widget.staffNameController.text.isNotEmpty && selectedSubject != null) {
              timetableProvider.updateStaff(
                Staff(
                  id: widget.staff.id,
                  name: widget.staffNameController.text,
                  subjectIds: [selectedSubject!],
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
