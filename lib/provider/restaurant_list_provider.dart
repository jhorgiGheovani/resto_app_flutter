import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant_list.dart';
import 'package:resto_app/data/model/search_result.dart';
import 'package:resto_app/provider/result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService});

  late RestaurantList _restaurantList;
  late SearchResult _searchResult;
  late ResultState _state = ResultState.loading;
  String _message = '';

  String get message => _message;
  RestaurantList get result => _restaurantList;
  SearchResult get searchResult => _searchResult;
  ResultState get state => _state;

  Future<dynamic> fetchRestaurantList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantList = await apiService.getRestaurantList(http.Client());
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'No Internet Connection';
      } else {
        if (restaurantList.restaurants.isEmpty) {
          _state = ResultState.noData;
          return _message = 'Empty Data';
        } else {
          _state = ResultState.hasData;
          notifyListeners();
          return _restaurantList = restaurantList;
        }
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = 'Failed to load restaurant details';
      }
    }
  }

  Future<dynamic> searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchResult = await apiService.searchResto(http.Client(), query);
      if (searchResult.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Can\'t find match resto, please try another one!';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = searchResult;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = 'Failed to load restaurant details';
      }
    }
  }
}
