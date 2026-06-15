import 'package:flutter_test/flutter_test.dart';
import 'package:radio_taqriibussunnah/app.dart';

void main() {
  testWidgets('shows initial radio UI', (WidgetTester tester) async {
    await tester.pumpWidget(const RadioTaqriibussunnahApp());

    expect(find.text('Radio Taqriibussunnah'), findsWidgets);
    expect(find.text('Kajian Islam & Murottal'), findsWidgets);
    expect(find.text('Sedang diputar'), findsOneWidget);
    expect(find.text('Siap diputar'), findsOneWidget);
    expect(find.text('Tekan untuk memulai siaran'), findsOneWidget);
    expect(find.text('Telegram'), findsOneWidget);
    expect(find.text('Website'), findsOneWidget);
    expect(find.text('Bagikan'), findsOneWidget);
    expect(find.text('WhatsApp'), findsNothing);
    expect(find.text('Sleep Timer'), findsNothing);
    expect(find.text('Timer belum aktif'), findsNothing);
    expect(find.text('15 menit'), findsNothing);
    expect(find.text('30 menit'), findsNothing);
    expect(find.text('60 menit'), findsNothing);
    expect(find.text('Off'), findsNothing);

    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();

    expect(find.text('Jadwal Kajian'), findsOneWidget);
    expect(find.text('Kajian Rutin Pagi'), findsOneWidget);
    expect(find.text('Jadwal dapat berubah sewaktu-waktu.'), findsOneWidget);
  });
}
