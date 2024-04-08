// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import 'package:resto_app/data/localdb/sqlite_database_helper.dart';
import 'package:resto_app/data/model/restaurant_list_item.dart';
import 'package:resto_app/provider/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final SqLiteDatabaseHelper sqLiteDatabaseHelper;
  DatabaseProvider({
    required this.sqLiteDatabaseHelper,
  }) {
    _getFavoriteResto();
  }

  late ResultState _state = ResultState.noData;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantListItem> _restaurantFavorite = [];
  List<RestaurantListItem> get favoriteResto => _restaurantFavorite;

  void _getFavoriteResto() async {
    _restaurantFavorite = await sqLiteDatabaseHelper.getFavoriteResto();

    if (_restaurantFavorite.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = "You haven't saved any favorite restaurant yet.";
    }
    notifyListeners();
  }

  void addFavorite(RestaurantListItem restaurant) async {
    try {
      await sqLiteDatabaseHelper.insertFavoriteResto(restaurant);
      _getFavoriteResto();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoritedResto = await sqLiteDatabaseHelper.getFavoriteById(id);
    return favoritedResto.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await sqLiteDatabaseHelper.removeFavoriteResto(id);
      _getFavoriteResto();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
