class TimetableEntry {
  final String id;
  final String courseId;
  final String subjectId;
  final String staffId;
  final int dayIndex;
  final int periodIndex;

  TimetableEntry({
    required this.id,
    required this.courseId,
    required this.subjectId,
    required this.staffId,
    required this.dayIndex,
    required this.periodIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'subjectId': subjectId,
      'staffId': staffId,
      'dayIndex': dayIndex,
      'periodIndex': periodIndex,
    };
  }

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'],
      courseId: map['courseId'],
      subjectId: map['subjectId'],
      staffId: map['staffId'],
      dayIndex: map['dayIndex'],
      periodIndex: map['periodIndex'],
    );
  }
}