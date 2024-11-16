import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_table_generation_app/models/course_model.dart';
import 'package:time_table_generation_app/models/staff_model.dart';
import 'package:time_table_generation_app/models/subject_model.dart';
import 'package:time_table_generation_app/models/period_model.dart';
import 'package:time_table_generation_app/models/time_table_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // **Course CRUD operations**
  Future<void> addCourse(Course course) async {
    await _firestore.collection('courses').doc(course.id).set(course.toMap());
  }

  Future<void> updateCourse(Course course) async {
    await _firestore.collection('courses').doc(course.id).update(course.toMap());
  }

  Future<void> deleteCourse(String courseId) async {
    await _firestore.collection('courses').doc(courseId).delete();
  }

  Stream<List<Course>> getCourses() {
    return _firestore.collection('courses').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Course.fromMap(doc.data()))
              .toList(),
        );
  }

  // **Subject CRUD operations**
  Future<void> addSubject(Subject subject) async {
    await _firestore.collection('subjects').doc(subject.id).set(subject.toMap());
  }

  Future<void> updateSubject(Subject subject) async {
    await _firestore.collection('subjects').doc(subject.id).update(subject.toMap());
  }

  Future<void> deleteSubject(String subjectId) async {
    await _firestore.collection('subjects').doc(subjectId).delete();
  }

  Stream<List<Subject>> getSubjects() {
    return _firestore.collection('subjects').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Subject.fromMap(doc.data()))
              .toList(),
        );
  }

  // **Staff CRUD operations**
Future<DocumentReference> addStaff(Staff staff) async {
  final docRef = await _firestore.collection('staff').add(staff.toMap());
  return docRef; 
}


  Future<void> updateStaff(Staff staff) async {
    await _firestore.collection('staff').doc(staff.id).update(staff.toMap());
  }

  Future<void> deleteStaff(String staffId) async {
    await _firestore.collection('staff').doc(staffId).delete();
  }

  Stream<List<Staff>> getStaff() {
    return _firestore.collection('staff').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Staff.fromMap(doc.data()))
              .toList(),
        );
  }

  // **Period CRUD operations**
  Future<void> addPeriod(Period period) async {
    await _firestore.collection('periods').doc(period.id).set(period.toMap());
  }

  Future<void> updatePeriod(Period period) async {
    await _firestore.collection('periods').doc(period.id).update(period.toMap());
  }

  Future<void> deletePeriod(String periodId) async {
    await _firestore.collection('periods').doc(periodId).delete();
  }

  Stream<List<Period>> getPeriods() {
    return _firestore.collection('periods').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Period.fromMap(doc.data()))
              .toList(),
        );
  }
Stream<List<Subject>> getSubjectsByIds(List<String> subjectIds) {
  return _firestore
      .collection('subjects')
      .where(FieldPath.documentId, whereIn: subjectIds)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Subject(
        id: doc.id,
        name: doc['name'],
      );
    }).toList();
  });
}




  // **Timetable Generation**
  Future<List<TimetableEntry>> generateTimetable(String courseId) async {
    final courseSnapshot = await _firestore.collection('courses').doc(courseId).get();
    final course = Course.fromMap(courseSnapshot.data()!);

    // Retrieve subjects associated with the course
    final subjectsSnapshot = await _firestore.collection('subjects')
        .where('courseId', isEqualTo: courseId)
        .get();
    final subjectList = subjectsSnapshot.docs.map((doc) => Subject.fromMap(doc.data())).toList();

    // Retrieve all staff members
    final staffSnapshot = await _firestore.collection('staff').get();
    final staffList = staffSnapshot.docs.map((doc) => Staff.fromMap(doc.data())).toList();

    List<TimetableEntry> timetable = [];

   

    return timetable;
  }


  Future<void> updateTimetableEntry(TimetableEntry entry) async {
    await _firestore.collection('timetable').doc(entry.id).update(entry.toMap());
  }
}
