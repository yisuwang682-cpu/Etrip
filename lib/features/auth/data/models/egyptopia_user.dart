class EgyptopiaUser {
  final String id;
  final String email;
  final String name;
  final String? country;
  final String? dateOfBirth;
  final String? gender;
  final String? profileImg;

  EgyptopiaUser({
    required this.id,
    required this.email,
    required this.name,
    this.country,
    this.dateOfBirth,
    this.gender,
    this.profileImg,
  });

  EgyptopiaUser copyWith({
    String? id,
    String? email,
    String? name,
    String? country,
    String? dateOfBirth,
    String? gender,
    String? profileImg,
  }) {
    return EgyptopiaUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImg: profileImg ?? this.profileImg,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'country': country,
        'date_of_birth': dateOfBirth,
        'gender': gender,
      };

  factory EgyptopiaUser.fromMap(Map<String, dynamic> map) => EgyptopiaUser(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        country: map['country'],
        dateOfBirth: map['date_of_birth'],
        gender: map['gender'],
        profileImg: map['profile_img'],
      );
}
