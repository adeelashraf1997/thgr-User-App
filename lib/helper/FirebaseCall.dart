import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'LocalDB.dart';
import 'WholeRatePurchaser.dart';

class FirebaseCall {
  // static StorageReference firebaseStorage_pics = FirebaseStorage.instance.ref();
  static DatabaseReference ref_whole_rate_purchaser =
      FirebaseDatabase.instance.ref("WholeRatePurchaser");

  static Future<String> uploadPic(String _image1, String userid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url;
    final _imageFile = File(_image1);
    Reference ref =
        storage.ref().child(userid).child("image" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_imageFile);

    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
      print('image uploading completed...${url}');
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  static Future setWholeRatePurchaser(WholeRatePurchaser purchaser) async {
    try {
      await ref_whole_rate_purchaser
          .child(purchaser.key)
          .set(purchaser.toJson());
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  static Future getAllWholeSaleRequest() async {
    ref_whole_rate_purchaser.once();
    ref_whole_rate_purchaser.onValue.listen((value) {
      if (value.snapshot != null) {
        Map data = (value.snapshot.value as Map);
        print('date of items are ');
        print(data.toString());
        LocalDB.setWholeRatePurchaser(WholeRatePurchaser.fromJson(data));
      } else {
        return null;
        //LocalDatabase.setMYNewBorns(0.toString());
      }
    });
  }
}
