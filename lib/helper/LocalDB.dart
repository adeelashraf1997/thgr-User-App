import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/WholeSaller/PurchaseFromWholeSale.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'WholeRatePurchaser.dart';

class LocalDB {
  static const String _WholeRatePurchaser = 'WholeRatePurchaser';

  static Future setWholeRatePurchaser(WholeRatePurchaser regons) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${regons.toJson().toString()}');
      prefs.setString(_WholeRatePurchaser, jsonEncode(regons));
      //print("new  saved");
      //print(regons);
      return true;
    } catch (e) {
      print("all WholeRatePurchaser  saving error $e.toString()");
      return null;
    }
  }

  static Future getWholeRatePurchaser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String value = prefs.getString(_WholeRatePurchaser);
      //json.encode();
      // print('decode successfullywwwwwwwwwwww    ${json.decode(value)}');
      WholeRatePurchaser purchaser =
          WholeRatePurchaser.fromJson(json.decode(value));
      //print('decode successfully    ${purchaser.clinicName}');
      //print(purchaser);
      return purchaser; // sending back as a map
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
