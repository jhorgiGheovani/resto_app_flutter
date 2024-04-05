import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/provider/restaurant_list_provider.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/widgets/restaurant_list_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // Create a FocusNode
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus(); // Request focus on the TextField
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debouncer.call(() {
      final provider =
          Provider.of<RestaurantListProvider>(context, listen: false);
      provider.searchRestaurant(_searchController.text);
    });
  }

  Widget _buildSearchResult() {
    return Consumer<RestaurantListProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          return const Center(child: Text("loading"));
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: provider.searchResult.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = provider.searchResult.restaurants[index];
                return RestaurantListCard(restaurantListItem: restaurant);
              });
        } else if (provider.state == ResultState.noData) {
          return Center(
              child: Material(
            child: Text(provider.message),
          ));
        } else if (provider.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Search',
            style: myTextTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
                fontFamily: GoogleFonts.rubik().fontFamily),
          ),
          titleSpacing: 0,
          scrolledUnderElevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.0,
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: myTextTheme.titleSmall?.copyWith(
                      color: Colors.grey.shade800,
                      letterSpacing: 0.01,
                      fontSize: 15,
                      fontFamily: GoogleFonts.rubik().fontFamily),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText: 'Find resto arround you...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Rounded border
                        borderSide: BorderSide(
                          color: Colors.grey.shade300, // Default border color
                          width: 1.0, // Border width
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: myTextTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade700,
                          letterSpacing: 0.01,
                          fontSize: 15,
                          fontFamily: GoogleFonts.rubik().fontFamily),

                      // TextStyle(color: Colors.grey.shade900),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Same border radius
                        borderSide: BorderSide(
                          color:
                              Colors.grey.shade300, // Border color when focused
                          width: 1.0, // Border width when focused
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
              ),
            ),
            Expanded(
              child: _buildSearchResult(), // Your search result widget
            ),
          ],
        ),
        backgroundColor: primaryColor,
      );
}

class Debouncer {
  Debouncer({this.milliseconds = 300});

  final int milliseconds;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
