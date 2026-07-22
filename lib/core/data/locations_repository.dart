import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/location_item.dart';

/// Loads location/item data from a bundled JSON asset.
///
/// To add your own data, edit `assets/data/locations.json` and make
/// sure it's declared under `flutter: assets:` in pubspec.yaml.
class LocationsRepository {
  static const _assetPath = 'assets/data/locations.json';

  Future<List<LocationItem>> loadAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((e) => LocationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
