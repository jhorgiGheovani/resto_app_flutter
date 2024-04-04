import 'restaurant_list_item.dart';

class RestaurantList {
  final bool error;
  final String message;
  final int count;
  final List<RestaurantListItem> restaurants;

  RestaurantList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantListItem>.from(
            json["restaurants"].map((x) => RestaurantListItem.fromJson(x))),
      );
}
