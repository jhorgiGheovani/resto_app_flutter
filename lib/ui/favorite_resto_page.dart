import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/provider/database_provider.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/widgets/restaurant_list_card.dart';

class FavoriteRestoPage extends StatelessWidget {
  const FavoriteRestoPage({super.key});
  static const routeName = '/favorite_resto_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Favorite Resto',
            style: myTextTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
                fontFamily: GoogleFonts.rubik().fontFamily),
          ),
          titleSpacing: 0,
          scrolledUnderElevation: 0.0,
        ),
        body: Center(
            child: Consumer<DatabaseProvider>(builder: (context, provider, _) {
          if (provider.state == ResultState.noData) {
            return Center(child: Material(child: Text(provider.message)));
          } else if (provider.state == ResultState.hasData) {
            return ListView.builder(
                itemCount: provider.favoriteResto.length,
                itemBuilder: (context, index) {
                  var restaurant = provider.favoriteResto[index];
                  return RestaurantListCard(restaurantListItem: restaurant);
                });
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        })));
  }
}
