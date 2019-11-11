import 'dart:typed_data';
import 'Unit_type.dart';

class PulseOximeterRecord {

  Uint8List rawValue;
  int timestamp;
  //
  int oxygenSaturation;
  UnitType oxygenSaturationUnit = UnitType.PERCENT;
  int pulseRate;
  UnitType pulseUnit = UnitType.BPM;

  PulseOximeterRecord();

  PulseOximeterRecord.fromData(this.rawValue, this.timestamp, this.oxygenSaturation, this.oxygenSaturationUnit, this.pulseRate, this.pulseUnit);

  @override
  String toString() {
    return 'PulseOximeterRecord{rawValue: $rawValue, timestamp: $timestamp, oxygenSaturation: $oxygenSaturation, oxygenSaturationUnit: $oxygenSaturationUnit, pulseRate: $pulseRate, pulseUnit: $pulseUnit}';
  }


}