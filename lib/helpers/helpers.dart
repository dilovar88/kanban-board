import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Convert Seconds to H:m:s format
String secondsToHourMinute(int seconds) {
  int h, m, s;

  h = seconds ~/ 3600;

  m = ((seconds - h * 3600)) ~/ 60;

  s = seconds - (h * 3600) - (m * 60);

  String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

  String minuteLeft =
  m.toString().length < 2 ? "0$m" : m.toString();

  String secondsLeft =
  s.toString().length < 2 ? "0$s" : s.toString();

  String result = "$hourLeft:$minuteLeft:$secondsLeft";

  return result;
}

/// Convert Datetime to readable date format
String formatDate(DateTime? dateTime){
  return dateTime != null ? DateFormat('MMM dd, kk:mm:ss').format(dateTime).ucFirst() : "";
}

/// Convert Datetime to readable time format
String formatTime(DateTime? dateTime){
  return dateTime != null ? DateFormat('kk:mm:ss').format(dateTime) : "";
}

extension CapitalizeFirst on String {
  String ucFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

