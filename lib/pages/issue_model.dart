import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_app/core/models/device_info.dart';
import 'package:case_app/core/ui_components/info_widget.dart';
import 'package:case_app/models/case.dart';
import 'package:case_app/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Issue extends StatefulWidget {
  final String issueId;
  final String ownerId;
  final String issue;
  final String fullAddress;
  final String resType;
  final String city;
  final String phone;
  final String fullName;
  final String fireType;
  final String firePlace;
  final String injuryCount;
  final String injuryType;

  Issue(
      {this.issueId,
      this.ownerId,
      this.issue,
      this.city,
      this.fullAddress,
      this.resType,
      this.phone,
      this.fullName,
      this.fireType,
      this.firePlace,
      this.injuryCount,
      this.injuryType});

  factory Issue.fromDoc(DocumentSnapshot doc) {
    return Issue(
      issueId: doc['issueId'],
      ownerId: doc['ownerId'],
      issue: doc['issue'],
      fullAddress: doc['fullAddress'],
      resType: doc['resType'],
      phone: doc['phone'],
      city: doc['city'],
      fullName: doc['fullName'],
      fireType: doc['fireType'],
      firePlace: doc['firePlace'],
      injuryCount: doc['injuryCount'],
      injuryType: doc['injuryType'],
    );
  }

  @override
  _IssueState createState() => _IssueState(
        issueId: this.issueId,
        ownerId: this.ownerId,
        issue: this.issue,
        fullAddress: this.fullAddress,
        resType: this.resType,
        phone: this.phone,
        fullName: this.fullName,
        city: this.city,
        fireType: this.fireType,
        firePlace: this.firePlace,
        injuryCount: this.injuryCount,
        injuryType: this.injuryType,
      );
}

class _IssueState extends State<Issue> {
  final String issueId;
  final String ownerId;
  final String issue;
  final String fullAddress;
  final String resType;
  final String city;
  final String phone;
  final String fullName;
  final String fireType;
  final String firePlace;
  final String injuryCount;
  final String injuryType;

  _IssueState(
      {this.issueId,
      this.ownerId,
      this.issue,
      this.fullAddress,
      this.resType,
      this.phone,
      this.fullName,
      this.city,
      this.fireType,
      this.firePlace,
      this.injuryCount,
      this.injuryType});

  buildIssueTop(DeviceInfo infoWidget) {
    return FutureBuilder(
      future: caseRef.document(ownerId).get(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return SizedBox();
        }
        Case caseA = Case.fromDocument(snapShot.data);
        return Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: infoWidget.screenWidth * 0.18 //
                  ,
                  height: infoWidget.screenWidth * 0.18,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      caseA.photoUrl,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'الاسم: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$fullName',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'رقم الهاتف: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$phone',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'القضية: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$issue',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'المدينه: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$city',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'العنوان بالكامل: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$fullAddress',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'نوع الانقاذ: ',
                        style:
                            infoWidget.titleButton.copyWith(color: Colors.red),
                      ),
                      Text(
                        '$resType',
                        style: infoWidget.subTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, infoWidget) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildIssueTop(infoWidget),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
