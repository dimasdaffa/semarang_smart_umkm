
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:semarang_umkm_map/main.dart';
import 'package:semarang_umkm_map/presentation/providers/umkm_provider.dart';
import 'package:semarang_umkm_map/presentation/providers/sentra_provider.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UmkmProvider()),
          ChangeNotifierProvider(create: (_) => SentraProvider()),
        ],
        child: const SemarangSmartApp(),
      ),
    );

    // Verify that Dashboard Title is present
    expect(find.text('Dashboard Eksekutif'), findsOneWidget);
  });
}
