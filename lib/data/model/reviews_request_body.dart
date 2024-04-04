class ReviewsRequestBody {
  final String id;
  final String name;
  final String review;

  ReviewsRequestBody({
    required this.id,
    required this.name,
    required this.review,
  });

  factory ReviewsRequestBody.fromJson(Map<String, dynamic> json) =>
      ReviewsRequestBody(
        id: json["id"],
        name: json["name"],
        review: json["review"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "review": review,
      };
}
