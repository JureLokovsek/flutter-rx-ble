class ValueInterpreter {


  /*
   * Return the integer value interpreted from the passed byte array.
   *
   * <p>The formatType parameter determines how the value
   * is to be interpreted. For example, setting formatType to
   * {@link #FORMAT_UINT16} specifies that the first two bytes of the
   * characteristic value at the given offset are interpreted to generate the
   * return value.
   *
   * @param value The byte array from which to interpret value.
   * @param formatType The format type used to interpret the value.
   * @param offset Offset at which the integer value can be found.
   * @return The value at a given offset or null if offset exceeds value size.
   */
//  int getIntValue(@NonNull byte[] value, @IntFormatType int formatType, @IntRange(from = 0) int offset) {
//  if ((offset + getTypeLen(formatType)) > value.length) {
//  RxBleLog.w(
//  "Int formatType (0x%x) is longer than remaining bytes (%d) - returning null", formatType, value.length - offset
//  );
//  return null;
//  }
//
//  switch (formatType) {
//  case FORMAT_UINT8:
//  return unsignedByteToInt(value[offset]);
//
//  case FORMAT_UINT16:
//  return unsignedBytesToInt(value[offset], value[offset + 1]);
//
//  case FORMAT_UINT32:
//  return unsignedBytesToInt(value[offset],   value[offset + 1],
//  value[offset + 2], value[offset + 3]);
//  case FORMAT_SINT8:
//  return unsignedToSigned(unsignedByteToInt(value[offset]), 8);
//
//  case FORMAT_SINT16:
//  return unsignedToSigned(unsignedBytesToInt(value[offset],
//  value[offset + 1]), 16);
//
//  case FORMAT_SINT32:
//  return unsignedToSigned(unsignedBytesToInt(value[offset],
//  value[offset + 1], value[offset + 2], value[offset + 3]), 32);
//  default:
//  RxBleLog.w("Passed an invalid integer formatType (0x%x) - returning null", formatType);
//  return null;
//  }
//  }


}