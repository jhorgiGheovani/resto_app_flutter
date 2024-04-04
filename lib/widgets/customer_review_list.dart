import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/model/restaurant_detail_item.dart';

class CustomerReviewList extends StatelessWidget {
  final List<CustomerReview> customerReviews;
  final ScrollController? controller;

  const CustomerReviewList(
      {super.key, required this.customerReviews, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        padding: const EdgeInsets.only(top: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: customerReviews.length,
        itemBuilder: (context, index) {
          return Material(
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: const EdgeInsets.only(top: 0, left: 12),
              tileColor: Colors.white, // Set background color to white
              title: Text(
                customerReviews[index].name,
                style: myTextTheme.bodySmall?.copyWith(
                    letterSpacing: 0.1,
                    height: 1.3,
                    fontSize: 14,
                    fontFamily: GoogleFonts.roboto().fontFamily),
              ),
              subtitle: Text(
                customerReviews[index].review,
                style: myTextTheme.bodySmall?.copyWith(
                    letterSpacing: 0.2,
                    fontFamily: GoogleFonts.roboto().fontFamily),
              ), // Add a subtitle
            ),
          );
        });
  }
}
