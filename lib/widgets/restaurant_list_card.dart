import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/model/restaurant_list_item.dart';
import 'package:resto_app/ui/restaurant_detail_page.dart';
import 'package:resto_app/widgets/badge.dart';

class RestaurantListCard extends StatelessWidget {
  final RestaurantListItem restaurantListItem;

  const RestaurantListCard({super.key, required this.restaurantListItem});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurantListItem.id);
        },
        child: Card(
          color: primaryColor,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Image
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Hero(
                        tag: restaurantListItem.pictureId,
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/small/${restaurantListItem.pictureId}",
                          fit: BoxFit.fill,
                        ),
                      )),
                  // Rating
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          BadgeCustom(
                            backgroundColor: greenGojek,
                            icon: FontAwesomeIcons.solidStar,
                            iconColor: const Color(0xFFFFD43B),
                            textmessage: Text(
                              restaurantListItem.rating.toString(),
                              style: myTextTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: 0.2,
                                  fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: BadgeCustom(
                              backgroundColor: Colors.white,
                              icon: FontAwesomeIcons.locationDot,
                              iconColor: const Color.fromARGB(255, 113, 96, 96),
                              textmessage: Text(
                                restaurantListItem.city,
                                style: myTextTheme.labelLarge?.copyWith(
                                    color: Colors.grey.shade900,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    letterSpacing: 0.2,
                                    fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Name
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 0),
                child: Text(
                  restaurantListItem.name,
                  style: myTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      fontFamily: GoogleFonts.rubik().fontFamily),
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 5.0),
                child: Text(
                  restaurantListItem.description,
                  style: myTextTheme.bodySmall?.copyWith(color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
