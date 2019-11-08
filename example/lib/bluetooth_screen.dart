import 'dart:typed_data';

import 'package:fimber/fimber.dart';
import 'package:fimber/fimber.dart' as prefix0;
import 'package:flutter/material.dart';

import 'package:rx_ble/rx_ble.dart';
import 'package:rx_ble_testing/testting_stuff/MiBand3BatteryInfo.dart';


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
  final String deviceMiBand3BatteryUUID = "00000006-0000-3512-2118-0009af100700";
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
          raisedButtonReadCharacteristic(context, "ReadCharacteristic"),
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
        startScan();
        // do stuff
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
        onPressed: () async {
          await RxBle.stopScan();
//          await for (final state in RxBle.connect(deviceAddress)) {
////            Fimber.d("Device state $state");
////            //  connectionState = state;
////          }
          readChar();
        });
  }

  Future<void> startScan() async {
    await for (final scanResult in RxBle.startScan()) {
      Fimber.d("Scaned Device " + scanResult.toString());
    }
  }

  Future<void> readChar() async {
    // Uint8List value = await RxBle.readChar(deviceAddress, deviceMiBand3BatteryUUID);
    // MiBand3BatteryInfo miBand3 = MiBand3BatteryInfo.fromRawData(value);
    //  Fimber.d("Battery level: " + miBand3.getLevelInPercent().toString() +"% Raw data: " + miBand3.getRawData());

    RxBle.readChar(deviceAddress, deviceMiBand3BatteryUUID).asStream()
        .map((data) => MiBand3BatteryInfo.fromRawData(data))
        .listen((miBand3) => {
          Fimber.d("Battery level: ${miBand3.getLevelInPercent()}%"),
    }).onDone(() =>
    {
          RxBle.disconnect(),
    });
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
