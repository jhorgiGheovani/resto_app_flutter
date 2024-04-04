import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/data/model/reviews_response.dart';
import 'package:resto_app/provider/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService, required String id}) {
    fetchRestaurantList(id);
  }

  RestaurantDetail? _restaurantDetail; //restaurant details response
  ReviewsResponse? _postReviewResponse; // post review response
  late ResultState _state;
  late SubmitState _submitState = SubmitState.loading;
  String _message = '';

  String get message => _message;
  RestaurantDetail? get result => _restaurantDetail;
  ReviewsResponse? get postReviewResponse => _postReviewResponse;
  ResultState get state => _state;
  SubmitState get submitState => _submitState;

  Future<dynamic> fetchRestaurantList(String id) async {
    try {
      //loading
      _state = ResultState.loading;
      notifyListeners();

      final restaurantDetail = await apiService.getRestaurantDetail(id);
      //sukses
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantDetail = restaurantDetail;
    } catch (e) {
      //error
      _state = ResultState.error;
      _restaurantDetail = null;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> postReview(String id, String name, String review) async {
    try {
      //loading
      _submitState = SubmitState.loading;
      notifyListeners();

      final postReview = await apiService.postReview(id, name, review);
      //sukses
      _submitState = SubmitState.success;
      _postReviewResponse = postReview;
      notifyListeners();
      return postReview;
    } catch (e) {
      //error
      _submitState = SubmitState.error;
      _message = 'Error --> $e';
      notifyListeners();
      return _message;
    }
  }
}
