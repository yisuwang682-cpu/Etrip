import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String sunrise;
  final String sunset;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return Card(
      color: Colors.white.withValues(alpha:0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("${temperature.toStringAsFixed(1)}°C",
                style: GoogleFonts.ebGaramond(
                    fontSize: SizeConfig.defaultSize! * 2.4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(description,
                style: TextStyle(
                    fontSize: SizeConfig.defaultSize! * 1.6,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const VerticalSpace(1),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _buildWeatherDetail(
                  Icons.water_drop, Colors.blue, Translations.tr('humidity', lang), "$humidity%"),
              _buildWeatherDetail(Icons.air, Colors.grey, Translations.tr('wind_speed', lang),
                  "${windSpeed.toStringAsFixed(1)} m/s"),
              _buildWeatherDetail(
                  Icons.speed, Colors.orange, Translations.tr('pressure', lang), "$pressure hPa%"),
            ]),
            const VerticalSpace(2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherDetail(
                    Icons.wb_sunny, Colors.yellow, "${Translations.tr('sunrise', lang)}$sunrise", null,
                    visable: false),
                _buildWeatherDetail(Icons.nightlight_round, Colors.orange,
                    "${Translations.tr('sunset', lang)}$sunset", null,
                    visable: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildWeatherDetail(
    IconData icon, Color iconColor, String label, String? value,
    {bool visable = true}) {
  return Column(
    children: [
      Icon(icon, color: iconColor),
      Text(label, style: GoogleFonts.lato(color: Colors.white)),
      if (visable)
        Text(value!,
            style: GoogleFonts.lato(
                color: Colors.white, fontWeight: FontWeight.bold)),
    ],
  );
}
