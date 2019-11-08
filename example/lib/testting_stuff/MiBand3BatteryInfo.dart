import 'dart:typed_data';

class MiBand3BatteryInfo {

  Uint8List _rawValue;

  MiBand3BatteryInfo();

  MiBand3BatteryInfo.fromRawData(this._rawValue);

  int getLevelInPercent() {
    if (this._rawValue != null) {
      if (_rawValue.length >= 1) {
        return _rawValue[1];
      }
      return 50; // actually unknown
    } else {
      return 50; // actually unknown
    }
  }

  String getRawData(){
    return _rawValue.toString();
  }


}