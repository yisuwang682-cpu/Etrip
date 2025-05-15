import 'package:egyptopia/features/places/data/models/place_model.dart';
import 'package:egyptopia/features/places/data/places_api_service.dart';
import 'package:flutter/material.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_section.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:egyptopia/core/utils/app_router.dart';

final List<Map<String, String>> sections = [
  {
    'cacheKey': 'cultural',
    'title': "  Cultural & Historical",
    'apiTitle': "Cultural and Historical Attractions",
    'emptyText': 'No Cultural and Historical Attractions found',
    'failText': 'Failed to load Cultural and Historical Attractions',
  },
  {
    'cacheKey': 'religious',
    'title': "  Religious & Spiritual",
    'apiTitle': "Religious and Spiritual Attractions",
    'emptyText': 'No Religious and Spiritual Attractions found',
    'failText': 'Failed to load Religious and Spiritual Attractions',
  },
  {
    'cacheKey': 'natural',
    'title': "  Natural Attractions",
    'apiTitle': 'Natural Attractions',
    'emptyText': 'No Natural Attractions found',
    'failText': 'Failed to load Natural Attractions',
  },
  {
    'cacheKey': 'entertainment',
    'title': "  Entertainment & Modern",
    'apiTitle': 'Entertainment and Modern Attractions',
    'emptyText': 'No Entertainment and Modern Attractions found',
    'failText': 'Failed to load Entertainment and Modern Attractions',
  },
  {
    'cacheKey': 'medical',
    'title': "  Medical Attractions",
    'apiTitle': 'Medical Attractions',
    'emptyText': 'No Medical Attractions found',
    'failText': 'Failed to load Medical Attractions',
  },
];

class BuildHomeSection extends StatelessWidget {
  final String cacheKey;
  final String title;
  final String apiTitle;
  final String emptyText;
  final String failText;
  final Future<List<PlaceModel>> Function(
      {required String cacheKey,
      required Future<List<PlaceModel>> Function() fetcher}) getOrFetch;
  final PlacesApiService apiService;

  const BuildHomeSection({
    super.key,
    required this.cacheKey,
    required this.title,
    required this.apiTitle,
    required this.emptyText,
    required this.failText,
    required this.getOrFetch,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceModel>>(
      future: getOrFetch(
        cacheKey: cacheKey,
        fetcher: () => apiService.fetchPlacesByTourismType(apiTitle),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(failText));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(emptyText));
        }
        return FeatureSection(
          title: title,
          onSeeAll: () {
            context.push(AppRouter.kPlaces, extra: {
              'tourism_type': apiTitle,
            });
          },
          slider: Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.defaultSize!),
            child: FeatureSlider(
              places: snapshot.data!,
              width: SizeConfig.screenWidth! * 0.4,
              onTap: (place) {
                if (place != null) {
                  context.push(AppRouter.kPlaceDetails, extra: place);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
