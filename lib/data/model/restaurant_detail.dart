import 'restaurant_detail_item.dart';

class RestaurantDetail {
  final bool error;
  final String message;
  final RestaurantDetailItem restaurant;

  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetailItem.fromJson(json["restaurant"]),
      );
}
