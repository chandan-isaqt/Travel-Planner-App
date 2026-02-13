class Place {
  final String name;
  final String address;
  final String category;
  final double lat;
  final double lon;
  final String country;
  final String city;

  Place({
    required this.name,
    required this.address,
    required this.category,
    required this.lat,
    required this.lon,
    required this.country,
    required this.city,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] ?? {};
    final geometry = json['geometry'] ?? {};

    final coordinates = geometry['coordinates'] as List? ?? [];

    final categories = properties['categories'] as List? ?? [];

    return Place(
      name: properties['name'] ?? "No name",
      address: properties['formatted'] ?? "No address available",
      category: categories.isNotEmpty ? categories.first.toString() : "unknown",
      lat: coordinates.length > 1 ? (coordinates[1] as num).toDouble() : 0.0,
      lon: coordinates.isNotEmpty ? (coordinates[0] as num).toDouble() : 0.0,
      country: properties['country'] ?? "Unknown country",
      city: properties['city'] ?? "Unknown city",
    );
  }
}
