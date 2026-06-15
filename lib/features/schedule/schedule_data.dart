import 'schedule_model.dart';

class ScheduleData {
  const ScheduleData._();

  static const List<ScheduleModel> scheduleItems = [
    ScheduleModel(
      title: 'Kajian Rutin Pagi',
      day: 'Setiap hari',
      time: 'Ba’da Subuh',
      description: 'Murottal dan kajian pilihan',
      isLive: false,
    ),
    ScheduleModel(
      title: 'Kajian Sore',
      day: 'Menyesuaikan',
      time: 'Ba’da Ashar',
      description: 'Siaran kajian langsung jika tersedia',
      isLive: true,
    ),
    ScheduleModel(
      title: 'Kajian Malam',
      day: 'Menyesuaikan',
      time: 'Ba’da Isya',
      description: 'Kajian dan faedah ilmiah',
      isLive: true,
    ),
  ];
}
