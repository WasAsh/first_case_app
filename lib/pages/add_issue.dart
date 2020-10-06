import 'package:case_app/core/models/device_info.dart';
import 'package:case_app/core/ui_components/info_widget.dart';
import 'package:case_app/models/case.dart';
import 'package:case_app/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddIssue extends StatefulWidget {
  final Case currentCase;

  AddIssue({this.currentCase});

  @override
  _AddIssueState createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  final GlobalKey<FormState> fireKey = GlobalKey<FormState>();
  final GlobalKey<FormState> ambulanceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> policeKey = GlobalKey<FormState>();
  TextEditingController issueController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController injuryTypeController = TextEditingController();

  TextEditingController injuryCountController = TextEditingController();

  TextEditingController fireTypeController = TextEditingController();

  TextEditingController firePlaceController = TextEditingController();

  List<String> rescueTypeItems = <String>['شرطي', 'مسعف', 'رجل اطفاء'];
  var selectedRescue;
  String issueId = Uuid().v4();
  String issueId2 = Uuid().v4() ;
  String cityVal ;
  var cities = [
    "طرابلس",
    "بنغازي",
    "مصراتة",
    "الزاوية",
    "زليتن",
    "البيضاء",
    "اجدابيا",
    "غريان",
    "طبرق",
    "صبراتة",
    "سبها",
    "الخمس",
    "درنة",
    "سرت",
    'القبة',
    'الجميل',
    'يفرن',
    'صرمان',
    'غير ذلك',
  ];
  void citySelected(String val) {
    setState(() {
      cityVal = val;
    });
  }

  // for police issue
  createPoliceIssueInFireStore(
      {String issue,
      String fullAddress,
      String resType,
      String fullName,
      String phone,
      String city}) {
    issueRef.document(issueId).setData({
      'issueId': issueId,
      'ownerId': widget.currentCase.id,
      'fullName': fullName,
      'phone': phone,
      'issue': issue,
      'city': city,
      'fullAddress': fullAddress,
      'resType': resType,
      'fireType': null,
      'firePlace': null,
      'injuryCount': null,
      'injuryType': null,
      'timestamp': DateTime.now(),
    });
  }

  submitPoliceIssue() async {
    if (policeKey.currentState.validate()) {
      policeKey.currentState.save();
      await createPoliceIssueInFireStore(
        fullName: fullNameController.text,
        phone: phoneNumController.text,
        city: cityVal,
        issue: issueController.text,
        fullAddress: fullAddressController.text,
        resType: 'شرطي',
      );
      // fullNameController.clear();
      // phoneNumController.clear();
      // cityController.clear();
      // issueController.clear();
      // fullAddressController.clear();
      setState(() {
        issueId = Uuid().v4();
      });
    }
  }

  //for ambulance issue
  createAmbulanceIssueInFireStore(
      {String injuryType,
      String injuryCount,
      String issue,
      String fullAddress,
      String resType,
      String fullName,
      String phone,
      String city}) {
    issueRef.document(issueId).setData({
      'issueId': issueId,
      'ownerId': widget.currentCase.id,
      'fullName': fullName,
      'phone': phone,
      'issue': issue,
      'city': city,
      'fullAddress': fullAddress,
      'resType': resType,
      'fireType': null,
      'firePlace': null,
      'injuryCount': injuryCount,
      'injuryType': injuryType,
      'timestamp': DateTime.now(),
    });
  }

  submitAmbulanceIssue() async {
    if (ambulanceKey.currentState.validate()) {
      ambulanceKey.currentState.save();
      await createAmbulanceIssueInFireStore(
        injuryType: injuryTypeController.text,
        injuryCount: injuryCountController.text,
        fullName: fullNameController.text,
        phone: phoneNumController.text,
        city: cityVal,
        issue: issueController.text,
        fullAddress: fullAddressController.text,
        resType: 'مسعف',
      );
      // injuryCountController.clear();
      // injuryTypeController.clear();
      // fullNameController.clear();
      // phoneNumController.clear();
      // cityController.clear();
      // issueController.clear();
      // fullAddressController.clear();
      setState(() {
        issueId = Uuid().v4();
      });
    }
  }

  //for fire issue
  createFireIssueInFireStore(
      {String fireType,
      String firePlace,
      String issue,
      String fullAddress,
      String resType,
      String fullName,
      String phone,
      String city}) {
    issueRef.document(issueId).setData({
      'issueId': issueId,
      'ownerId': widget.currentCase.id,
      'fullName': fullName,
      'phone': phone,
      'issue': issue,
      'city': city,
      'fullAddress': fullAddress,
      'resType': resType,
      'fireType': fireType,
      'firePlace': firePlace,
      'injuryCount': null,
      'injuryType': null,
      'timestamp': DateTime.now(),
    });
  }

  submitFireIssue() async {
    if (fireKey.currentState.validate()) {
      fireKey.currentState.save();
      await createFireIssueInFireStore(
        fireType: fireTypeController.text,
        firePlace: firePlaceController.text,
        fullName: fullNameController.text,
        phone: phoneNumController.text,
        city: cityVal,
        issue: issueController.text,
        fullAddress: fullAddressController.text,
        resType: 'رجل اطفاء',
      );
      // fireTypeController.clear();
      // firePlaceController.clear();
      // fullNameController.clear();
      // phoneNumController.clear();
      // cityController.clear();
      // issueController.clear();
      // fullAddressController.clear();
      setState(() {
        issueId = Uuid().v4();
      });
    }
  }

  policeIssue(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.grey,
        barrierLabel: 'Police Issue',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'قم بملئ النموذج',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Form(
                  key: policeKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: 'الاسم بالكامل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال الاسم بالكامل';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: phoneNumController,
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال رقم الهاتف';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        isDense: true ,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          labelText: "قام باختيار المدينة",
                          fillColor: Colors.grey,
                        ),
                        onChanged: citySelected,
                        value: cityVal,
                          items: cities.map((String cities) {
                            return DropdownMenuItem<String>(
                                value: cities,
                                child: Row(
                                  children: <Widget>[
                                    Text("  $cities"),
                                  ],
                                ));
                          }).toList()
                      ),
                      // TextFormField(
                      //   controller: cityController,
                      //   decoration: InputDecoration(
                      //     hintText: 'المدينة',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(2),
                      //     ),
                      //   ),
                      //   // ignore: missing_return
                      //   validator: (val) {
                      //     if (val.trim().isEmpty) {
                      //       return 'قم بادخال المدينه';
                      //     }
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: fullAddressController,
                        decoration: InputDecoration(
                          hintText: 'العنوان بالتفصيل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال العنوان بالتفصيل';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: issueController,
                        decoration: InputDecoration(
                          hintText: 'اشرح الموقف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'نوع الانقاذ : ' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                          Text(
                            'شرطي' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: submitPoliceIssue,
                        child: Text(
                          'تأكيد',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'اذا كنت تود ارسال الطلب لجهة أخرى , من فضلك قم بتأكيد الطلب أولاً واختيار الجهة االثانية المراد الارسال لها من الخيارين أدناه' ,
                        textAlign: TextAlign.center,
                        style: infoWidget.subTitle,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              builder: (context){
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                      infoWidget.screenHeight *
                                          0.85),
                                  child: Column(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 25),
                                        child: Center(
                                          child: Text(
                                              'اضافة البيانات التفصيلية',
                                              textDirection: TextDirection.rtl,
                                              style: infoWidget
                                                  .titleButton
                                                  .copyWith(
                                                  color:
                                                  Colors.red)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'عدد الاصابات',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: injuryCountController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'نوع الاصابات',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: injuryTypeController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'نوع الانقاذ : ' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                            Text(
                                              'مسعف' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          onPressed: (){
                                            issueRef.document(issueId).setData({
                                              'issueId': issueId,
                                              'ownerId': widget.currentCase.id,
                                              'fullName': fullNameController.text,
                                              'phone': phoneNumController.text,
                                              'issue': issueController.text,
                                              'city': cityVal,
                                              'fullAddress': fullAddressController.text,
                                              'resType': 'مسعف',
                                              'fireType': null,
                                              'firePlace': null,
                                              'injuryCount': injuryCountController.text,
                                              'injuryType': injuryTypeController.text,
                                              'timestamp': DateTime.now(),
                                            });
                                            injuryCountController.clear();
                                            injuryTypeController.clear() ;
                                          } ,
                                          child: Text(
                                            'تأكيد',
                                            style: infoWidget.titleButton,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Text(
                          'ارسال للأسعاف',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              builder: (context){
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                      infoWidget.screenHeight *
                                          0.85),
                                  child: Column(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 25),
                                        child: Center(
                                          child: Text(
                                              'اضافة البيانات التفصيلية',
                                              textDirection: TextDirection.rtl,
                                              style: infoWidget
                                                  .titleButton
                                                  .copyWith(
                                                  color:
                                                  Colors.red)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'نوع الحريق',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: fireTypeController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'مكان الحريق',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: firePlaceController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'نوع الانقاذ : ' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                            Text(
                                              'رجل اطفاء' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          onPressed: (){
                                            issueRef.document(issueId2).setData({
                                              'issueId': issueId2,
                                              'ownerId': widget.currentCase.id,
                                              'fullName': fullNameController.text,
                                              'phone': phoneNumController.text,
                                              'issue': issueController.text,
                                              'city': cityVal,
                                              'fullAddress': fullAddressController.text,
                                              'resType': 'رجل اطفاء',
                                              'fireType': fireTypeController.text,
                                              'firePlace': firePlaceController.text,
                                              'injuryCount': null,
                                              'injuryType': null,
                                              'timestamp': DateTime.now(),
                                            });
                                            fireTypeController.clear();
                                            firePlaceController.clear() ;
                                          } ,
                                          child: Text(
                                            'تأكيد',
                                            style: infoWidget.titleButton,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Text(
                          'ارسال لرجال الاطفاء',
                          style: infoWidget.titleButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).whenComplete(() => {
          fullNameController.clear() ,
      fullAddressController.clear() ,
      issueController.clear(),
      phoneNumController.clear(),
    });
  }

  ambulanceIssue(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.grey,
        barrierLabel: 'Ambulance Issue',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'قم بملئ النموذج',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Form(
                  key: ambulanceKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: injuryTypeController,
                        decoration: InputDecoration(
                          hintText: 'نوع الاصابة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: injuryCountController,
                        decoration: InputDecoration(
                          hintText: 'عدد الاصابات',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال عدد الاصابات';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: 'الاسم كاملاً',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال الاسم';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: phoneNumController,
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال رقم الهاتف';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                          isDense: true ,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "قام باختيار المدينة",
                            fillColor: Colors.grey,
                          ),
                          onChanged: citySelected,
                          value: cityVal,
                          items: cities.map((String cities) {
                            return DropdownMenuItem<String>(
                                value: cities,
                                child: Row(
                                  children: <Widget>[
                                    Text("  $cities"),
                                  ],
                                ));
                          }).toList()
                      ),
                      // TextFormField(
                      //   controller: cityController,
                      //   decoration: InputDecoration(
                      //     hintText: 'المدينة',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(2),
                      //     ),
                      //   ),
                      //   // ignore: missing_return
                      //   validator: (val) {
                      //     if (val.trim().isEmpty) {
                      //       return 'قم بادخال المدينه';
                      //     }
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: fullAddressController,
                        decoration: InputDecoration(
                          hintText: 'العنوان بالكامل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال العنوان بالكامل';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: issueController,
                        decoration: InputDecoration(
                          hintText: 'اشرح الموقف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'نوع الانقاذ : ' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                          Text(
                            'مسعف' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: submitAmbulanceIssue,
                        child: Text(
                          'تأكيد',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'اذا كنت تود ارسال الطلب لجهة أخرى , من فضلك قم بتأكيد الطلب أولاً واختيار الجهة االثانية المراد الارسال لها من الخيارين أدناه' ,
                        textAlign: TextAlign.center,
                        style: infoWidget.subTitle,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          issueRef.document(issueId).setData({
                            'issueId': issueId,
                            'ownerId': widget.currentCase.id,
                            'fullName': fullNameController.text,
                            'phone': phoneNumController.text,
                            'issue': issueController.text,
                            'city': cityVal,
                            'fullAddress': fullAddressController.text,
                            'resType': 'شرطي',
                            'fireType': null,
                            'firePlace': null,
                            'injuryCount': null,
                            'injuryType': null,
                            'timestamp': DateTime.now(),
                          });
                        },
                        child: Text(
                          'ارسال للشرطة',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              builder: (context){
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                      infoWidget.screenHeight *
                                          0.85),
                                  child: Column(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 25),
                                        child: Center(
                                          child: Text(
                                              'اضافة البيانات التفصيلية',
                                              textDirection: TextDirection.rtl,
                                              style: infoWidget
                                                  .titleButton
                                                  .copyWith(
                                                  color:
                                                  Colors.red)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'نوع الحريق',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: fireTypeController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'مكان الحريق',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: firePlaceController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'نوع الانقاذ : ' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                            Text(
                                              'رجل اطفاء' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          onPressed: (){
                                            issueRef.document(issueId2).setData({
                                              'issueId': issueId,
                                              'ownerId': widget.currentCase.id,
                                              'fullName': fullNameController.text,
                                              'phone': phoneNumController.text,
                                              'issue': issueController.text,
                                              'city': cityVal,
                                              'fullAddress': fullAddressController.text,
                                              'resType': 'رجل اطفاء',
                                              'fireType': fireTypeController.text,
                                              'firePlace': firePlaceController.text,
                                              'injuryCount': injuryCountController.text,
                                              'injuryType': injuryTypeController.text,
                                              'timestamp': DateTime.now(),
                                            });
                                            fireTypeController.clear();
                                            firePlaceController.clear() ;
                                          } ,
                                          child: Text(
                                            'تأكيد',
                                            style: infoWidget.titleButton,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Text(
                          'ارسال لرجال الاطفاء',
                          style: infoWidget.titleButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        ).whenComplete(() => {
      fullNameController.clear() ,
      fullAddressController.clear() ,
      issueController.clear(),
      phoneNumController.clear(),
      injuryTypeController.clear(),
      injuryCountController.clear(),
    });
  }

  fireIssue(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.grey,
        barrierLabel: 'Fire Issue',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'قم بملئ النموذج',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Form(
                  key: fireKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: fireTypeController,
                        decoration: InputDecoration(
                          hintText: 'نوع الحريق',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال نوع الحريق';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: firePlaceController,
                        decoration: InputDecoration(
                          hintText: 'مكان الحريق',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال مكان الحريق';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: 'الاسم كاملاً',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال الاسم';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: phoneNumController,
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال رقم الهاتف';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                          isDense: true ,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "قام باختيار المدينة",
                            fillColor: Colors.grey,
                          ),
                          onChanged: citySelected,
                          value: cityVal,
                          items: cities.map((String cities) {
                            return DropdownMenuItem<String>(
                                value: cities,
                                child: Row(
                                  children: <Widget>[
                                    Text("  $cities"),
                                  ],
                                ));
                          }).toList()
                      ),
                      // TextFormField(
                      //   autofocus: false,
                      //   controller: cityController,
                      //   decoration: InputDecoration(
                      //     hintText: 'المدينة',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(2),
                      //     ),
                      //   ),
                      //   // ignore: missing_return
                      //   validator: (val) {
                      //     if (val.trim().isEmpty) {
                      //       return 'قم بادخال المدينه';
                      //     }
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: fullAddressController,
                        decoration: InputDecoration(
                          hintText: 'العنوان كاملاً',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // ignore: missing_return
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'قم بادخال العنوان';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: issueController,
                        decoration: InputDecoration(
                          hintText: 'اشرح الموقف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'نوع الانقاذ : ' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                          Text(
                            'رجل اطفاء' ,
                            textAlign: TextAlign.center,
                            style: infoWidget.subTitle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: submitFireIssue,
                        child: Text(
                          'تأكيد',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'اذا كنت تود ارسال الطلب لجهة أخرى , من فضلك قم بتأكيد الطلب أولاً واختيار الجهة االثانية المراد الارسال لها من الخيارين أدناه' ,
                        textAlign: TextAlign.center,
                        style: infoWidget.subTitle,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          issueRef.document(issueId).setData({
                            'issueId': issueId,
                            'ownerId': widget.currentCase.id,
                            'fullName': fullNameController.text,
                            'phone': phoneNumController.text,
                            'issue': issueController.text,
                            'city': cityVal,
                            'fullAddress': fullAddressController.text,
                            'resType': 'شرطي',
                            'fireType': null,
                            'firePlace': null,
                            'injuryCount': null,
                            'injuryType': null,
                            'timestamp': DateTime.now(),
                          });
                        },
                        child: Text(
                          'ارسال للشرطة',
                          style: infoWidget.titleButton,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: (){
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              builder: (context){
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                      infoWidget.screenHeight *
                                          0.85),
                                  child: Column(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 25),
                                        child: Center(
                                          child: Text(
                                              'اضافة البيانات التفصيلية',
                                              textDirection: TextDirection.rtl,
                                              style: infoWidget
                                                  .titleButton
                                                  .copyWith(
                                                  color:
                                                  Colors.red)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'عدد الاصابات',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: injuryCountController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            border:
                                            OutlineInputBorder(),
                                            labelText: 'نوع الاصابات',
                                            labelStyle:
                                            TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          controller: injuryTypeController,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'نوع الانقاذ : ' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                            Text(
                                              'مسعف' ,
                                              textAlign: TextAlign.center,
                                              style: infoWidget.subTitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          onPressed: (){
                                            issueRef.document(issueId2).setData({
                                              'issueId': issueId,
                                              'ownerId': widget.currentCase.id,
                                              'fullName': fullNameController.text,
                                              'phone': phoneNumController.text,
                                              'issue': issueController.text,
                                              'city': cityVal,
                                              'fullAddress': fullAddressController.text,
                                              'resType': 'مسعف',
                                              'fireType': fireTypeController.text,
                                              'firePlace': firePlaceController.text,
                                              'injuryCount': injuryCountController.text,
                                              'injuryType': injuryTypeController.text,
                                              'timestamp': DateTime.now(),
                                            });
                                            injuryCountController.clear();
                                            injuryTypeController.clear() ;
                                          } ,
                                          child: Text(
                                            'تأكيد',
                                            style: infoWidget.titleButton,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Text(
                          'ارسال لرجال الاسعاف',
                          style: infoWidget.titleButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).whenComplete(() => {
      fullNameController.clear() ,
      fullAddressController.clear() ,
      issueController.clear(),
      phoneNumController.clear(),
      firePlaceController.clear(),
      fireTypeController.clear(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InfoWidget(
        builder: (context, infoWidget) => Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 4, right: 4),
          child: ListView(
            children: <Widget>[
              /*Text('مرحباً بك :',
                  textAlign: TextAlign.center, style: infoWidget.title),
              Text(
                  'عزيزي المواطن , قم بالتعرف على مبادئ الاسعاف الأولي بشكل عام والتي تنص على:',
                  textAlign: TextAlign.center,
                  style: infoWidget.subTitle),*/
              Padding(
                padding: EdgeInsets.only(top: 8, right: 4, left: 4),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child:
                                Text('أولاً: السيطرة على موقع الحدث بشكل تام',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.none,
                                    )),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Text(
                                'ثانياُ: عدم اعتبار الشخص المصاب ميتاً حتى وان زالت مظاهر الحياة عن كالتنفس والنبض',
                                style: infoWidget.subTitle.copyWith(
                                  color: Colors.grey,
                                  decoration: TextDecoration.none,
                                )),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child:
                                Text('ثالثاً: ابعاد الشخص المصاب عن مصدر الخطر',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.none,
                                    )),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Text(
                                'رابعاً: الاهتمام بعملية انعاش القلب وعملية التنفس الاصطناعي والصدمة',
                                style: infoWidget.subTitle.copyWith(
                                  color: Colors.grey,
                                  decoration: TextDecoration.none,
                                )),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Text(
                                'خامساً: العناية بالشخص المصاب قبل وصول الجهات المعنية',
                                style: infoWidget.subTitle.copyWith(
                                  color: Colors.grey,
                                  decoration: TextDecoration.none,
                                )),
                          ),
                        ),
                        SizedBox()
                      ],
                    ),
                  ],
                ),*/
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Text('من فضلك قم باختيار نوع طلب البلاغ المراد تقديمه:',
                    textAlign: TextAlign.center,
                    style: infoWidget.title.copyWith(color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      policeIssue(infoWidget);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.red,
                    child: Text(
                      'طلب شرطة',
                      style: infoWidget.titleButton,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      ambulanceIssue(infoWidget);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.red,
                    child: Text(
                      'طلب اسعاف',
                      style: infoWidget.titleButton,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      fireIssue(infoWidget);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.red,
                    child: Text(
                      'طلب حريق',
                      style: infoWidget.titleButton,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
