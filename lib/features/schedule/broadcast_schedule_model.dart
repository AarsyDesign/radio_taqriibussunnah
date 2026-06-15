class BroadcastScheduleModel {
  const BroadcastScheduleModel({
    required this.title,
    required this.time,
    required this.description,
    this.category,
    this.isLiveSlot = false,
  });

  final String title;
  final String time;
  final String description;
  final String? category;
  final bool isLiveSlot;
}
