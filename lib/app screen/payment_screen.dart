// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:top_tier_tutor/app%20screen/payment_dialog.dart';
import 'package:top_tier_tutor/app%20screen/token_charge.dart';

import 'package:top_tier_tutor/building app/colors.dart';

import '../firebase/firebase_function.dart';

class payment_screen extends StatefulWidget {
  const payment_screen({this.reservation, this.date, this.coach_name});
  final reservation;
  final date;
  final coach_name;

  @override
  State<payment_screen> createState() => _payment_screenState();
}

class _payment_screenState extends State<payment_screen> {
  var user;
  var user_info;

  List reservation = [];
  String coach_name = '';
  var date;
  int total = 0;

  int TTT_Token = 0;

  var f = NumberFormat('###,###,###,###');

  late StreamSubscription streamsubscription;

  void initState() {
    super.initState();
    reservation = widget.reservation;
    date = widget.date;
    coach_name = widget.coach_name;
    getCurrentUser();
    setState(() {
      reservation.removeWhere((element) => (element == null || element == ''));
    });
    _cal_total();
    print(reservation);
    print(date);
  }

  void dispose() {
    streamsubscription!.cancel();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        user_info = await getUserInfo_fromFirebase(user!.uid);
        setState(() {
          TTT_Token = user_info['token'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void tokenStream() async {
    var stream = await FirebaseFirestore.instance
        .collection('user')
        .doc(user_info['name'])
        .snapshots();
    streamsubscription = stream.listen((event) {
      if (TTT_Token != event.data()!['token'] && mounted) {
        setState(() {
          TTT_Token = event.data()!['token'];
        });
      }
    }, onDone: () {
      streamsubscription.cancel();
    });
  }

  void _cal_total() {
    for (int i = 0; i < reservation.length; i++) {
      total += int.parse(reservation[i].split('금액 : ')[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TTT_dark_blue,
        centerTitle: true,
        title: Text(
          '결제하기',
          style: TextStyle(
            fontFamily: 'NanumSquare',
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 6.0),
                            width: 390,
                            decoration: BoxDecoration(
                              color: TTT_dark_blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '선택한 코치',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    height: 40.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 23.0,
                                        ),
                                        Text(
                                          '소환사명 : ',
                                          style: TextStyle(
                                            fontFamily: 'NanumSquare',
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 1.0,
                                              ),
                                              Text(
                                                '$coach_name',
                                                style: TextStyle(
                                                  fontFamily: 'NanumSquare',
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 6.0),
                            width: 390,
                            decoration: BoxDecoration(
                              color: TTT_dark_blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '선택한 시간',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    width: 380,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            '${date.toString().split(' ')[0]}',
                                            style: TextStyle(
                                              fontFamily: 'NanumSquare',
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            color: TTT_dark_blue,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Text(
                                                    '시간',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Text(
                                                    '금액',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            color: TTT_dark_blue,
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: reservation.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Flexible(
                                                  flex: 7,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        '${index + 1}. ${reservation[index].split('~')[0]} ~ ${reservation[index].split('~')[1].split(' 금액')[0]}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NanumSquare',
                                                          color: Colors.black,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height: 1.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${f.format(int.parse(reservation[index].split('금액 : ')[1]))} ',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'NanumSquare',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                                'images/TTT_Token.png'),
                                                            fit: BoxFit.cover,
                                                            height: 14,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 1.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            color: TTT_dark_blue,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '결제 예정 금액',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 31,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${f.format(total)} ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NanumSquare',
                                                          color: Colors.black,
                                                          fontSize: 16.5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Image(
                                                        image: AssetImage(
                                                            'images/TTT_Token.png'),
                                                        fit: BoxFit.cover,
                                                        height: 18,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 6.0),
                            width: 390,
                            decoration: BoxDecoration(
                              color: TTT_dark_blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '결제 후 TTT 토큰 잔액',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    width: 380,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Text(
                                                    '내역',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Text(
                                                    '금액',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            color: TTT_dark_blue,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    '보유 TTT 토큰',
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${f.format(TTT_Token)} ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NanumSquare',
                                                          color: Colors.black,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Image(
                                                        image: AssetImage(
                                                            'images/TTT_Token.png'),
                                                        fit: BoxFit.cover,
                                                        height: 14,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${date.toString().split(' ')[0]} $coach_name 코칭 ${reservation.length}건',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'NanumSquare',
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 1.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '-${f.format(total)} ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NanumSquare',
                                                          color: Colors.black,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Image(
                                                        image: AssetImage(
                                                            'images/TTT_Token.png'),
                                                        fit: BoxFit.cover,
                                                        height: 14,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            color: TTT_dark_blue,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 1.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${f.format(TTT_Token - total)} ',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Image(
                                                  image: AssetImage(
                                                      'images/TTT_Token.png'),
                                                  fit: BoxFit.cover,
                                                  height: 16.5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 390,
                          child: Text(
                            '결제 시 유의 사항',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          width: 390,
                          child: Text(
                            '결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 '
                            '결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 '
                            '결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 '
                            '결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 결제 시 유의 사항 ',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 58,
                        ),
                      ],
                    ),
                  ),
                ),
                if (TTT_Token - total > 0)
                  Positioned(
                    bottom: 0.0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async{
                          bool flag = false;
                          flag = await showPaymentDialog(context, flag).then((value) => flag = value);
                          print('after $flag');
                        },
                        child: Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width * 0.98,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: TTT_dark_blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (total < 10000) ...[
                                  SizedBox(
                                    width: 90.0,
                                    child: Text(
                                      '${reservation.length}건',
                                      style: TextStyle(
                                        fontFamily: 'NanumSquare',
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '결제하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${f.format(total)} ',
                                          style: TextStyle(
                                            fontFamily: 'NanumSquare',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'images/TTT_Token.png'),
                                          fit: BoxFit.cover,
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      '${reservation.length}건',
                                      style: TextStyle(
                                        fontFamily: 'NanumSquare',
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '결제하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${f.format(total)} ',
                                          style: TextStyle(
                                            fontFamily: 'NanumSquare',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'images/TTT_Token.png'),
                                          fit: BoxFit.cover,
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Positioned(
                    bottom: 0.0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          tokenStream();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return token_charge();
                          }));
                        },
                        child: Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width * 0.98,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: TTT_sky_blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (total < 10000) ...[
                                  SizedBox(
                                    width: 90.0,
                                    child: Text(
                                      '${reservation.length}건',
                                      style: TextStyle(
                                        fontFamily: 'NanumSquare',
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '충전하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${f.format(total - TTT_Token)} ',
                                          style: TextStyle(
                                            fontFamily: 'NanumSquare',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'images/TTT_Token.png'),
                                          fit: BoxFit.cover,
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      '${reservation.length}건',
                                      style: TextStyle(
                                        fontFamily: 'NanumSquare',
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '충전하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquare',
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${f.format(total - TTT_Token)} ',
                                          style: TextStyle(
                                            fontFamily: 'NanumSquare',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'images/TTT_Token.png'),
                                          fit: BoxFit.cover,
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
