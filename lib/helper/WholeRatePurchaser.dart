import 'package:flutter/material.dart';

class WholeRatePurchaser{
  String clinicName;
  String clinicType;
  String clinicRegisterationNumber;
  String clinicTaxNumber;
  String clinicImage;
  String key;
  bool approved;

  WholeRatePurchaser({this.approved,this.clinicName,this.clinicType,this.clinicRegisterationNumber,this.clinicTaxNumber,this.clinicImage,this.key});

  WholeRatePurchaser.fromJson(Map<String, dynamic> json) {
    clinicName = json['clinicName'];
    clinicType = json['clinicType'];
    clinicRegisterationNumber = json['clinicRegisterationNumber'];
    clinicTaxNumber = json['clinicTaxNumber'];
    clinicImage = json['clinicImage'];
    approved = json['approved'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicName'] = this.clinicName;
    data['clinicType'] = this.clinicType;
    data['clinicRegisterationNumber'] = this.clinicRegisterationNumber;
    data['clinicTaxNumber'] = this.clinicTaxNumber;
    data['clinicImage'] = this.clinicImage;
    data['approved'] = this.approved;
    data['key'] = this.key;
    return data;
  }

}