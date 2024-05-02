import 'package:appointment_views/kaizenControls/Medcolors.dart';
import 'package:flutter/material.dart';

class MedTextStyles {
  static TextStyle headerFontStyle() {
    return TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  }

  static TextStyle cardInnerFontStyle() {
    return TextStyle(fontSize: 13);
  }

  static TextStyle dropDownFontStyle() {
    return TextStyle(fontSize: 14);
  }

  static TextStyle cardTitleTextStyle() {
    return TextStyle(
        fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white);
  }

  static TextStyle cardDetailsTextStyle() {
    return TextStyle(fontSize: 14);
  }

  static TextStyle buttonContentStyle(Color fntcolor) {
    return TextStyle(
        fontSize: 20, color: fntcolor, fontWeight: FontWeight.w400);
  }

  static TextStyle pageSubheadingBoldFontStyle(Color fntcolor) {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: fntcolor);
  }

  static TextStyle pageSubheadingFontStyle(Color fntcolor) {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: fntcolor);
  }

  static TextStyle LargeFontStyle(Color fntcolor) {
    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.w400, color: fntcolor);
  }

  static TextStyle sourceSansPro() {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  }

  static TextStyle pageHeaderStyle() {
    return TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
  }

  static TextStyle normalDescriptionStyle() {
    return TextStyle(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);
  }

  static TextStyle buttonTextStyle() {
    return TextStyle(
        fontSize: 16, color: Medicolor.color1, fontWeight: FontWeight.w400);
  }
}
