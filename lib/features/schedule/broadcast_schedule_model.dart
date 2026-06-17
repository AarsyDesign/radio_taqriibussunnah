import '../../core/remote_radio_config.dart';

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

  factory BroadcastScheduleModel.fromRemote(RemoteScheduleItem item) {
    return BroadcastScheduleModel(
      title: item.title,
      time: item.timeText,
      description: item.description,
      category: item.category.isEmpty ? null : item.category,
      isLiveSlot: item.isLiveSlot,
    );
  }
}
