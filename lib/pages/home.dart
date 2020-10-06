import 'dart:async';
import 'package:case_app/core/models/device_info.dart';
import 'package:case_app/core/ui_components/info_widget.dart';
import 'package:case_app/models/case.dart';
import 'package:case_app/pages/add_issue.dart';
import 'package:case_app/pages/my_issue.dart';
import 'package:case_app/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final caseRef = Firestore.instance.collection('case');
final issueRef = Firestore.instance.collection('issues');

final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timeStamp = DateTime.now();
Case currentCase;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> mainKey = GlobalKey<ScaffoldState>();
  List<String> type = ['الرئيسية', 'اضافه طلب', 'طلباتى'];
  PageController _pageController;
  bool isAuth = false;
  bool isLoading = true;
  int pageIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String phone, fullName;

  //ensure that user signed in or not
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //1
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print('Error is $err');
    });
    //2
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      print('Error is $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFireStore();
      setState(() {
        isAuth = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  signOut() {
    googleSignIn.signOut();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _iconNavBar({IconData iconPath, String title, DeviceInfo infoWidget}) {
    return title == null
        ? Icon(
            iconPath,
            color: Colors.white,
          )
        : Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: <Widget>[
                Icon(
                  iconPath,
                  color: Colors.white,
                ),
                title == null
                    ? SizedBox()
                    : Text(
                        title,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? MediaQuery.of(context).size.width * 0.035
                                : MediaQuery.of(context).size.width * 0.024,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
              ],
            ),
          );
  }

  Widget _drawerListTile(
      {String name,
      IconData icon = Icons.settings,
      String imgPath,
      bool isIcon = false,
      DeviceInfo infoWidget,
      Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        dense: true,
        title: Text(
          name,
          style: infoWidget.titleButton.copyWith(color: Colors.red),
        ),
        leading: isIcon
            ? Icon(
                icon,
                color: Colors.red,
              )
            : Image.asset(
                imgPath,
                color: Colors.red,
              ),
      ),
    );
  }

  //create user in firestore
  createUserInFireStore() async {
    final GoogleSignInAccount caseA = googleSignIn.currentUser;
    DocumentSnapshot doc = await caseRef.document(caseA.id).get();

    if (!doc.exists) {
//      await Navigator.push(context , MaterialPageRoute(builder: (context) => CreateAccount()));
      caseRef.document(caseA.id).setData({
        'id': caseA.id,
        'displayName': caseA.displayName,
        'fullName': null,
        'photoUrl': caseA.photoUrl,
        'email': caseA.email,
        'phone': null,
        'timeStamp': timeStamp,
      });
      doc = await caseRef.document(caseA.id).get();
    }
    currentCase = Case.fromDocument(doc);
    print(currentCase.email);
  }

  //handle page changing
  onPageChanged(int index) {
    setState(() {
      this.pageIndex = index;
    });
  }

  onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  //offline info
  offlinePoliceInfo(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.white,
        barrierLabel: 'معلومات الشرطة',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'حالات تستدعى الشرطة',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.asset('img/police.jpg',
                          height: 200, fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'و يجب التواصل مع الشرطة عندما يكون لديك قضية غير طارئة لدى الشرطة، مثلاً تقديم بلاغ أو إعطاء معلومات عن جريمة، أو تريد الحصول على معلومات عن جواز السفر، أو أسئلة عن رخصة. تعمل الشرطة على خدمة المجتمع عن طريق اقامة دوريات في الشوارع لمنع قوع الجرائم،والمحاولة في مساعدة الاشخاص الذين يواجهون صعوبات معينة,وتُستدعَى الشرطة لفك الخلافات والبحث عن المطلوبين وكذلك تقديم المساعدة والعون لاصحاب الحوادث و الفيضانات والحرائق والكوارث بتأمين المسكن والمواصلات والبحث عن المفقودين',
                      style: infoWidget.subTitle,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  offlineRiskInfo(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.white,
        barrierLabel: 'معلومات الكوارث',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'التعامل مع الكوراث',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.asset('img/risk.jpg',
                          height: 150, fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, right: 4, left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'في حالة حدوث حالة طارئة ، هذا دليل موجز لفهم الخطوات الخمس الرئيسية لضمان مساعدة ملموسة ، حتى لو لم تكن مسعفين.',
                            style: infoWidget.titleButton
                                .copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'أهم شيء يمكنك القيام به هو الحفاظ على الهدوء والبقاء في السيطرة على الموقف. في بعض الأحيان لا يوجد شيء يمكن أن يفعله المارة ، وهذا جيد. لا تقلق بشأن الاعتراف بأنه لا يوجد شيء يمكنك القيام به للمساعدة.',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'يمكن أن يؤدي التواجد في حالة الطوارئ إلى تفكير مذعور والإجراءات يمكن أن تكشف عن نتائج كارثية. بدلًا من الرد على الموقف فورًا ، خذ وقتًا لتهدأ. تنفس بعمق قبل اتخاذ أي إجراء.',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'يجب أن تحتوي مجموعة الإسعافات الأولية على أدوات طوارئ مفيدة لرعاية العديد من حالات الطوارئ الطبية. يجب أن تحتوي أي مجموعة إسعافات أولية على ضمادات وشاش وشريط لاصق ومطهر وعناصر مفيدة أخرى.',
                                    //textAlign: TextAlign.end,
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'من المهم فهم الحالة العقلية للمريض من أجل فهم نوع الإصابات بشكل أفضل. إذا كان الشخص مرتبكًا بالأسئلة أو قدم إجابة خاطئة ، فقد يشير ذلك إلى إصابات إضافية غير تلك الجسدية.',
                                    //textAlign: TextAlign.end,
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'يجب أن يكون انتباهك الكامل على الوضع الحالي ، والتحدث على الهاتف يشتت انتباهك. بالإضافة إلى ذلك ، إذا كنت تستخدم هاتفًا قديمًا ، فقد يحاول مرسل الطوارئ الاتصال بك. ابق على الهاتف ما لم تتصل لطلب المساعدة.',
                                    //textAlign: TextAlign.end,
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  offlineFireInfo(DeviceInfo infoWidget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.white,
        barrierLabel: 'معلومات الكوارث',
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'ارشادات الحرائق',
                  style: infoWidget.titleButton,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.asset('img/fire.jpg',
                          height: 150, fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, right: 4, left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'يغفل معظم ساكنى العقارات عن كيفية التعامل مع الحريق فى حالة اندلاعه داخل الشقق السكنية والمنشآت، ولا يوجد لديهم الدراية الكافية فى كيفية التعامل مع النيران، ومن تلك الطرق:',
                                    style: infoWidget.titleButton
                                        .copyWith(color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('أولاً: يجب فصل الغاز عن المكان.',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'ثانياُ: احرص على وضع مواد الملابس في أسفل الأبواب إذا كنت محاصراً وتعليق ورقة أو بطانية خارج النوافذ',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ثالثاً: الزحف منخفضاً تحت الدخان',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'رابعاً: ضع نقطة اجتماع محددة مسبقًا ، خارج منزلك ، مثل منزل الجيران',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'خامساً: في حريق شاهق ، لا تستخدم المصاعد مطلقًا. استخدم الدرج فقط',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'سادساً: بمجرد الخروج ، ابق خارجا ولا تدخل المكان المحروق مهما كان السبب',
                                    style: infoWidget.subTitle.copyWith(
                                      color: Colors.blueGrey,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                            ),
                            SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//
//  //draw widgets
//  Scaffold buildAuthScreen(){
//    return Scaffold(
//      body: PageView(
//        children: <Widget>[
//
//        ],
//        //controller: pageViewController,
//        onPageChanged: onPageChanged,
//        physics: NeverScrollableScrollPhysics(),
//      ),
//      bottomNavigationBar: CupertinoTabBar(
//        currentIndex: pageIndex,
//        onTap: onTap,
//        activeColor: Colors.red,
//        items: [
//          BottomNavigationBarItem(icon: Icon(Icons.arrow_back) , title: Text('الرئيسية' , style: TextStyle(fontSize: 13),)),
//          BottomNavigationBarItem(icon: Icon(Icons.add) , title: Text('اضافة طلب' , style: TextStyle(fontSize: 13),)),
//          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet) , title: Text('طلباتي' , style: TextStyle(fontSize: 13),)),
//        ],
//      ),
//    );
//  }

  Widget buildAuthScreen() {
    return InfoWidget(
      builder: (context, infoWidget) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: mainKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                type[_page],
                style: infoWidget.titleButton,
              ),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            drawer: Container(
              width: infoWidget.orientation == Orientation.portrait
                  ? infoWidget.screenWidth * /*0.51 */ 0.6
                  : infoWidget.screenWidth * /*0.50*/ 0.59,
              height: infoWidget.screenHeight,
              child: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName:
                          Text("${googleSignIn.currentUser.displayName}"),
                      accountEmail: Text("${googleSignIn.currentUser.email}"),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${googleSignIn.currentUser.displayName.substring(0, 1).toUpperCase()}",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                    _drawerListTile(
                        isIcon: true,
                        name: "الرئيسية",
                        icon: Icons.home,
                        infoWidget: infoWidget,
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _page = 0;
                          });
                          _pageController.jumpToPage(_page);
                        }),
                    _drawerListTile(
                        name: "اضافة طلب",
                        isIcon: true,
                        icon: Icons.add,
                        infoWidget: infoWidget,
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _page = 1;
                          });
                          _pageController.jumpToPage(_page);
                        }),
                    _drawerListTile(
                        name: "طلباتى",
                        isIcon: true,
                        icon: Icons.account_balance_wallet,
                        infoWidget: infoWidget,
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _page = 2;
                          });
                          _pageController.jumpToPage(_page);
                        }),
                    _drawerListTile(
                        name: "تسجيل الخروج",
                        isIcon: true,
                        icon: Icons.exit_to_app,
                        infoWidget: infoWidget,
                        onTap: signOut),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: infoWidget.screenHeight >= 960 ? 70 : 55,
              key: _bottomNavigationKey,
              backgroundColor: Colors.white,
              color: Colors.red,
              items: <Widget>[
                _page != 0
                    ? _iconNavBar(
                        infoWidget: infoWidget,
                        title: 'الرئيسية',
                        iconPath: Icons.home)
                    : _iconNavBar(infoWidget: infoWidget, iconPath: Icons.home),
                _page != 1
                    ? _iconNavBar(
                        infoWidget: infoWidget,
                        title: 'اضافه طلب',
                        iconPath: Icons.add)
                    : _iconNavBar(infoWidget: infoWidget, iconPath: Icons.add),
                _page != 2
                    ? _iconNavBar(
                        infoWidget: infoWidget,
                        title: 'طلباتى',
                        iconPath: Icons.account_balance_wallet)
                    : _iconNavBar(
                        infoWidget: infoWidget,
                        iconPath: Icons.account_balance_wallet),
              ],
              onTap: (index) {
                setState(() {
                  _page = index;
                });
                _pageController.jumpToPage(_page);
              },
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _page = index;
                  });
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(_page);
                },
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0, left: 2.0, right: 2.0),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0, right: 0, left: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('مرحباً بك :',
                                  textAlign: TextAlign.center,
                                  style: infoWidget.title),
                              Text(
                                  ' من فضلك قم بتحديث ملفك الشخصي عند اول استخدام للتطبيق ',
                                  textAlign: TextAlign.center,
                                  style: infoWidget.subTitle),
                              FlatButton(
                                color: Colors.red,
                                child: Text(
                                  'تعديل البيانات',
                                  style: infoWidget.titleButton,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      context: context,
                                      builder: (context) {
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight:
                                                  infoWidget.screenHeight *
                                                      0.85),
                                          child: Column(
                                            textDirection: TextDirection.rtl,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 25),
                                                child: Center(
                                                  child: Text(
                                                      'تعديل البيانات الشخصية',
                                                      style: infoWidget
                                                          .titleButton
                                                          .copyWith(
                                                              color:
                                                                  Colors.red)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Container(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: <Widget>[
                                                        TextFormField(
                                                          validator: (val) {
                                                            if (val
                                                                        .trim()
                                                                        .length <
                                                                    6 ||
                                                                val.isEmpty) {
                                                              return ('الرقم المدخل غير صحيح');
                                                            } else if (val
                                                                    .trim()
                                                                    .length >
                                                                15) {
                                                              return ('الرقم المدخل غير صحيح');
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          onSaved: (val) =>
                                                              phone = val,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            icon: Icon(
                                                                Icons.phone),
                                                            labelText:
                                                                'رقم الهاتف',
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            hintText:
                                                                '01234567890',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          validator: (val) {
                                                            if (val
                                                                        .trim()
                                                                        .length <
                                                                    6 ||
                                                                val.isEmpty) {
                                                              return ('الاحرف قليلة جدا');
                                                            } else if (val
                                                                    .trim()
                                                                    .length >
                                                                30) {
                                                              return ('الاحرف كثيرة جدا');
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          onSaved: (val) =>
                                                              fullName = val,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            icon: Icon(
                                                                Icons.person),
                                                            labelText:
                                                                'الاسم بالكامل',
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  height: 50,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'تأكيد',
                                                      style: infoWidget
                                                          .titleButton,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  final form =
                                                      _formKey.currentState;
                                                  if (form.validate()) {
                                                    form.save();
//                                          SnackBar snackBar = SnackBar(content: Text('Welcome !'),);
//                                          _scaffoldKey.currentState.showSnackBar(snackBar) ;
                                                    await caseRef
                                                        .document(
                                                            currentCase.id)
                                                        .updateData({
                                                      'fullName': fullName,
                                                      'phone': phone,
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            color: Colors.red,
                            child: InkWell(
                              onTap: () {
                                offlinePoliceInfo(infoWidget);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                // add this
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.asset('img/police.jpg',
                                        height: 150, fit: BoxFit.fill),
                                  ),
                                  ListTile(
                                      title: Center(
                                    child: Text(
                                      'حالات تستدعي الشرطة',
                                      style: infoWidget.titleButton,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            color: Colors.red,
                            child: InkWell(
                              onTap: () {
                                offlineRiskInfo(infoWidget);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                // add this
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.asset('img/risk.jpg',
                                        height: 150, fit: BoxFit.fill),
                                  ),
                                  ListTile(
                                    title: Center(
                                      child: Text(
                                        'التعامل مع الكوارث',
                                        style: infoWidget.titleButton,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            color: Colors.red,
                            child: InkWell(
                              onTap: () {
                                offlineFireInfo(infoWidget);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                // add this
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.asset('img/fire.jpg',
                                        height: 150, fit: BoxFit.fill),
                                  ),
                                  ListTile(
                                    title: Center(
                                      child: Text(
                                        'ارشادات الحرائق',
                                        style: infoWidget.titleButton,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AddIssue(
                    currentCase: currentCase,
                  ),
                  MyIssue(
                    caseId: currentCase?.id,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('img/homeimg.jpg'),
            SizedBox(
              height: 15,
            ),
            Text(
              'نظام الطوارئ 218',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'تطبيق المواطن ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 90,
            ),
            SizedBox(height: 10),
            Text(
              'تسجيل الدخول باستخدام حساب غوغل',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                login();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('img/google.png'),
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
