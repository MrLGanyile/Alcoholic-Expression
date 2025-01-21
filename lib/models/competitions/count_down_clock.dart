// Branch : competition_resources_creation
class CountDownClock {
  int remainingTime;

  CountDownClock({
    required this.remainingTime,
  });

  factory CountDownClock.fromJson(dynamic json) => CountDownClock(
        remainingTime: json["remainingTime"],
      );
}
