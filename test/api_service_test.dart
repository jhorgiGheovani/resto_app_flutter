import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/data/api/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/data/model/restaurant_list.dart';
import 'package:resto_app/data/model/reviews_request_body.dart';
import 'package:resto_app/data/model/reviews_response.dart';
import 'package:resto_app/data/model/search_result.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('getRestaurantList', () {
    test('getRestaurantList success request', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "message": "success", "count": 20, "restaurants": [{ "id": "rqdv5juczeskfw1e867", "name": "Melting Pot", "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...", "pictureId": "14", "city": "Medan", "rating": 4.2 }] }',
              200));
      expect(
          await ApiService().getRestaurantList(client), isA<RestaurantList>());
    });

    test('getRestaurantList failed request ', () {
      final client = MockClient();
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getRestaurantList(client), throwsException);
    });
  });

  group('getRestaurantDetail', () {
    test('getRestaurantDetail success request', () async {
      final client = MockClient();

      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "message": "success", "restaurant": { "id": "rqdv5juczeskfw1e867", "name": "Melting Pot", "description": "Lorem ipsum", "city": "Medan", "address": "Jln. Pandeglang no 19", "pictureId": "14", "categories": [{ "name": "Italia" }], "menus": { "foods": [{ "name": "Paket rosemary" }], "drinks": [{ "name": "Es krim" }] }, "rating": 4.2, "customerReviews": [{ "name": "Ahmad", "review": "Tidak rekomendasi untuk pelajar!", "date": "13 November 2019" }] } }',
              200));
      expect(
          await ApiService().getRestaurantDetail(client, "rqdv5juczeskfw1e867"),
          isA<RestaurantDetail>());
    });

    test('getRestaurantDetail failed request ', () {
      final client = MockClient();
      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getRestaurantDetail(client, "qaq"), throwsException);
    });
  });

  group('getRestaurantSearch', () {
    test('getRestaurantSearch success request', () async {
      final client = MockClient();

      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=makan')))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "founded": 1, "restaurants": [{ "id": "fnfn8mytkpmkfw1e867", "name": "Makan mudah", "description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...", "pictureId": "22", "city": "Medan", "rating": 3.7 }]}',
              200));
      expect(
          await ApiService().searchResto(client, "makan"), isA<SearchResult>());
    });

    test('getRestaurantSearch failed request', () {
      final client = MockClient();
      // Adjust the URL to include the query parameter
      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=qaq')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Use await to wait for the Future to complete
      expect(ApiService().searchResto(client, "qaq"), throwsException);
    });
  });

  group('postReview', () {
    test('postReview success', () async {
      final client = MockClient();
      String requestBody = jsonEncode(
          ReviewsRequestBody(id: "1", name: "name", review: "review").toJson());

      when(client.post(Uri.parse('https://restaurant-api.dicoding.dev/review'),
              headers: {HttpHeaders.contentTypeHeader: "application/json"},
              body: requestBody))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "message": "success", "customerReviews": [{ "name": "Ahmad", "review": "Tidak rekomendasi untuk pelajar!", "date": "13 November 2019" }, { "name": "test", "review": "makanannya lezat", "date": "29 Oktober 2020" }]}',
              200));
      expect(await ApiService().postReview(client, "1", "name", "review"),
          isA<ReviewsResponse>());
    });

    test('postReview failed', () {
      final client = MockClient();
      String requestBody = jsonEncode(
          ReviewsRequestBody(id: "1", name: "name", review: "review").toJson());
      // Adjust the URL to include the query parameter
      when(client.post(Uri.parse('https://restaurant-api.dicoding.dev/review'),
              headers: {HttpHeaders.contentTypeHeader: "application/json"},
              body: requestBody))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Use await to wait for the Future to complete
      expect(ApiService().postReview(client, "1", "name", "review"),
          throwsException);
    });
  });
}
