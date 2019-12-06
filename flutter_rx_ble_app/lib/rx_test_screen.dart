import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:rx_ble/rx_ble.dart';
import 'package:rx_ble_testing/testting_stuff/Mi_band3_batteryInfo.dart';

import 'dart:convert'; // from json to data

class RxTestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RxTestScreenState();
  }
}

class RxTestScreenState extends State<RxTestScreen> {
  // List<User> userList = List();
  //final PublishSubject subject = PublishSubject<String>();
  // bool hasLoaded = true;

  var connectionState = BleConnectionState.disconnected;
  String noninMacAddress = "00:1C:05:FF:4E:5B";
 //String BATTERY_LEVEL_CHARACTERISTIC = "00002A19-0000-1000-8000-00805f9b34fb";
  String PLX_SPOT_CHECK_MEASUREMENT_CHARACTERISTIC = "00002A5E-0000-1000-8000-00805f9b34fb";



  @override
  void initState() {
    super.initState();
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
            RaisedButton(
              child: Text("Button 1", style: TextStyle(fontFamily: 'DejaVuSansMono'),
              ),
              onPressed: () => {
                Fimber.d("Button 1 Clidk"),
                noninTesting(),
              },
            ),
            RaisedButton(
              child: Text("Button 2", style: TextStyle(fontFamily: 'DejaVuSansMono'),
              ),
              onPressed: () => {
                Fimber.d("Button 2 Clidk"),
              },
            ),
          ],
        ),
      ),
    );
  }

  void noninTesting() {
    Observable(RxBle.startScan())
        .map((item) => item)
        .doOnData((data) => {
      Fimber.d("JL :: onData: $data")
    })
        .doOnError((error) => {
      Fimber.d("JL :: Error: $error")
    })
        .where((device) => filterMac(device.deviceId))
        .listen((device)=>{
      RxBle.stopScan(),
      Fimber.d("Device found"),

//      Observable(RxBle.observeChar(noninMacAddress, PLX_SPOT_CHECK_MEASUREMENT_CHARACTERISTIC))
//          .listen((data) => {
//            Fimber.d("Data :: " + data.toString())
//         }),

      Observable(RxBle.connect(device.deviceId))
          .listen((connectionState) => {
        Fimber.d("JL :: Ble Connection State: $connectionState"),
        if(connectionState == BleConnectionState.connected) {
         Observable(RxBle.observeChar(noninMacAddress, PLX_SPOT_CHECK_MEASUREMENT_CHARACTERISTIC))
          .listen((data) => {
            Fimber.d("Data :: " + data.toString()),
           RxBle.disconnect(),
         })

//          Observable.fromFuture(RxBle.readChar(noninMacAddress, PLX_SPOT_CHECK_MEASUREMENT_CHARACTERISTIC))
//              .doOnData((data) => {
//            Fimber.d("JL :: Data Stream: $data")
//          })
//              .take(1)
//              .map((data) => MiBand3BatteryInfo.fromRawData(data))
//              .listen((miBand3BatteryInfo) => {
//            Fimber.d("JL :: Value: " + miBand3BatteryInfo.getLevelInPercent().toString()+"%"),
//          }).onDone(() => {
//            Fimber.d("JL :: onDone"),
//            RxBle.disconnect(),
//          })
        } else {
          Fimber.d("JL :: Not connected"),
        }
      })

    });
  }

  bool filterMac(String mac) {
    return mac == noninMacAddress;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
