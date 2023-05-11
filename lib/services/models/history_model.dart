class History {
  DateTime dateTime;
  int fastingHours;

  History({
    required this.dateTime,
    required this.fastingHours,
  });

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime.millisecondsSinceEpoch,
        "fastingHours": fastingHours,
      };

  History.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
        fastingHours = json['fastingHours'];

  @override
  String toString() {
    return "\n{\n    dateTime: " +
        dateTime.toIso8601String() +
        ",\n    " +
        "fastingHours: " +
        fastingHours.toString() +
        "\n},\n";
  }
}
