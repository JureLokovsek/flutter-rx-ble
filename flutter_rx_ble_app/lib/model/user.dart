
import 'package:flutter/cupertino.dart';

class User {

  int id;
  String name, username, email;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    @required this.email,
  });

  User.fromData(this.id, this.name, this.username, this.email);
  User.fromJsonData(Map json) {
    this.id = json['id']; // .toString();
    this.name = json['name'];
    this.username = json['username'];
    this.email = json['email'];
  }


}