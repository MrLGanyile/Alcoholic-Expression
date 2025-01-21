// Collection Name /stores/storeId/store_draws/drawId/draw_grand_prices/drawGrandPriceId
// Branch : store_resources_creation
class DrawGrandPrice {
  String grandPriceId;
  String storeDrawFK;
  String imageURL;
  String description;
  int grandPriceIndex;

  DrawGrandPrice({
    required this.grandPriceId,
    required this.storeDrawFK,
    required this.imageURL,
    required this.description,
    required this.grandPriceIndex,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'grandPriceId': grandPriceId,
      'toreDrawFK': storeDrawFK,
      'description': description,
      'imageURL': imageURL,
      'grandPriceIndex': grandPriceIndex,
      'isFake': "No",
    });
    return map;
  }

  factory DrawGrandPrice.fromJson(dynamic json) {
    return DrawGrandPrice(
      grandPriceId: json['grandPriceId'],
      storeDrawFK: json['storeDrawFK'],
      description: json['description'],
      imageURL: json['imageURL'],
      grandPriceIndex: json['grandPriceIndex'],
    );
  }

  @override
  String toString() {
    return 'Description: $description Grand Price Id: $grandPriceId '
        'Image Location: $imageURL';
  }
}
