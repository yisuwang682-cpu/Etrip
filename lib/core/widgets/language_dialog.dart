import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleCubit>().state;
    final languageCode = currentLocale.languageCode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Translations.tr('select_language', languageCode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(Translations.tr('english', languageCode)),
              trailing: languageCode == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                context.read<LocaleCubit>().setLanguage('en');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(Translations.tr('chinese', languageCode)),
              trailing: languageCode == 'zh'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                context.read<LocaleCubit>().setLanguage('zh');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
