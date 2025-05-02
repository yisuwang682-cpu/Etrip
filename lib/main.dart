import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_event.dart';
import 'package:egyptopia/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/size_config.dart';
import 'features/wishlist/data/service/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  await Hive.initFlutter();
  await FavoriteService.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(context);

         return BlocProvider(
          create: (ctx) {
            final user = FirebaseAuth.instance.currentUser;
            final uid = user != null ? user.uid : '';
            return UserBloc()..add(LoadUser(uid));
          },
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            theme: ThemeData(
              textTheme: GoogleFonts.imFellFrenchCanonScTextTheme(),
            ),
          ),
        );
      },
    );
  }
}
