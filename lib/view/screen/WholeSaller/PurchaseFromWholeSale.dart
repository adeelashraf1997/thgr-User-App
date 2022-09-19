import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repository/auth_repo.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../helper/FirebaseCall.dart';
import '../../../helper/LocalDB.dart';
import '../../../helper/WholeRatePurchaser.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/textfield/custom_password_textfield.dart';
import '../../basewidget/textfield/custom_textfield.dart';

class PurchaseFromWholeSale extends StatefulWidget {
  const PurchaseFromWholeSale({Key key}) : super(key: key);

  @override
  State<PurchaseFromWholeSale> createState() => _PurchaseFromWholeSaleState();
}

bool apprived_as_whole_rate_purchaser = false;
//purchase price is for whole rate purchaser

class _PurchaseFromWholeSaleState extends State<PurchaseFromWholeSale> {
  var height, width;

  TextEditingController _clinicNameController = TextEditingController();
  TextEditingController _cliniTypeController = TextEditingController();
  TextEditingController _registrationNumberController = TextEditingController();
  TextEditingController _clinicTaxNoController = TextEditingController();
  String clinicImageDownloadUrl = null;
  String have_tax_number = 'yes';
  String userID;

  bool requestSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserID();
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    height = data.size.height;
    width = data.size.width;

