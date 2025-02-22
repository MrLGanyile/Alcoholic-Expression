class WonPriceComment implements Comparable<WonPriceComment> {
  String? wonPriceCommentId;
  String wonPriceSummaryFK;
  String message;
  DateTime? dateCreated;
  String imageURL;
  String username;

  WonPriceComment({
    this.wonPriceCommentId,
    required this.wonPriceSummaryFK,
    required this.message,
    this.dateCreated,
    required this.imageURL,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    dateCreated = DateTime.now();
    final map = {
      'wonPriceCommentId': wonPriceCommentId,
      'wonPriceSummaryFK': wonPriceSummaryFK,
      'message': message,
      'dateCreated': {
        'year': dateCreated!.year,
        'month': dateCreated!.month,
        'day': dateCreated!.day,
        'hour': dateCreated!.hour,
        'minute': dateCreated!.minute
      },
      "imageURL": imageURL,
      "username": username,
    };
    return map;
  }

  factory WonPriceComment.fromJson(dynamic json) => WonPriceComment(
      wonPriceCommentId: json['wonPriceCommentId'],
      wonPriceSummaryFK: json['wonPriceSummaryFK'],
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

  void setWonPriceCommentId(String commentId) {
    wonPriceCommentId = commentId;
  }

  String passedTimeRepresentation() {
    Duration duration = dateCreated!.difference(DateTime.now());

    String passedTimeRepresentation;
    if (duration.inMinutes.abs() <= 1) {
      passedTimeRepresentation = 'now';
    } else if (duration.inMinutes.abs() <= 59) {
      passedTimeRepresentation = '${duration.inMinutes.abs()}mins';
    } else if (duration.inMinutes.abs() < 120) {
      passedTimeRepresentation = '1h';
    } else if (duration.inMinutes.abs() < 60 * 24) {
      passedTimeRepresentation = '${duration.inHours.abs()}h';
    } else if (duration.inMinutes.abs() < 60 * 24 * 7) {
      passedTimeRepresentation = '${duration.inDays.abs()}d';
    } else if (duration.inMinutes.abs() < 60 * 24 * 7 * 4) {
      passedTimeRepresentation = '${duration.inDays.abs() ~/ 7}w';
    } else if (duration.inMinutes.abs() < (60 * 24 * 7 * 4)) {
      passedTimeRepresentation =
          '${duration.inMinutes.abs() ~/ (60 * 24 * 7 * 4)}mo';
    } else if (duration.inMinutes.abs() < (60 * 24 * 7 * 4 * 24)) {
      passedTimeRepresentation =
          '${duration.inMinutes.abs() ~/ (60 * 24 * 7 * 4 * 12)}yr';
    } else {
      passedTimeRepresentation =
          '${duration.inMinutes.abs() ~/ (60 * 24 * 7 * 4 * 12)}yrs';
    }

    return passedTimeRepresentation;
  }

  @override
  int compareTo(WonPriceComment other) {
    return dateCreated!.compareTo(other.dateCreated!);
  }
}
