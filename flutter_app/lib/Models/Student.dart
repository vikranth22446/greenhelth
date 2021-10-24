
enum BadgeLevel {
  GreenBadge,
  YellowBadge,
  RedBadge
}

class Student {
  String studentID;
  String name;
  String email;
  BadgeLevel badgeLevel;
  DateTime lastUpdated;

  Student({required this.studentID, required this.name, required this.email, required this.badgeLevel, required this.lastUpdated});
}