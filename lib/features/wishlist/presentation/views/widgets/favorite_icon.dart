// ignore_for_file: use_build_context_synchronously
import 'package:etrip/features/wishlist/data/model/favorite_model.dart';
import 'package:etrip/features/wishlist/data/service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_state.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';

class FavoriteIcon extends StatefulWidget {
  final String id;
  final FavoriteType type;
  final String title;
  final String imageUrl;
  final String? additionalInfo;
  final String? price;
  final String city;
  final String? category;
  final String? tourismType;
  final String? rate;
  final double? iconSize;
  final String? description;

  final String? googleMapsLink;

  final int? totalRates;

  final List<dynamic>? carousel;

  const FavoriteIcon({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    this.price,
    required this.city,
    this.additionalInfo,
    this.iconSize,
    this.category,
    this.tourismType,
    this.rate,
    this.description,
    this.googleMapsLink,
    this.totalRates,
    this.carousel,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    final key = '${widget.id}_${widget.type.name}';

    return ValueListenableBuilder(
      valueListenable:
          Hive.box<FavoriteModel>(FavoriteService.boxName).listenable(),
      builder: (context, Box<FavoriteModel> box, _) {
        final isFav = box.containsKey(key);

        return IconButton(
          onPressed: () async {
            final userState = context.read<UserBloc>().state;
            if (userState is! UserLoaded) {
              // If you are not logged in
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Translations.tr('must_login_favorites', lang)),
                  backgroundColor: Colors.black87,
                ),
              );
              return;
            }
            final model = FavoriteModel(
              id: widget.id,
              type: widget.type,
              title: widget.title,
              imageUrl: widget.imageUrl,
              price: widget.price,
              city: widget.city,
              additionalInfo: widget.additionalInfo,
              rate: widget.rate,
              category: widget.category,
              tourismType: widget.tourismType,
              description: widget.description,
              googleMapsLink: widget.googleMapsLink,
              totalRates: widget.totalRates,
              carousel: widget.carousel,
            );
            await FavoriteService.toggleFavorite(model);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav
                      ? '${widget.title} ${Translations.tr('removed_from_favorites', lang)}'
                      : '${widget.title} ${Translations.tr('added_to_favorites', lang)}',
                  style: GoogleFonts.playfairDisplay(color: Colors.white),
                ),
                backgroundColor: Colors.black87,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.black45,
            size: widget.iconSize ?? 35,
          ),
        );
      },
    );
  }
}
