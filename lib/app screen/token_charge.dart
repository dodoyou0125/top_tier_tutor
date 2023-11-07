// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:top_tier_tutor/app%20screen/reroll_cal.dart';
import 'package:top_tier_tutor/app%20screen/schedule_coach.dart';
import 'package:top_tier_tutor/app%20screen/schedule_user.dart';

import 'package:top_tier_tutor/building app/colors.dart';
import 'package:top_tier_tutor/purchasing/google_purchase.dart';

import '../building app/loading_screen.dart';
import '../firebase/firebase_function.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'package:top_tier_tutor/purchasing/consumable_store.dart';

import 'home.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = true;
// final bool _kAutoConsume = Platform.isIOS || true;

const List<String> _kConsumableId = <String>[
  'ttt_token1',
  'ttt_token2',
  'ttt_token3',
  'ttt_token4',
  'ttt_token5',
  'ttt_token6'
];
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'subscription_gold';
const List<String> _kProductIds = <String>[
  'ttt_token1',
  'ttt_token2',
  'ttt_token3',
  'ttt_token4',
  'ttt_token5',
  'ttt_token6'
];

const List<int> _tokenAmounts = [360, 1130, 2610, 4120, 5780, 10810];

var f = NumberFormat('###,###,###,###,###');

class token_charge extends StatefulWidget {
  const token_charge({super.key});

  @override
  State<token_charge> createState() => _token_chargeState();
}

class _token_chargeState extends State<token_charge> {
  bool isloading = false;
  String summoner_name = '';

  int width_box = 172;
  int token = 0;

