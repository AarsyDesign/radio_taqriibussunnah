import 'broadcast_schedule_model.dart';

const List<BroadcastScheduleModel> broadcastScheduleItems = [
  BroadcastScheduleModel(
    title: "Murottal Al-Qur'an",
    time: '00.00-04.30',
    description: "Lantunan Al-Qur'an pilihan",
    category: 'Murottal',
  ),
  BroadcastScheduleModel(
    title: 'Kajian Pagi',
    time: '04.30-06.00',
    description: 'Kajian dan faedah pembuka hari',
    category: 'Kajian',
  ),
  BroadcastScheduleModel(
    title: 'Kajian Aqidah',
    time: '08.00-10.00',
    description: 'Pembahasan aqidah dan manhaj',
    category: 'Kajian',
  ),
  BroadcastScheduleModel(
    title: 'Kajian Fiqih',
    time: '13.00-15.00',
    description: 'Pembahasan fikih ibadah dan muamalah',
    category: 'Kajian',
  ),
  BroadcastScheduleModel(
    title: 'Murottal Sore',
    time: '15.30-17.00',
    description: 'Murottal dan bacaan pilihan',
    category: 'Murottal',
  ),
  BroadcastScheduleModel(
    title: 'Kajian Malam',
    time: '19.30-21.00',
    description: 'Kajian ilmiah dan faedah pilihan',
    category: 'Kajian',
  ),
  BroadcastScheduleModel(
    title: 'Siaran Bebas / AutoDJ',
    time: 'Menyesuaikan',
    description: 'Playlist pilihan Radio Taqriibussunnah',
    category: 'AutoDJ',
  ),
];