    return SafeArea(
        child: Scaffold(
            /*appBar: AppBar(
              title: Text('Clinic info'),
              backgroundColor: Theme.of(context).primaryColor,
            ),*/
            body: ListView(
      children: [
        CustomAppBar(title: 'Clinic info'),
        Container(
          height: height,
          width: width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 10, bottom: 10),
                child: requestSubmitted
                    ? Text(
                        apprived_as_whole_rate_purchaser
                            ? "Your request approved!\n Now you can purchase on whole rate" //Your request has submitted Please wait patiently
                            : "Your request is under review, please wait untill we approve it.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: apprived_as_whole_rate_purchaser
                                ? Colors.green
                                : Colors.black),
                      )
                    : Text(
                        'Become a premium user and purchase on whole sale rate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Clinic image upload here',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getImageFromG();
                      },
                      child: Container(
                        height: height * .15,
                        width: width * 0.8,
                        margin: EdgeInsets.only(bottom: 20),
                        child: clinicImageDownloadUrl != null
                            ? Image.network(clinicImageDownloadUrl)
                            : Icon(
                                Icons.camera_alt,
                                color: Colors.grey[500],
                                size: width * 0.2,
                              ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.blueGrey[200],
                              // Set border color
                              width: 1.5), // Set border width
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT),
                child: Expanded(
                  child: CustomTextField(
                    hintText: 'Clinic Name',
                    textInputType: TextInputType.name,
                    controller: _clinicNameController,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: 'Clinic Type',
                  textInputType: TextInputType.emailAddress,
                  controller: _cliniTypeController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: 'Registration Number',
                  controller: _registrationNumberController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL,
                    bottom: 5),
                child: Column(
                  children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Do you have tax number?',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.25,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Yes',
                                groupValue: have_tax_number,
                                onChanged: (value) {
                                  setState(() {
                                    have_tax_number = value;
                                  });
                                  print(
                                      '$have_tax_number   have_tax_number  yes');
                                },
                              ),
                              Text('Yes')
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: width * 0.25,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'No',
                                groupValue: have_tax_number,
                                onChanged: (value) {
                                  setState(() {
                                    have_tax_number = value;
                                    print(
                                        '$have_tax_number  have_tax_number  No');
                                  });
                                },
                              ),
                              Text('No')
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              have_tax_number == 'Yes'
                  ? Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                          right: Dimensions.MARGIN_SIZE_DEFAULT,
                          top: Dimensions.MARGIN_SIZE_SMALL),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Clinic Tax Number',
                            controller: _clinicTaxNoController,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Accourding to the regulation of the Zakat. Tax and custom authority, the text number must be entered to issue the electronic invoice.',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                  margin: EdgeInsets.all(8),
                  child: CustomButton(
                      onTap: () async {
                        String cl_nm = _clinicNameController.text.trim();
                        String cl_tp = _cliniTypeController.text.trim();
                        String cl_reg =
                            _registrationNumberController.text.trim();
                        String cl_img = clinicImageDownloadUrl;
                        String cl_tax = _clinicTaxNoController.text.trim();
                        if (cl_img == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Image Required'),
                            backgroundColor: Colors.red,
                          ));
                        } else if (cl_nm.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Name Required'),
                            backgroundColor: Colors.red,
                          ));
                        } else if (cl_tp.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Type required'),
                            backgroundColor: Colors.red,
                          ));
                        } else if (cl_reg.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Registration number required '),
                            backgroundColor: Colors.red,
                          ));
                        } else if (have_tax_number == 'Yes' && cl_tax.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Tax number required '),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          //upload here...
                          WholeRatePurchaser purchaser = WholeRatePurchaser(
                              approved: false,
                              clinicName: cl_nm,
                              clinicType: cl_tp,
                              clinicRegisterationNumber: cl_reg,
                              clinicTaxNumber: have_tax_number == 'yes'
                                  ? cl_tax
                                  : 'Not tax paying',
                              clinicImage: cl_img,
                              key: userID == null ? 'GuestUser' : userID);

                          FirebaseCall.setWholeRatePurchaser(purchaser)
                              .then((value) => {
                                    if (value == null)
                                      {
                                        setState(() {
                                          requestSubmitted = true;
                                        }),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Sent successfully ${userID}'),
                                                //}
                                                backgroundColor: Colors.green)),
                                        LocalDB.setWholeRatePurchaser(
                                            purchaser),
                                        //LocalDB.getWholeRatePurchaser(),
                                      }
                                    else
                                      {
                                        setState(() {
                                          requestSubmitted = true;
                                        }),
                                      }
                                  });
                        }
                      },
                      buttonText: 'Submit')),
            ],
          ),
        ),
      ],
    )));
  }

  Future getImageFromG() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    print('image picked $image');
    if (image != null) {
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      setState(() {
        //imageFile = image.path;
        //alldata.add(imageFile);
        //state = AppState.picked;
      });
      print('image1    ${image.path}');
      uploadImageToFirebase(image.path); //image.path
    }
  }

  uploadImageToFirebase(String image_path) async {
    FirebaseCall.uploadPic(image_path, userID == null ? "GuestUser" : userID)
        .then((value) => {
              print('download url is here $value'),
              if (value != null)
                {
                  setState(() {
                    clinicImageDownloadUrl = value;
                  })
                }
            });
  }

  void getUserID() async
  {

    //print('kkkkkkkkkkkkkkkkkkkkkkkk    ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id} ');
    userID=Provider.of<ProfileProvider>(context, listen: false).userInfoModel.name;
    //userID = Provider.of<ProfileProvider>(context, listen: false).profileRepo.dioClient.sharedPreferences.get(AppConstants.USER_ID);
    print('user idlllllll    $userID');
    setState(() {
      userID;
    });
  }

  void setData() async {
    WholeRatePurchaser purchaser = await LocalDB.getWholeRatePurchaser();
    if (purchaser != null) {
      setState(() {
        _registrationNumberController.text =
            purchaser.clinicRegisterationNumber;
        clinicImageDownloadUrl = purchaser.clinicImage;
        _clinicNameController.text = purchaser.clinicName;
        _cliniTypeController.text = purchaser.clinicType;
        _registrationNumberController.text =
            purchaser.clinicRegisterationNumber;
        _clinicTaxNoController.text = purchaser.clinicTaxNumber;
        apprived_as_whole_rate_purchaser = false;
        requestSubmitted = true;
      });
    } else {
      requestSubmitted = false;
    }
  }
}
