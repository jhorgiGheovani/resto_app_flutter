import 'dart:convert';
import 'dart:io';

import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/data/model/restaurant_list.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/data/model/reviews_request_body.dart';
import 'package:resto_app/data/model/reviews_response.dart';
import 'package:resto_app/data/model/search_result.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantList> getRestaurantList(http.Client client) async {
    final response = await client.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list!');
    }
  }

  Future<SearchResult> searchResto(http.Client client, String query) async {
    final request = await client.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (request.statusCode == 200) {
      return SearchResult.fromJson(jsonDecode(request.body));
    } else {
      throw Exception('Failed to load restaurant list!');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(
      http.Client client, String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant details!');
    }
  }

  Future<ReviewsResponse> postReview(
      http.Client client, String id, String name, String review) async {
    String requestBody = jsonEncode(
        ReviewsRequestBody(id: id, name: name, review: review).toJson());

    final response = await client.post(Uri.parse("$_baseUrl/review"),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: requestBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add the reviews!');
    }
  }
}
