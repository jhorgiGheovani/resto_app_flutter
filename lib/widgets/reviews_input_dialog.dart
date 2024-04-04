import 'package:flutter/material.dart';
import 'package:resto_app/provider/restaurant_detail_provider.dart';
import 'package:resto_app/provider/result_state.dart';

class ReviewsInputDialog extends StatefulWidget {
  final RestaurantDetailProvider restaurantDetailProvider;
  final String id;
  final ScrollController? controller;

  const ReviewsInputDialog(
      {super.key,
      required this.restaurantDetailProvider,
      required this.id,
      this.controller});

  @override
  State<ReviewsInputDialog> createState() => _ReviewsInputDialogState();
}

class _ReviewsInputDialogState extends State<ReviewsInputDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add your review",
        style: TextStyle(fontSize: 12),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          TextField(
            controller: _reviewController,
            decoration: const InputDecoration(
              hintText: 'Enter your review',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            String name = _nameController.text;
            String review = _reviewController.text;

            await widget.restaurantDetailProvider
                .postReview(widget.id, name, review)
                .then((_) {
              if (widget.restaurantDetailProvider.submitState ==
                  SubmitState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (widget.restaurantDetailProvider.submitState ==
                  SubmitState.success) {
                var data =
                    widget.restaurantDetailProvider.postReviewResponse?.message;
                _nameController.clear();
                _reviewController.clear();
                widget.restaurantDetailProvider
                    .fetchRestaurantList(widget.id)
                    .then((value) => Future.delayed(
                        const Duration(milliseconds: 50),
                        () => widget.controller?.animateTo(
                            widget.controller!.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn)));
                return ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(data!)));
              } else if (widget.restaurantDetailProvider.submitState ==
                  SubmitState.error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(widget.restaurantDetailProvider.message)));
              }
            });
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          child: const Text("Submit"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController
        .dispose(); // Dispose of the controller when the widget is disposed
    _reviewController.dispose();
  }
}
