import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {

  @HiveField(0)
  String accountName;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  User({
    required this.accountName,
    required this.firstName,
    required this.lastName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          accountName == other.accountName &&
          firstName == other.firstName &&
          lastName == other.lastName;

  @override
  int get hashCode =>
      accountName.hashCode ^ firstName.hashCode ^ lastName.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return accountName;
  }
}

/// Get Full name
extension FullName on User {
  String get fullName => "$firstName $lastName";
}
