import 'dart:typed_data';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import 'package:rx_ble/rx_ble.dart';
import 'package:rx_ble_testing/testting_stuff/Mi_band3_batteryInfo.dart';
import 'package:rx_ble_testing/utils.dart';
import 'package:rxdart/rxdart.dart';


// ignore: must_be_immutable
class BluetoothScreen extends StatelessWidget {

  var returnValue;
  String deviceId;
  Exception returnError;
  var connectionState = BleConnectionState.disconnected;
  var isWorking = false;
  // testing stuff
 // final String deviceAddress = "E3:22:C4:77:73:E8"; // Mi Band 3
  final String deviceAddress = "F1:6E:71:52:2C:E7"; // Mi Band 4
  final String deviceAddressNonin = "00:1C:05:FF:4E:5B"; // Mi Band 4
  final String deviceMiBand3BatteryUUID = "00000006-0000-3512-2118-0009af100700";
  final String setupControlPointNotification = "1447af80-0d60-11e2-88b6-0002a5d5c51b";
  //
  Stream<Uint8List> observeCharList;
  List<String> approvedDeviceNameList = [
    //  "Mi Band 3",
    // "Mi Smart Band 4",
    "Nonin3230_502591753"
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white70,
      child: ListView(
        padding: EdgeInsets.only(top: 50.0),
        children: <Widget>[
         // ImageWidget(120.0, 120.0, "assets/images/flutter_ble_lib_logo.png"),
          Center(
            child: textTitle("App"),
          ),
          raisedButtonStartScan(context, "Start Scan...Show in Log"),
          raisedButtonStopScan(context, "Stop Scan...Show in Log"),
          raisedButtonConnect(context, "Connect"),
          raisedButtonDisconnect(context, "Disconnect"),
          raisedButtonReadCharacteristic(context, "Read MiBand 3/4 Battery Characteristic"),
          raisedButtonReadNonimCharacteristic(context, "Read Nonin Raw Data Characteristic"),
        ],
      ),
    );
  }

  Text textTitle(String value) {
    return Text(value,
        textDirection: TextDirection.ltr,
        style: TextStyle(
            color: Colors.indigoAccent,
            fontSize: 40.0,
            fontFamily: "Roboto",
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold
        ));
  }

  RaisedButton raisedButtonStartScan(BuildContext context, String buttonName) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(buttonName, textScaleFactor: 1.5),
      onPressed: () {
        Fimber.d("Click: $buttonName");
        int i = 0;
        Observable(RxBle.startScan())
        .take(50)
        .doOnData((scannedDevice) => {
         // Fimber.d("Scanned Device Address: " + scannedDevice.deviceId),
        })
        //.interval(Duration(milliseconds: 1000 * 15))
        .doOnError((onError) => {
          RxBle.stopScan(),
          Fimber.d("onError :: $onError")
        })
        .listen((onData) => {
          i++,
          Fimber.d("$i Device: " + onData.toString()),
        }).onDone(() => ({
          Fimber.d("OnDone:"),
          RxBle.stopScan()
        }));
      },
    );
  }

  RaisedButton raisedButtonStopScan(BuildContext context, String buttonName) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(buttonName, textScaleFactor: 1.5),
      onPressed: () {
        Fimber.d("Click: $buttonName");
        RxBle.stopScan();
        // do stuff
      },
    );
  }

  RaisedButton raisedButtonConnect(BuildContext context, String buttonName) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(buttonName, textScaleFactor: 1.5),
      onPressed: () async {
        await RxBle.stopScan();
        await for (final state in RxBle.connect(deviceAddress)) {
          Fimber.d("Device state $state");
        //  connectionState = state;
        }
      });
  }

  RaisedButton raisedButtonDisconnect(BuildContext context, String buttonName) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(buttonName, textScaleFactor: 1.5),
      onPressed: () {
        Fimber.d("Click: $buttonName");
        // do stuff
        RxBle.disconnect();
      },
    );
  }

  RaisedButton raisedButtonReadCharacteristic(BuildContext context, String buttonName) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(buttonName, textScaleFactor: 1.5),
        onPressed: () {
          // await RxBle.stopScan();
          // readChar();
          getBatteryLevelMiBand();
        });
  }

  void getBatteryLevelMiBand() {
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
      Observable(RxBle.connect(device.deviceId))
      .listen((connectionState) => {
        Fimber.d("JL :: Ble Connection State: $connectionState"),
        if(connectionState == BleConnectionState.connected) {
         Observable.fromFuture(RxBle.readChar(deviceAddress, deviceMiBand3BatteryUUID))
          .doOnData((data) => {
            Fimber.d("JL :: Data Stream: $data")
         })
          .take(1)
             .map((data) => MiBand3BatteryInfo.fromRawData(data))
          .listen((miBand3BatteryInfo) => {
            Fimber.d("JL :: Value: " + miBand3BatteryInfo.getLevelInPercent().toString()+"%"),
         }).onDone(() => {
           Fimber.d("JL :: onDone"),
           RxBle.disconnect(),
         })
        } else {
          Fimber.d("JL :: Not connected"),
        }
      })
        });
  }

  bool filterMac(String mac) {
    return mac == deviceAddress;
  }

  // TODO: get raw data from nonin
  RaisedButton raisedButtonReadNonimCharacteristic(BuildContext context,
      String buttonName) {
    return RaisedButton(
        padding: EdgeInsets.only(left: 50.0, right: 50.0),
        color: Theme
            .of(context)
            .primaryColorDark,
        textColor: Theme
            .of(context)
            .primaryColorLight,
        child: Text(buttonName, textScaleFactor: 1.5),
        onPressed: () {
          getNonin();
        });
  }

  void getNonin() {
    RxBle.startScan()
        .where((device) => Utils.filterAddress(device.deviceId, "00:1C:05:FF:4E:5B"))
        .take(1)
        .listen((device) => {
       Fimber.d("Device Found: " + device.deviceName +" Id: " + device.deviceId),
      RxBle.stopScan(),
      RxBle.connect(device.deviceId)
      .listen((status) => {
      if(status == BleConnectionState.connected) {
        Fimber.d("Connected"),
        writeChar(device.deviceId),
        observeChar(device.deviceId),
//        RxBle.writeChar(device.deviceId, "1447af80-0d60-11e2-88b6-0002a5d5c51b", Uint8List.fromList([]))
//            .then((values) => {
//            Fimber.d("Values: " + values.toString()),

//          RxBle.writeChar(device.deviceId, "1447af80-0d60-11e2-88b6-0002a5d5c51b", Uint8List.fromList([2]))
//          .then((ok) => {
//            for(int i=0; i<ok.length; i++) {
//              Fimber.d("OK: " + ok.elementAt(i).toString() +" Index: " + i.toString()),
//            },
//            Fimber.d("Disconnect"),
//            RxBle.disconnect(),
//          }),
       // }),
      }})

    });

//    Observable(RxBle.startScan())
//        .map((item) => item)
//        .doOnData((data) => {
//      Fimber.d("JL :: onData: $data")
//        })
//        .doOnError((error) => {
//      Fimber.d("JL :: Error: $error")
//        })
//        .where((device) => Utils.filterAddress(device.deviceId, "00:1C:05:FF:4E:5B"))
//        .listen((device)=>{
//      RxBle.stopScan(),
//      Observable(RxBle.connect(device.deviceId))
//          .listen((connectionState) => {
//        Fimber.d("JL :: Ble Connection State: $connectionState"),
//        if(connectionState == BleConnectionState.connected) {
//
//        } else {
//          Fimber.d("JL :: Not connected"),
//        }
//      })
//    });

  }

  Future<void> observeChar(String deviceId) async {
    await for (final value in RxBle.observeChar(deviceId, "1447af80-0d60-11e2-88b6-0002a5d5c51b")) {
      Fimber.d("Val:" + value.toString() +" Other: " + RxBle.charToString(value, allowMalformed: true));
      }
    }

  Future<void> writeChar(String deviceId) async {
    Uint8List list = Uint8List(2);
    list[0] = 0x61;
    list[1] = 0x11;
    return await RxBle.writeChar(deviceId, "1447af80-0d60-11e2-88b6-0002a5d5c51b", list);
  }

}


//
//
//@override
//  void dispose() {
//   // inputController.dispose();
//  //  channel.sink.close();
//    super.dispose();
//  }
//
//
