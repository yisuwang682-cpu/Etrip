// ignore_for_file: use_build_context_synchronously
import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/auth/data/egyptopia_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferenceOne extends StatefulWidget {
  const PreferenceOne({super.key});

  @override
  State<PreferenceOne> createState() => _PreferenceOneState();
}

class _PreferenceOneState extends State<PreferenceOne> {
  final List<String> categories = [
    "Monastery",
    "Temple",
    "Historical Site",
    "Mosque",
    "Water Park",
    "Church",
    "Museum",
    "Cultural Center",
    "Island",
    "Mountain",
    "Natural Reserve",
    "Tomb",
    "Beach",
    "Shopping",
    "Fortress",
    "Palace",
    "Library",
    "Tower",
    "Hot Spring",
    "Garden",
    "Theme Park",
    "Rehabilitation & Wellness Center",
    "Aquarium",
    "Healing Oases & Sand Therapy",
    "Theater",
    "Synagogue",
    "Zoo"
  ];

  List<int> selectedIndexes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await EgyptopiaApiService().getUserPreferences(userId);
      if (prefs != null) {
        final savedCategories = List<String>.from(prefs['category'] ?? []);
        setState(() {
          selectedIndexes = categories
              .asMap()
              .entries
              .where((entry) => savedCategories.contains(entry.value))
              .map((entry) => entry.key)
              .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load preferences: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      gradientStops: const [0.1, 0.9],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 30),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How do you want to \nspend your time?',
                    style: TextStyle(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(1.5),
                  Image.asset(
                    AssetsData.spacer,
                    width: double.infinity,
                  ),
                  const VerticalSpace(1.5),
                  Text(
                    'Choose as many as you\'d like',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 19,
                    ),
                  ),
                  const VerticalSpace(1.5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(categories.length, (index) {
                          bool isSelected = selectedIndexes.contains(index);
                          return TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFF1F2544),
                              side: BorderSide(
                                color: isSelected ? Colors.black : Colors.white,
                                width: 2.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedIndexes.remove(index);
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            },
                            child: Text(
                              categories[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const VerticalSpace(1),
                  CustomGeneralButton(
                    text: "Next",
                    onTap: () {
                      if (selectedIndexes.isNotEmpty) {
                        final selectedCategories = selectedIndexes
                            .map((index) => categories[index])
                            .toList();
                        GoRouter.of(context).push(
                          AppRouter.kPreferenceTwo,
                          extra: {'categories': selectedCategories},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Choose At Least One Option."),
                            backgroundColor: Colors.black,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
