class Course {
  final String? id;
String name;
   List<String> subjectIds;

  Course({
    required this.id,
    required this.name,
    required this.subjectIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subjectIds': subjectIds,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      subjectIds: List<String>.from(map['subjectIds']),
    );
  }
}