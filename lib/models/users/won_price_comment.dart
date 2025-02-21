class WonPriceComment {
  String wonPriceCommentId;
  String message;
  DateTime? dateCreated;
  String imageURL;
  String username;

  WonPriceComment({
    required this.wonPriceCommentId,
    required this.message,
    this.dateCreated,
    required this.imageURL,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    dateCreated = DateTime.now();
    final map = {
      'wonPriceCommentId': wonPriceCommentId,
      'message': message,
      'dateCreated': {
        'year': dateCreated!.year,
        'month': dateCreated!.month,
        'day': dateCreated!.day,
        'hour': dateCreated!.hour,
        'minute': dateCreated!.minute
      },
      imageURL: "imageURL",
      username: "username",
    };
    return map;
  }

  factory WonPriceComment.fromJson(dynamic json) => WonPriceComment(
      wonPriceCommentId: json['wonPriceCommentId'],
      message: json['message'],
      dateCreated: DateTime(
        json['dateCreated']['year'],
        json['dateCreated']['month'],
        json['dateCreated']['day'],
        json['dateCreated']['hour'],
        json['dateCreated']['minute'],
      ),
      imageURL: json["imageURL"],
      username: json["username"]);
}
