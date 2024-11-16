import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_table_generation_app/models/course_model.dart';
import 'package:time_table_generation_app/models/staff_model.dart';
import 'package:time_table_generation_app/models/subject_model.dart';
import 'package:time_table_generation_app/models/period_model.dart';
import 'package:time_table_generation_app/models/time_table_model.dart';
import 'package:time_table_generation_app/services/firebase_service.dart';
import 'package:time_table_generation_app/utils/app_utils.dart';

class TimetableProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // State variables
  List<Course> _courses = [];
  List<Subject> _subjects = [];
  List<Staff> _staff = [];
  List<Period> _periods = [];
  List<TimetableEntry> _timetableEntries = [];
  bool _isLoading = false;

  // Getters
  List<Course> get courses => _courses;
  List<Subject> get subjects => _subjects;
  List<Staff> get staff => _staff;
  List<Period> get periods => _periods;
  List<TimetableEntry> get timetableEntries => _timetableEntries;
  bool get isLoading => _isLoading;

  // Load data
  void loadCourses() {
    _firebaseService.getCourses().listen((courseList) {
      _courses = courseList;
      notifyListeners();
    });
  }

  


 void loadSubjects() {
    _firebaseService.getCourses().listen((courseList) {
      
      print("Courses loaded: $courseList");

     
      Set<String> subjectIds = {};
      for (var course in courseList) {
        subjectIds.addAll(course.subjectIds);
      }

      // If no subjectIds are found, return early
      if (subjectIds.isEmpty) {
        print("No subjectIds found in courses.");
        return;
      }

 
      List<Subject> loadedSubjects = [];
      for (var course in courseList) {
        for (var subjectId in course.subjectIds) {
       
          loadedSubjects.add(Subject(id: subjectId, name: subjectId));
        }
      }

      // Update the subjects list with the fetched data
      _subjects = loadedSubjects;
      print("Subjects loaded: $_subjects");
      notifyListeners();
    });
  }



  void loadStaff() {
    _firebaseService.getStaff().listen((staffList) {
      _staff = staffList;
      notifyListeners();
    });
  }

  void loadPeriods() {
    _firebaseService.getPeriods().listen((periodList) {
      _periods = periodList;
      notifyListeners();
    });
  }
  

  // CRUD Operations
  Future<void> addCourse(Course course) async {
    await _firebaseService.addCourse(course);
  }

  Future<void> updateCourse(Course course) async {
    await _firebaseService.updateCourse(course);
  }

  Future<void> deleteCourse(String courseId) async {
    await _firebaseService.deleteCourse(courseId);
  }

  Future<void> addSubject(Subject subject) async {
    await _firebaseService.addSubject(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _firebaseService.updateSubject(subject);
  }

  Future<void> deleteSubject(String subjectId) async {
    await _firebaseService.deleteSubject(subjectId);
  }
Future<void> addStaff(Staff staff) async {
  try {
    // Add staff details without the `id` field
    final docRef = await FirebaseFirestore.instance.collection('staff').add({
      'name': staff.name,
      'subjectIds': staff.subjectIds,
    });

    
    await FirebaseFirestore.instance.collection('staff').doc(docRef.id).update({
      'id': docRef.id,
    });

   
    final newStaff = Staff(
      id: docRef.id, // Firestore-generated ID
      name: staff.name,
      subjectIds: staff.subjectIds,
    );

    _staff.add(newStaff);
    notifyListeners();
  } catch (e) {
    print('Error adding staff: $e');
    throw Exception('Failed to add new staff member.');
  }
}


  Future<void> updateStaff(Staff staff) async {
    try {
      // Ensure the staff document exists by using its ID
      final docRef = FirebaseFirestore.instance.collection('staff').doc(staff.id);

      // Update only if the document exists
      await docRef.update(staff.toMap());
      notifyListeners();
      print('Staff member updated successfully');
    } catch (e) {
      print('Error updating staff member: $e');
      throw Exception('Staff member not found.');
    }
  }

  Future<void> deleteStaff(String staffId,BuildContext context) async {
    try {
      // Attempt to delete the document from Firestore
      await FirebaseFirestore.instance.collection('staff').doc(staffId).delete();
      print('Staff member deleted successfully from Firestore.');

      // Remove the staff from the local list and notify listeners
      _staff.removeWhere((staff) => staff.id == staffId);
      notifyListeners();
    } catch (e) {
      print('Error deleting staff: $e');
      AppUtils.showInSnackBarNormal("Staff member not found.", context);
      throw Exception('Failed to delete staff member.');
    }
  }

  Future<void> addPeriod(Period period) async {
    await _firebaseService.addPeriod(period);
  }

  Future<void> updatePeriod(Period period) async {
    await _firebaseService.updatePeriod(period);
  }

  Future<void> deletePeriod(String periodId) async {
    await _firebaseService.deletePeriod(periodId);
  }

  // Timetable generation
  Future<void> generateTimetable(String courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _timetableEntries = await _firebaseService.generateTimetable(courseId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a specific timetable entry
  Future<void> updateTimetableEntry(TimetableEntry entry) async {
    await _firebaseService.updateTimetableEntry(entry);
  }
}
