class EgyptopiaUser {
  final String id;
  final String email;
  final String name;
  final String? country;
  final String? dateOfBirth;
  final String? gender;
  final String? profileImg;
  final List<String> preferredCategories;
  final List<String> preferredTourismTypes;
  final List<String> preferredCities;

  EgyptopiaUser({
    required this.id,
    required this.email,
    required this.name,
    this.country,
    this.dateOfBirth,
    this.gender,
    this.profileImg,
    this.preferredCategories = const [],
    this.preferredTourismTypes = const [],
    this.preferredCities = const [],
  });

  EgyptopiaUser copyWith({
    String? id,
    String? email,
    String? name,
    String? country,
    String? dateOfBirth,
    String? gender,
    String? profileImg,
    List<String>? preferredCategories,
    List<String>? preferredTourismTypes,
    List<String>? preferredCities,
  }) {
    return EgyptopiaUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImg: profileImg ?? this.profileImg,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      preferredTourismTypes:
          preferredTourismTypes ?? this.preferredTourismTypes,
      preferredCities: preferredCities ?? this.preferredCities,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'country': country,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'preferred_categories': preferredCategories,
        'preferred_tourism_types': preferredTourismTypes,
        'preferred_cities': preferredCities,
      };

  factory EgyptopiaUser.fromMap(Map<String, dynamic> map) => EgyptopiaUser(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        country: map['country'],
        dateOfBirth: map['date_of_birth'],
        gender: map['gender'],
        profileImg: map['profile_img'],
        preferredCategories:
            List<String>.from(map['preferred_categories'] ?? []),
        preferredTourismTypes:
            List<String>.from(map['preferred_tourism_types'] ?? []),
        preferredCities: List<String>.from(map['preferred_cities'] ?? []),
      );
}
