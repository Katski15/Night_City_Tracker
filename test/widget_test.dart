// Basic smoke test for Night City Tracker.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/app/app.dart';
import 'package:flutter_application_1/core/providers/locations_provider.dart';
import 'package:flutter_application_1/core/providers/progress_provider.dart';

void main() {
  testWidgets('App boots and shows bottom navigation', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationsProvider()..load()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()..load()),
        ],
        child: const NightCityTrackerApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('SEARCH'), findsOneWidget);
    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);
  });
}
