import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Itinerary/data/itinerary_api_service.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_request.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_response.dart';
import 'package:egyptopia/features/places/presentation/widgets/place_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ItineraryResultView extends StatefulWidget {
  final Map<String, dynamic> args;
    final VoidCallback? onStartNew; 
  const ItineraryResultView({super.key, required this.args, this.onStartNew});

  @override
  State<ItineraryResultView> createState() => _ItineraryResultViewState();
}

class _ItineraryResultViewState extends State<ItineraryResultView> {
  late Future<ItineraryResponse> futureItinerary;

  @override
  void initState() {
    super.initState();
    final req = ItineraryRequest(
      noOfDays: widget.args['noOfDays'],
      categoryWeights: {for (var e in widget.args['categoryWeights']) e: 1},
      tourismTypeWeights: {
        for (var e in widget.args['tourismTypeWeights']) e: 1
      },
      budget: widget.args['budget'],
      popularity: widget.args['popularity'],
      withWho: widget.args['withWho'],
    );
    final user = FirebaseAuth.instance.currentUser;

    futureItinerary = ItineraryService().getItinerary(
      userId: user!.uid,
      request: req,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      imageColor: Colors.black87,
      backgroundColor: const [Color.fromARGB(255, 237, 239, 241), Colors.white],
      child: FutureBuilder<ItineraryResponse>(
        future: futureItinerary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final resp = snapshot.data!;
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const VerticalSpace(5),
                  if (resp.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        resp.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ...resp.plan.entries.expand((entry) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Day ${entry.key}",
                            style:  GoogleFonts.montserrat(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2544)),
                          ),
                        ),
                        ...entry.value.map((place) => PlaceCard(
                              place: place,
                              onTap: () {
                                context.push(AppRouter.kPlaceDetails,
                                    extra: place);
                              },
                            )),
                        const Divider(),
                      ]),
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF1F2544),
                  foregroundColor: Colors.white,
                  label: const Text("New",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  icon: const Icon(Icons.restart_alt),
                  onPressed: () {
                if (widget.onStartNew != null) widget.onStartNew!();
                  },
                  elevation: 4,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
