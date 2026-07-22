import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which item IDs the user has marked as "found", persisted
/// to the device with shared_preferences so progress survives restarts.
class ProgressProvider extends ChangeNotifier {
  static const _storageKey = 'found_item_ids';

  final Set<String> _foundIds = {};
  bool _loaded = false;

  bool get loaded => _loaded;
  Set<String> get foundIds => _foundIds;

  bool isFound(String id) => _foundIds.contains(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    _foundIds
      ..clear()
      ..addAll(stored);
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (_foundIds.contains(id)) {
      _foundIds.remove(id);
    } else {
      _foundIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _foundIds.toList());
  }

  Future<void> reset() async {
    _foundIds.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Progress ratio (0.0 - 1.0) for a given total item count.
  double ratio(int total) => total == 0 ? 0 : _foundIds.length / total;
}
