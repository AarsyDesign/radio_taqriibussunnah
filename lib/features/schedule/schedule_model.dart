class ScheduleModel {
  const ScheduleModel({
    required this.title,
    required this.time,
    required this.description,
    this.day,
    this.isLive = false,
  });

  final String title;
  final String time;
  final String description;
  final String? day;
  final bool isLive;
}
