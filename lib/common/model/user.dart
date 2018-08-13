import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User extends Object {
  String username;
  String avatarLarge;
  String jobTitle;
  String company;

  User(this.username, this.avatarLarge, this.jobTitle, this.company);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'avatarLarge': avatarLarge,
        'jobTitle': jobTitle,
        'company': company
      };
}
