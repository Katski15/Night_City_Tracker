import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/providers/locations_provider.dart';
import 'core/providers/progress_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationsProvider()..load()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()..load()),
      ],
      child: const NightCityTrackerApp(),
    ),
  );
}
