import 'package:egyptopia/features/Itinerary/presentation/views/itinerary_gate.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_state.dart';
import 'package:egyptopia/features/Profile/presentation/views/profile_view.dart';
import 'package:egyptopia/features/wishlist/presentation/views/wish_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/views/home_view.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _selectedIndex = 0;

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    if (state.extra != null && state.extra is int) {
      setState(() {
        _selectedIndex = state.extra as int;
      });
    }
  }

  final List<Widget> _screens = [
    const HomeView(),
    const WishListView(),
    const ItineraryGate(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type:
                BottomNavigationBarType.fixed, // Ensures all labels are visible
            onTap: (val) {
              if ((val == 1 || val == 2) && userState is! UserLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("You must be logged in first to use this feature"),
                    backgroundColor: Colors.black87,
                  ),
                );
                return;
              }

              setState(() {
                _selectedIndex = val;
              });
            },
            currentIndex: _selectedIndex,
            iconSize: 25,
            selectedItemColor: const Color.fromARGB(255, 104, 67, 153),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: "Discover"),
              BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 1
                      ? Icons.favorite
                      : Icons.favorite_border),
                  label: "Wishlist"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined), label: "Itinerary"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: "Profile")
            ]),
        body: _screens[_selectedIndex]);
  }
}
