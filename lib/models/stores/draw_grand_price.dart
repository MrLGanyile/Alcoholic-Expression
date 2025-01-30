// Collection Name /stores/storeId/store_draws/drawId/draw_grand_prices/drawGrandPriceId
// Branch : competition_resources_crud ->  create_competition_resources_front_end
class DrawGrandPrice {
  String? grandPriceId;
  String? storeDrawFK;
  String imageURL;
  String description;
  int grandPriceIndex;

  DrawGrandPrice({
    this.grandPriceId,
    required this.storeDrawFK,
    required this.imageURL,
    required this.description,
    required this.grandPriceIndex,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'description': description,
      'imageURL': imageURL,
      'grandPriceIndex': grandPriceIndex,
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
