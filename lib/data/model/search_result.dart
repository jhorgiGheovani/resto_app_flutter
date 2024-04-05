import 'package:resto_app/data/model/restaurant_list_item.dart';

class SearchResult {
  final bool error;
  final int founded;
  final List<RestaurantListItem> restaurants;

  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantListItem>.from(
            json["restaurants"].map((x) => RestaurantListItem.fromJson(x))),
      );
}
