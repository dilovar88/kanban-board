import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String accountName;

  @HiveField(2)
  String firstName;

  @HiveField(3)
  String lastName;

  User({
    required this.id,
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

  toJson() => {
    "id"              : id,
    "account_name"    : accountName,
    "first_name"      : firstName,
    "last_name"       : lastName,
  };

  static User fromJson(Map json) => User(
    id: json["id"] ?? const Uuid().v1(),
    accountName: json["account_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

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
