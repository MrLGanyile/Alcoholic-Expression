// Collection Name /stores/storeId/store_draws/storeDrawId
// Branch : competition_resources_crud ->  create_competition_resources_front_end
import '/models/stores/store_draw_state.dart';

import '../locations/converter.dart';
import '../locations/section_name.dart';

// Only the latest store draw of a given store can be updated in a way that reflects in front end.
class StoreDraw implements Comparable<StoreDraw> {
  String? storeDrawId;
  String storeFK;
  DateTime drawDateAndTime;

  bool isOpen;
  int numberOfGrandPrices;
  String storeName;
  String storeImageURL;
  SectionName sectionName;
  StoreDrawState? storeDrawState;

  int joiningFee;

  // Contains A Sub Collection Of Draw Grand Prices
  // Contains A Sub Collection Of Draw Competitors
  // 'timestamp': DateTime.now().millisecondsSinceEpoch,

  StoreDraw({
    this.storeDrawId = '',
    required this.storeFK,
    required this.drawDateAndTime,
    this.isOpen = true,
    required this.numberOfGrandPrices,
    required this.storeName,
    required this.storeImageURL,
    required this.sectionName,
    this.storeDrawState = StoreDrawState.notConvertedToCompetition,
    this.joiningFee = 0,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'storeDrawId': storeDrawId,
      'storeFK': storeFK,
      'drawDateAndTime': {
        'year': drawDateAndTime.year,
        'month': drawDateAndTime.month,
        'day': drawDateAndTime.day,
        'hour': drawDateAndTime.hour,
        'minute': drawDateAndTime.minute,
      },
      'numberOfGrandPrices': numberOfGrandPrices,
      'isOpen': isOpen,
      'storeName': storeName,
      'storeImageURL': storeImageURL,
      'sectionName': sectionName,
      'joiningFee': joiningFee,
    });
    return map;
  }

  factory StoreDraw.fromJson(dynamic json) => StoreDraw(
      storeDrawId: json['storeDrawId'],
      storeFK: json['storeFK'],
      drawDateAndTime: DateTime(
        json['drawDateAndTime']['year'],
        json['drawDateAndTime']['month'],
        json['drawDateAndTime']['day'],
        json['drawDateAndTime']['hour'],
        json['drawDateAndTime']['minute'],
      ),
      numberOfGrandPrices: json['numberOfGrandPrices'],
      isOpen: json['isOpen'],
      storeName: json['storeName'],
      storeImageURL: json['storeImageURL'],
      sectionName: Converter.toSectionName(json['sectionName']),
      storeDrawState: Converter.toStoreDrawState(json['storeDrawState']));

  @override
  int compareTo(StoreDraw other) {
    return other.drawDateAndTime.compareTo(drawDateAndTime);
  }
}
