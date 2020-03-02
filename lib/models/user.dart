import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class User {
    User();
    String login;
    num id;
    String tel;
    String name;
    String pic;
    String token;
}
