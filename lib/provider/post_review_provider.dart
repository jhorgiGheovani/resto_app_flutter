import 'package:flutter/cupertino.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/reviews_response.dart';
import 'package:resto_app/provider/result_state.dart';

class PostReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  final String name;
  final String review;

  PostReviewProvider(
      {required this.apiService,
      required this.id,
      required this.name,
      required this.review}) {
    _postReview(id, name, review);
  }

  late ReviewsResponse _reviewsResponse;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  ResultState get state => _state;
  ReviewsResponse get result => _reviewsResponse;

  Future<dynamic> _postReview(String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.postReview(id, name, review);
      _state = ResultState.hasData;
      notifyListeners();
      return _reviewsResponse = response;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
