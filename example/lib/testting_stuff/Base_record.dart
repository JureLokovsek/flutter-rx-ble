import 'dart:typed_data';

class BaseRecord {

  Uint8List rawValue;
  int timestamp;

  BaseRecord();

  BaseRecord.fromData(this.rawValue, this.timestamp);

  @override
  String toString() {
    return 'BaseRecord{rawValue: $rawValue, timestamp: $timestamp}';
  }


}