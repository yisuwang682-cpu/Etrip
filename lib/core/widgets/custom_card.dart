import 'package:egyptopia/core/utils/size_config.dart';
import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.icon,required this.text,required this.onTap});

  final Icon? icon;
  final String? text;
final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.defaultSize! * 6,
      child: Card(
          child: ListTile(
        tileColor: Colors.white,
        textColor: const Color.fromARGB(255, 48, 58, 87),
        iconColor: const Color.fromARGB(255, 48, 58, 87),
        leading: icon,
        title: Text(
          text!,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      )),
    );
  }
}