  final _auth = FirebaseAuth.instance;
  String name = '';
  Map user_info = {};

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _stream;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    _inAppPurchase.restorePurchases();
    // _subscription =
    //     purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
    //       _listenToPurchaseUpdated(purchaseDetailsList);
    //     }, onDone: () {
    //       _subscription.cancel();
    //     }, onError: (Object error) {
    //       // handle error here.
    //     });
    initStoreInfo();
    getCurrentUser();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    //이용 가능한지
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    //ios인지
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    print('consumables = $consumables');
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
    print(_notFoundIds);
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        Map user_info = await getUserInfo_fromFirebase(user!.uid);
        setState(() {
          token = user_info['token'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void purchasingCheck(int i) async {
    bool flag = true;

    final user = FirebaseAuth.instance.currentUser;
    Map user_info = await getUserInfo_fromFirebase(user!.uid);
    String summoner_name = user_info['name'];
    var db = FirebaseFirestore.instance;
    final washingtonRef = db.collection("user").doc(summoner_name);

    Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    ProductDetails productDetails = _products[i];
    PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    if (productDetails.id == _kConsumableId[i]) {
      _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
    }
    _stream = purchaseUpdated.listen((event) {
      // print('listen event listen event listen event listen event ${event}');
      // print('purchaseID : ${event[0].purchaseID}');
      // print('verificationData : ${event[0].verificationData}');
      // print('transactionDate : ${event[0].transactionDate}');
      // print('status : ${event[0].status}');
      // print(event[0].productID);
      if (event[0].status == PurchaseStatus.purchased && flag && event[0].productID != null && event[0].productID != null && event[0].transactionDate != null && mounted) {
        flag = false;
        print("상태가 구매 완료로 변경됨");
        if(user_info['purchasing'] == null){
          washingtonRef.set({
            "token": (token + _tokenAmounts[i]),
            "purchasing": {
              event[0].purchaseID.toString() : {
                "purchaseID": event[0].purchaseID.toString(),
                "productID": event[0].productID.toString(),
                "transactionDate": event[0].transactionDate.toString(),
                "status": event[0].status.toString(),
              }
            }
          }, SetOptions(merge: true)).then((value) async{
            final user = FirebaseAuth.instance.currentUser;
            Map user_info = await getUserInfo_fromFirebase(user!.uid);
            setState(() {
              token = user_info['token'];
            });
            print("DocumentSnapshot successfully updated!");
          }, onError: (e) => print("Error updating document $e"));
        }
        else{
          if(user_info['purchasing'].containsKey(event[0].purchaseID.toString()) == false){
            washingtonRef.set({
              "token": (token + _tokenAmounts[i]),
              "purchasing": {
                event[0].purchaseID.toString() : {
                  "purchaseID": event[0].purchaseID.toString(),
                  "productID": event[0].productID.toString(),
                  "transactionDate": event[0].transactionDate.toString(),
                  "status": event[0].status.toString(),
                }
              }
            }, SetOptions(merge: true)).then((value) async{
              final user = FirebaseAuth.instance.currentUser;
              Map user_info = await getUserInfo_fromFirebase(user!.uid);
              setState(() {
                token = user_info['token'];
              });
              print("DocumentSnapshot successfully updated!");
            }, onError: (e) => print("Error updating document $e"));
          }
        }
      } else if (event[0].status == PurchaseStatus.pending) {
        print("구매 승인 대기중");
      } else if ((event[0].status == PurchaseStatus.error)) {
        print("결제 에러");
      }

    }, onDone: () {
      _stream.cancel();
    });

  }

  int _selectedIndex = 3;
  void _onItemTapped(int index) async {
    setState(() {
      isloading = true;
    });
    if (index == 0) {
      List<dynamic> entries_now = await getEntries('home');
      setState(() {
        isloading = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return home(entries: entries_now);
        }));
      });
    } else if (index == 1) {
      String tier = user_info['tier'];
      if (tier == '챌린저' || tier == '그랜드마스터'){
        Map Events = await getScheduleDataFromFireBase('$summoner_name');
        setState(() {
          isloading = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return schedule_coach(event: Events);
          }));
        });
      }
      else{
        Map Events = await getScheduleDataFromFireBase_ForUser('$summoner_name');
        setState(() {
          isloading = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return schedule_user(event: Events);
          }));
        });
      }

      // Navigator.pushNamed(context, '/schedule_coach');
    } else if (index == 2){
      isloading = false;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return reroll_cal();
      }));
    }

    else if (index == 3){
      isloading = false;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return token_charge();
      }));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TTT_dark_blue,
        centerTitle: true,
        title: Text(
          'TTT 토큰 충전하기',
          style: TextStyle(
            fontFamily: 'NanumSquare',
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 10.0),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 120,
                  width: 172 * 2 + 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    gradient: LinearGradient(
                      colors: [TTT_dark_blue, TTT_sky_blue.withOpacity(0.6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 30.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white38,
                                  Colors.white.withOpacity(0.9)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )),
                          child: Center(
                            child: Text(
                              '내가 가진 TTT 토큰',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            // gradient: LinearGradient(
                            //   colors: [TTT_dark_blue, TTT_sky_blue.withOpacity(0.6)],
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            // )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${f.format(token)}',
                                style: TextStyle(
                                  fontFamily: 'NanumSquare',
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image(
                                  image: AssetImage('images/TTT_Token.png'),
                                  fit: BoxFit.cover,
                                  height: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    //token1
                    GestureDetector(
                      onTap: () {
                        purchasingCheck(0);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '360',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/1token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '4,500\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        purchasingCheck(1);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1100 + 30',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/2token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '14,000\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        purchasingCheck(2);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '2500 + 110',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/3token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '32,000\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        purchasingCheck(3);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '4000 + 120',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/4token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '50,000\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        purchasingCheck(4);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '5500 + 280',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/5token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '70,000\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () async {
                        purchasingCheck(5);
                      },
                      child: Container(
                        width: 172,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: TTT_dark_blue)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '10000 + 810',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image(
                                    image: AssetImage('images/TTT_Token.png'),
                                    fit: BoxFit.cover,
                                    height: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: AssetImage('images/6token.png'),
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            Text(
                              '130,000\u20A9',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino_outlined),
            label: 'ReRoller',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Color(0xFF003399),
        onTap: _onItemTapped,
      ),
    );
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }
}
