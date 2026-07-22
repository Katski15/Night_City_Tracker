import 'package:flutter/foundation.dart';
import '../data/locations_repository.dart';
import '../models/location_item.dart';

class LocationsProvider extends ChangeNotifier {
  final LocationsRepository _repository;

  LocationsProvider({LocationsRepository? repository})
      : _repository = repository ?? LocationsRepository();

  List<LocationItem> _all = [];
  bool _loading = true;
  String? _error;

  String _query = '';
  String? _categoryFilter; // null = all categories
  String? _districtFilter; // null = all districts

  bool get loading => _loading;
  String? get error => _error;
  List<LocationItem> get all => _all;

  List<String> get categories =>
      _all.map((e) => e.category).toSet().toList()..sort();

  List<String> get districts =>
      _all.map((e) => e.district).toSet().toList()..sort();

  String get query => _query;
  String? get categoryFilter => _categoryFilter;
  String? get districtFilter => _districtFilter;

  List<LocationItem> get filtered {
    return _all.where((item) {
      final matchesQuery = _query.isEmpty ||
          item.name.toLowerCase().contains(_query.toLowerCase()) ||
          item.landmark.toLowerCase().contains(_query.toLowerCase()) ||
          item.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()));
      final matchesCategory =
          _categoryFilter == null || item.category == _categoryFilter;
      final matchesDistrict =
          _districtFilter == null || item.district == _districtFilter;
      return matchesQuery && matchesCategory && matchesDistrict;
    }).toList();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _repository.loadAll();
    } catch (e) {
      _error = 'Could not load location data: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategoryFilter(String? value) {
    _categoryFilter = value;
    notifyListeners();
  }

  void setDistrictFilter(String? value) {
    _districtFilter = value;
    notifyListeners();
  }

  void clearFilters() {
    _query = '';
    _categoryFilter = null;
    _districtFilter = null;
    notifyListeners();
  }
}
