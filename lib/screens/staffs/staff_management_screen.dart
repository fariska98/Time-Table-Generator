import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';
import 'package:time_table_generation_app/models/staff_model.dart';
import 'package:time_table_generation_app/screens/staffs/widget/edit_staff.dart';
import 'package:time_table_generation_app/utils/app_utils.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  _StaffManagementScreenState createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  TextEditingController _staffNameController = TextEditingController();
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    // Load all subjects from the courses collection when the screen initializes
    final timetableProvider =
        Provider.of<TimetableProvider>(context, listen: false);
    timetableProvider.loadSubjects();
    timetableProvider.loadStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
        'Staff Management',
        style: TextStyleClass.manrope600TextStyle(20, ColorClass.black),
      ))),
      body: Consumer<TimetableProvider>(builder: (context, provider, child) {
        // Ensure subjects are available
        if (provider.subjects.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Staff list display
        return ListView.builder(
          itemCount: provider.staff.length,
          itemBuilder: (context, index) {
            final staff = provider.staff[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                    color: const Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staff.name,
                            style: TextStyleClass.manrope600TextStyle(
                                16, ColorClass.black),
                          ),
                          SizedBox(
                            width: 220,
                            child: Text(
                              staff.subjectIds.join(', '),
                              style: TextStyleClass.manrope600TextStyle(
                                  12, ColorClass.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: ColorClass.primaryColor,
                            ),
                            onPressed: () =>
                                _editStaff(context, staff, provider),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: ColorClass.primaryColor),
                            onPressed: () =>
                                provider.deleteStaff(staff.id!, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorClass.primaryColor,
        label: Text(
          "Add Staff",
          style: TextStyleClass.manrope600TextStyle(20, ColorClass.white),
        ),
        onPressed: () => _addNewStaff(context),
      ),
    );
  }

  void _addNewStaff(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add New Staff',
            style: TextStyleClass.manrope600TextStyle(18, ColorClass.black),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 205, 204, 204))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: _staffNameController,
                            decoration: InputDecoration(
                                hintText: 'Staff Name',
                                hintStyle: TextStyleClass.manrope400TextStyle(
                                    12, ColorClass.black),
                                border: InputBorder.none),
                          ),
                        ),
                      ),

                      // Display available subjects in cards
                      Wrap(
                        spacing: 8.0, // Horizontal space between cards
                        runSpacing: 8.0, // Vertical space between rows of cards
                        children: context
                            .watch<TimetableProvider>()
                            .subjects
                            .map((subject) {
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
                                color:
                                    isSelected ? Colors.blue : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected ? Colors.blue : Colors.grey!,
                                ),
                              ),
                              child: Text(
                                subject.name,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_staffNameController.text.isNotEmpty &&
                    selectedSubject != null) {
                  // Add the new staff with the selected subject
                  Provider.of<TimetableProvider>(context, listen: false)
                      .addStaff(
                    Staff(
                      id:  "", // No need to pass an ID; Firestore will generate it
                      name: _staffNameController.text,
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
      },
    );
  }

  void _editStaff(
      BuildContext context, Staff staff, TimetableProvider provider) async {
    final docRef = FirebaseFirestore.instance.collection('staff').doc(staff.id);

    // Check if the document exists
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      _staffNameController.text = staff.name;
      selectedSubject =
          staff.subjectIds.isNotEmpty ? staff.subjectIds[0] : null;

      showDialog(
        context: context,
        builder: (context) {
          return EditStaffDialog(
            staff: staff,
            staffNameController: _staffNameController,
            selectedSubject: selectedSubject,
          );
        },
      );
    } else {
      AppUtils.showInSnackBarNormal("Staff member not found.", context);
    }
  }
}
