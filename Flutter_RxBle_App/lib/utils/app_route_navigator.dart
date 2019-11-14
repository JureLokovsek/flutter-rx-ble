
import 'package:flutter/material.dart';

class AppNavigator {

  Future navigateToStatefulWidget(BuildContext context, StatefulWidget widget) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  Future navigateToStatelessWidget(BuildContext context, StatelessWidget widget) {
   return Navigator.push(context, MaterialPageRoute(builder: (context) {
     return widget;
   }),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

}