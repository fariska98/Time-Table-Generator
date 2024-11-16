class Period {
  final String id;
  final int dayIndex; // 0-4 for Monday-Friday
  final int periodIndex; // 0-3 for 4 periods
  final String startTime;
  final String endTime;

  Period({
    required this.id,
    required this.dayIndex,
    required this.periodIndex,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayIndex': dayIndex,
      'periodIndex': periodIndex,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Period.fromMap(Map<String, dynamic> map) {
    return Period(
      id: map['id'],
      dayIndex: map['dayIndex'],
      periodIndex: map['periodIndex'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}