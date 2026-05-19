import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'page_view_item.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key, required this.pageController});
  final PageController? pageController;
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: "assets/images/page view 1.png",
          title: Translations.tr('onboarding_title_1', lang),
          subTitle: Translations.tr('onboarding_sub_1', lang),
        ),
        PageViewItem(
          image: "assets/images/page view 2.png",
          title: Translations.tr('onboarding_title_2', lang),
          subTitle: Translations.tr('onboarding_sub_2', lang),
        ),
        PageViewItem(
          image: "assets/images/page view 3.png",
          title: Translations.tr('onboarding_title_3', lang),
          subTitle: Translations.tr('onboarding_sub_3', lang),
        ),
      ],
    );
  }
}
