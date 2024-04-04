import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/provider/restaurant_detail_provider.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/widgets/customer_review_list.dart';
import 'package:resto_app/widgets/list_menu.dart';
import 'package:resto_app/widgets/platform_widget.dart';
import 'package:resto_app/widgets/reviews_input_dialog.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key, required this.id});

  final String id;
  static const routeName = '/restaurant_detail';

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  ScrollController? controller = ScrollController();

  Widget _buildRestaurantDetails() {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), id: widget.id),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, restaurantDetailProvider, _) {
          if (restaurantDetailProvider.state == ResultState.loading &&
              restaurantDetailProvider.result == null) {
            return _buildLoading();
          } else if (restaurantDetailProvider.state == ResultState.hasData ||
              restaurantDetailProvider.result != null) {
            var data = restaurantDetailProvider.result?.restaurant;
            return Material(
                color: primaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/small/${data!.pictureId}",
                          fit: BoxFit
                              .cover, // Zooms the image to cover the entire available space
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 8),
                        child: Text(
                          data.name,
                          style: myTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1,
                              fontFamily: GoogleFonts.rubik().fontFamily),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 0, left: 8),
                          child: Text(
                            "${data.address}, ${data.city}",
                            style: myTextTheme.titleSmall?.copyWith(
                                color: Colors.black54,
                                letterSpacing: 0.01,
                                fontFamily: GoogleFonts.rubik().fontFamily),
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 3, left: 8, right: 8),
                        child: Text(
                          data.description,
                          textAlign: TextAlign.justify,
                          style: myTextTheme.bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.utensils,
                              size: 15,
                              color: Colors.blueGrey,
                            ), // Adjust the icon and size as needed
                            const SizedBox(
                                width:
                                    8), // Optional: Adds some space between the icon and the text
                            Text("Foods", style: myTextTheme.titleMedium),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListMenu(
                              menu: data.menus.foods,
                              backgroundColor: const Color(0xFFDBEEFF))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.mugSaucer,
                              size: 15,
                              color: Colors.blueGrey,
                            ), // Adjust the icon and size as needed
                            const SizedBox(
                                width:
                                    8), // Optional: Adds some space between the icon and the text
                            Text("Drinks", style: myTextTheme.titleMedium),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListMenu(
                              menu: data.menus.drinks,
                              backgroundColor: const Color(0xFF00ADD5))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.solidComments,
                                  size: 15,
                                  color: Colors.blueGrey,
                                ), // Adjust the icon and size as needed
                                const SizedBox(
                                    width:
                                        8), // Optional: Adds some space between the icon and the text
                                Text("Customer Reviews",
                                    style: myTextTheme.titleMedium),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                height: 25,
                                child: ElevatedButton(
                                  //Button Add Review
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (dialogcontext) {
                                          return ReviewsInputDialog(
                                              restaurantDetailProvider:
                                                  restaurantDetailProvider,
                                              id: widget.id,
                                              controller: controller);
                                        });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFFDBFFDD)),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 10)),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("Add review",
                                          style: myTextTheme.labelLarge
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xFF0C710F),
                                                  fontFamily:
                                                      GoogleFonts.rubik()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3,
                                                  letterSpacing: 0.1,
                                                  fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomerReviewList(
                        customerReviews: data.customerReviews,
                        controller: controller,
                      )
                    ],
                  ),
                ));
          } else if (restaurantDetailProvider.state == ResultState.noData) {
            return _buildNoData(restaurantDetailProvider.message);
          } else if (restaurantDetailProvider.state == ResultState.error) {
            return _buildError(restaurantDetailProvider.message);
          } else {
            return _buildDefault();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoData(String message) {
    return Center(
      child: Material(
        child: Text(message),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Material(
        child: Text(message),
      ),
    );
  }

  Widget _buildDefault() {
    return const Center(
      child: Material(
        child: Text(''),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(
                    55, 0, 0, 0), // Background color of the circle
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ), // Icon color
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )),
        ),
        leadingWidth: 42.0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _buildRestaurantDetails(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Restaurant App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildRestaurantDetails(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
