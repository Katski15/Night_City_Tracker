/// Represents a single trackable item/location in the game.
///
/// Categories are free-form strings so you can add new ones without
/// touching the model (e.g. "Cyberware", "Vehicle", "Tarot Card",
/// "Shard", "Gig", "Iconic Weapon", "Wanted Job", "NCPD Scanner").
class LocationItem {
  final String id;
  final String name;
  final String category;
  final String district; // e.g. "Watson", "City Center", "Badlands"
  final String landmark; // nearest named landmark / street / building
  final String description;
  final String? requirements; // e.g. "Requires Body 7", "Street Cred 20"
  final List<String> tags; // free-form, used for search/filter

  const LocationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.district,
    required this.landmark,
    required this.description,
    this.requirements,
    this.tags = const [],
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      district: json['district'] as String,
      landmark: json['landmark'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'district': district,
        'landmark': landmark,
        'description': description,
        'requirements': requirements,
        'tags': tags,
      };
}
