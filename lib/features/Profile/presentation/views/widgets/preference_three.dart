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

class PreferenceThree extends StatefulWidget {
  const PreferenceThree({super.key});

  @override
  State<PreferenceThree> createState() => _PreferenceThreeState();
}

class _PreferenceThreeState extends State<PreferenceThree> {
  final List<String> categories = [
    "Beheira",
    "Red Sea",
    "Luxor",
    "Aswan",
    "Cairo",
    "Sharm El Sheikh",
    "Giza",
    "Qena",
    "Alexandria",
    "Assiut",
    "Hurghada",
    "Sinai",
    "Marsa Matrouh",
    "Sohag",
    "Dahab",
    "Fayoum",
    "North Coast",
    "Marsa Alam",
    "Beni Suef",
    "New Valley",
    "Suez",
    "Minya",
    "El Gouna",
    "Sharqia"
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
        final savedCities = List<String>.from(prefs['city'] ?? []);
        setState(() {
          selectedIndexes = categories
              .asMap()
              .entries
              .where((entry) => savedCities.contains(entry.value))
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

  Future<void> savePreferences({
    required String userId,
    required List<String> preferredCategories,
    required List<String> preferredTourismTypes,
    required List<String> preferredCities,
  }) async {
    if (preferredCategories.isEmpty &&
        preferredTourismTypes.isEmpty &&
        preferredCities.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final apiService = EgyptopiaApiService();

    try {
      final existingPreferences = await apiService.getUserPreferences(userId);
      if (existingPreferences != null) {
        await apiService.updateUserPreferences(
          userId: userId,
          preferredCategories: preferredCategories,
          preferredTourismTypes: preferredTourismTypes,
          preferredCities: preferredCities,
        );
      } else {
        await apiService.createUserPreferences(
          userId: userId,
          preferredCategories: preferredCategories,
          preferredTourismTypes: preferredTourismTypes,
          preferredCities: preferredCities,
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return ReusableScreen(
        showBackButton: true,
        gradientStops: const [0.1, 0.9],
        backgroundColor: kSecondaryColor,
        imageColor: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User not logged in. Please sign in.'),
              const VerticalSpace(2),
              CustomGeneralButton(
                text: "Sign In",
                onTap: () {
                  GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
                },
              ),
            ],
          ),
        ),
      );
    }

    final Map<String, dynamic>? previousData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final List<String> receivedCategories =
        previousData?['categories']?.cast<String>() ?? [];
    final List<String> receivedTourismTypes =
        previousData?['tourismTypes']?.cast<String>() ?? [];

    return ReusableScreen(
      showBackButton: true,
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
                  Row(
                    children: [
                      Text(
                        'What is your favorite \ncity to explore?',
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
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          try {
                            await savePreferences(
                              userId: userId,
                              preferredCategories: receivedCategories,
                              preferredTourismTypes: receivedTourismTypes,
                              preferredCities: [],
                            );
                            GoRouter.of(context).push(AppRouter.kScreens);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to save preferences: $e"),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 52, right: 10),
                          child: Text(
                            "Skip",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(1.5),
                  Image.asset(
                    AssetsData.spacer,
                    width: double.infinity,
                  ),
                  const VerticalSpace(1.5),
                  Text(
                    'Choose as many as you\'d like or skip for now',
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomGeneralButton(
                        text: "Start Exploring",
                        onTap: isLoading
                            ? null
                            : () async {
                                if (selectedIndexes.isNotEmpty) {
                                  final selectedCities = selectedIndexes
                                      .map((index) => categories[index])
                                      .toList();
                                  try {
                                    await savePreferences(
                                      userId: userId,
                                      preferredCategories: receivedCategories,
                                      preferredTourismTypes:
                                          receivedTourismTypes,
                                      preferredCities: selectedCities,
                                    );
                                    GoRouter.of(context)
                                        .push(AppRouter.kScreens);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Failed to save preferences: $e"),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Please Choose At Least One Option Or Skip."),
                                      backgroundColor: Colors.black,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                      ),
                      if (isLoading)
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
