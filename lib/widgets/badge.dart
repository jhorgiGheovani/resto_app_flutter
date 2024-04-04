import 'package:flutter/material.dart';

class BadgeCustom extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Text textmessage;

  const BadgeCustom({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.textmessage,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Material(
        elevation: 5, // Set the elevation value as needed
        borderRadius: BorderRadius.circular(
            10.0), // Apply border radius to Material widget
        child: Container(
          height: 25,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: textmessage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
