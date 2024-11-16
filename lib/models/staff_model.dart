class Staff {
   final String? id;
  final String name;
  final List<String> subjectIds;

  Staff({
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

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id']??"",
      name: map['name'],
      subjectIds: List<String>.from(map['subjectIds']),
    );
  }
}