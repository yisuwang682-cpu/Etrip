import 'package:etrip/features/places/data/models/place_model.dart';

class ItineraryResponse {
  final int noOfDays;
  final Map<int, List<PlaceModel>> plan;
  final String description;

  ItineraryResponse({
    required this.noOfDays,
    required this.plan,
    required this.description,
  });

  factory ItineraryResponse.fromJson(Map<String, dynamic> json) {
    final planJson = json['plan'] as Map<String, dynamic>;
    final plan = <int, List<PlaceModel>>{};
    planJson.forEach((day, placesJson) {
      plan[int.parse(day)] = List<PlaceModel>.from(
        (placesJson as List).map((e) => PlaceModel.fromJson(e)),
      );
    });
    return ItineraryResponse(
      noOfDays: json['no_of_days'],
      plan: plan,
      description: json['description'],
    );
  }
}