
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

  Student({required this.studentID, required this.name, required this.email, required this.badgeLevel});
}