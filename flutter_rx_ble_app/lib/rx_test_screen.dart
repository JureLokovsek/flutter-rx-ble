
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'dart:convert'; // from json to data

class RxTestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RxTestScreenState();
  }
}

class RxTestScreenState extends State<RxTestScreen> {
  List<User> userList = List();
  final PublishSubject subject = PublishSubject<String>();
  bool hasLoaded = true;

  @override
  void initState() {
    super.initState();
   // subject.stream.debounce(Duration(microseconds: 400))).listen(data);
    // TODO: video tut -> https://www.youtube.com/watch?v=P_HFQnHsQc0 8:00
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Search"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String string) => (subject.add(string)),
            ),
            hasLoaded ? Container() : CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: userList.length,
                itemBuilder: (BuildContext ctx, int index){
                  return new Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

}