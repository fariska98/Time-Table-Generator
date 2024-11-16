import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';
import 'package:time_table_generation_app/models/course_model.dart';
import 'package:time_table_generation_app/models/staff_model.dart';
import 'package:time_table_generation_app/models/subject_model.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';

class TimetableGenerationScreen extends StatefulWidget {
  const TimetableGenerationScreen({super.key});

  @override
  _TimetableGenerationScreenState createState() => _TimetableGenerationScreenState();
}

class _TimetableGenerationScreenState extends State<TimetableGenerationScreen> {
  List<List<List<Tuple<Subject, Staff>>>> courseTimetables = [];
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _generateTimetables();
  }

  void _generateTimetables() {
  final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);

  // Load data
  timetableProvider.loadSubjects();
  timetableProvider.loadStaff();
  timetableProvider.loadCourses();

  final staff = timetableProvider.staff;
  final random = Random();

  if (timetableProvider.courses.isNotEmpty && staff.isNotEmpty) {
    // Generate a timetable for each course
    courseTimetables = timetableProvider.courses.map((course) {
      // Filter subjects specifically for this course
      final courseSubjects = timetableProvider.subjects.where((s) => course.subjectIds.contains(s.id)).toList();

      // Create an empty 5-day timetable with 4 periods each day for this course
      List<List<Tuple<Subject, Staff>>> timetable = List.generate(
        5, // 5 days
        (dayIndex) => List.generate(
          4, // 4 periods per day
          (periodIndex) => Tuple<Subject, Staff>(null, null),
        ),
      );

      // Assign subjects and qualified staff uniquely for each period
      for (var day = 0; day < 5; day++) {
        List<Staff> usedStaffForDay = []; // Track used staff for each day to avoid conflicts

        for (var period = 0; period < 4; period++) {
          final subjectIndex = (day * 4 + period) % courseSubjects.length;
          final subject = courseSubjects[subjectIndex];

          // Filter staff who are qualified to teach the current subject
          final qualifiedStaff = staff.where((s) => s.subjectIds.contains(subject.id)).toList();

          // Shuffle and pick a qualified staff member not yet used for the day
          final availableStaff = qualifiedStaff.where((s) => !usedStaffForDay.contains(s)).toList();
          if (availableStaff.isNotEmpty) {
            final selectedStaff = availableStaff[random.nextInt(availableStaff.length)];
            usedStaffForDay.add(selectedStaff); // Mark staff as used for the day
            timetable[day][period] = Tuple(subject, selectedStaff);
          } else {
            // If no available staff found, mark this period as unassigned (handle gracefully)
            timetable[day][period] = Tuple(subject, null);
          }
        }
      }
      return timetable;
    }).toList();

    setState(() {});
  } else {
    setState(() {
      hasError = true;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Generation'),
      ),
      body: courseTimetables.isNotEmpty
          ? ListView.builder(
              itemCount: timetableProvider.courses.length,
              itemBuilder: (context, courseIndex) {
                final courseTimetable = courseTimetables[courseIndex];
                final courseName = timetableProvider.courses[courseIndex].name;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course: $courseName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          dataRowHeight: 60,
                          columns: const [
                            DataColumn(label: Text('Day')),
                            DataColumn(label: Text('Period 1')),
                            DataColumn(label: Text('Period 2')),
                            DataColumn(label: Text('Period 3')),
                            DataColumn(label: Text('Period 4')),
                          ],
                          rows: List.generate(
                            5,
                            (dayIndex) => DataRow(
                              cells: [
                                DataCell(Text('${dayIndex + 1}')),
                                ...List.generate(
                                  4,
                                  (periodIndex) {
                                    final tuple = courseTimetable[dayIndex][periodIndex];
                                    final subject = tuple.item1;
                                    final staff = tuple.item2;
                                    return DataCell(
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (subject != null) Text(subject.name),
                                            if (staff != null) Text(staff.name),
                                            if (subject == null || staff == null)
                                              const Text("No subject or staff"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: hasError
                  ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                        'No courses or staff members found. Cannot generate timetable.',
                        style: TextStyleClass.manrope500TextStyle(12, ColorClass.black),
                      ),
                  )
                  : const CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateTimetables,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Tuple<T1, T2> {
  final T1? item1;
  final T2? item2;

  Tuple(this.item1, this.item2);
}