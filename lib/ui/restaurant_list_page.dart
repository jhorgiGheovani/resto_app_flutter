import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/provider/restaurant_list_provider.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/ui/favorite_resto_page.dart';
import 'package:resto_app/ui/search_page.dart';
import 'package:resto_app/ui/settings_page.dart';
import 'package:resto_app/widgets/platform_widget.dart';
import 'package:resto_app/widgets/restaurant_list_card.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});
  //  final RestaurantListProvider restaurantListProvider;

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  Widget _buildList() {
    return Consumer<RestaurantListProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return RestaurantListCard(restaurantListItem: restaurant);
            });
      } else if (state.state == ResultState.noData) {
        return Center(
            child: Material(
          child: Text(state.message),
        ));
      } else if (state.state == ResultState.error) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else {
        return const Center(
          child: Material(
            child: Text(''),
          ),
        );
      }
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black87,
            ),
            itemBuilder: (BuildContext context) {
              return {'Favorite', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        scrolledUnderElevation: 0.0,
        title: Container(
          width: double.infinity,
          height: 40, // Adjust the height as needed
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors
                  .grey.shade300, // Match the border color of the TextField
            ),
            borderRadius: BorderRadius.circular(
                25.0), // Match the border radius of the TextField
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
              onTap: () {
                // Navigate to the search screen when the Text is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<RestaurantListProvider>(
                      create: (_) =>
                          RestaurantListProvider(apiService: ApiService()),
                      child: const SearchPage(),
                    ),
                  ),
                );
              },
              highlightColor: Colors.transparent, // No color change on tap
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Find resto arround you...',
                      style: myTextTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade700,
                          letterSpacing: 0.01,
                          fontSize: 15,
                          fontFamily: GoogleFonts.rubik()
                              .fontFamily), // Match the text color of the TextField
                    ),
                  )
                ],
              )),
        ),
      ),
      body: _buildList(),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Favorite':
        Navigator.pushNamed(context, FavoriteRestoPage.routeName);

        break;
      case 'Settings':
        Navigator.pushNamed(context, SettingsPage.routeName);
        break;
    }
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Restaurant App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
