class MeditationHistory {
  DateTime dateTime;
  int duration;
  int repeatTimes;

  MeditationHistory({
    required this.dateTime,
    required this.duration,
    required this.repeatTimes,
  });

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime.millisecondsSinceEpoch,
        "duration": duration,
        "repeatTimes": repeatTimes,
      };

  MeditationHistory.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
        duration = json['duration'],
        repeatTimes = json['repeatTimes'];

  @override
  String toString() {
    return "\n{\n    dateTime: " +
        dateTime.toIso8601String() +
        ",\n    " +
        "duration: " +
        duration.toString() +
        ",\n    " +
        "repeatTimes: " +
        repeatTimes.toString() +
        "\n},\n";
  }
}
