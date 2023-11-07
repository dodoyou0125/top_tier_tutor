// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:top_tier_tutor/app%20screen/user_schedule_reservation.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';
import 'dart:convert';
import 'package:top_tier_tutor/main.dart';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile_coach extends StatefulWidget {
  profile_coach(
      {this.url,
      this.name,
      this.summonerdata,
      this.image_name,
      this.rankinfo,
      this.currentPatch,
      this.intro,
      this.coach_fee,
      this.Index,
      this.Index2,
      this.Index3,
      this.Index4,
      this.Index5});
  final url;
  final name;
  final summonerdata;
  final image_name;
  final rankinfo;
  final currentPatch;

  final intro;
  final coach_fee;
  final Index;
  final Index2;
  final Index3;
  final Index4;
  final Index5;

  @override
  State<profile_coach> createState() => _profile_coachState();
}

class _profile_coachState extends State<profile_coach> {
  dynamic url_now;
  String name_now = '과제 많은 넙죽이';
  Map summonerdata_now = {};
  String image_name_now = '';
  dynamic rankinfo_now;
  int currentPatch_now = 0;
  dynamic rankinfo;
  int patchgamecount = 0;
  // summonerdata['tier']
  // summonerdata['leaguePoints']
  // summonerdata['wins']
  // summonerdata['losses']
  // summonerdata['gameCounts']

  String profile_article = '아직 등록되지 않은 코치입니다';
  String coaching_fee = '';

  //For ChoiceChip
  int defaultChoiceIndex = 0;
  List<String> _choicesList = ['50', '100', '200', '300', '400', '500'];

  //For ChoiceChip2
  int defaultChoiceIndex2 = 0;
  List<String> _choicesList2 = ['이하', '이상', '제한 없음'];

  //For ChoiceChip3
  int defaultChoiceIndex3 = 0;
  List<String> _choicesList3 = ['브론즈', '실버', '골드', '플레', '다이아', '마스터'];

  //For ChoiceChip4
  int defaultChoiceIndex4 = 0;
  List<String> _choicesList4 = ['이하', '이상', '제한 없음'];

  //For ChoiceChip5
  int defaultChoiceIndex5 = 0;
  List<String> _choicesList5 = ['판 수당', '시간당'];

  //For ChoiceChip5
  int defaultChoiceIndex6 = 0;
  List<String> _choicesList6 = ['이하', '이상'];



  void initState() {
    super.initState();
    print('profile_coach');
    updateData(widget.url, widget.name, widget.summonerdata, widget.image_name,
        widget.rankinfo, widget.currentPatch, widget.intro, widget.coach_fee, widget.Index, widget.Index2, widget.Index3, widget.Index4, widget.Index5);
    //print(summonerdata_now['tier']);
  }

  void updateData(dynamic url, String name, Map summonerdta, String image_name,
      dynamic rankinfo, int currentPatch, String intro, int coach_fee, int Index, int Index2, int Index3, int Index4, int Index5 ) {
    url_now = url;
    name_now = name;
    summonerdata_now = summonerdta;
    image_name_now = image_name;
    rankinfo_now = rankinfo;
    currentPatch_now = currentPatch;
    profile_article = intro;
    defaultChoiceIndex = Index;
    defaultChoiceIndex2 = Index2;
    defaultChoiceIndex3 = Index3;
    defaultChoiceIndex4 = Index4;
    defaultChoiceIndex5 = Index5;
    coaching_fee = coach_fee.toString();
  }


  int tier_to_num(String tier){
    int num = 0;
    if (tier == 'CHALLENGER'){
      num = 8;
    }
    else if (tier == 'GRANDMASTER'){
      num = 7;
    }
    else if (tier == 'MASTER'){
      num = 6;
    }
    else if (tier == 'MASTER'){
      num = 5;
    }
    else if (tier == 'DIAMOND'){
      num = 4;
    }
    else if (tier == 'PLATINUM'){
      num = 3;
    }
    else if (tier == 'GOLD'){
      num = 2;
    }
    else if (tier == 'SILVER'){
      num = 1;
    }
    else if (tier == 'BRONZE'){
      num = 0;
    }
    else if (tier == 'IRON'){
      num = -1;
    }
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              //넘어갈 수 있도록 설정
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(
                      image: AssetImage('images/Gameplay_edit.jpg'),
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                    Container(
                      width: 10.0,
                      height: MediaQuery.of(context).size.height -
                          300
                    ),
                  ],
                ),
                Positioned(
                  top: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 70,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: 390,
                                height: 230,
                                decoration: BoxDecoration(
                                  color: Color(0xFF003399),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    //아이콘 소환사명 코치 인증완료
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(url_now),
                                          radius: 24.0,
                                        ),
                                        SizedBox(
                                          width: 35.0,
                                        ),
                                        Container(
                                          width: 100,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '$name_now',
                                              style: TextStyle(
                                                fontFamily: 'NanumSquare',
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 35.0,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              color: Color(0xFF04FFFF)),
                                          height: 20,
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              '코치',
                                              style: TextStyle(
                                                fontFamily: 'NanumSquare',
                                                color: Colors.black,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              color: Color(0xFFD13639)),
                                          height: 20,
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'images/riot_logo.png'),
                                                ),
                                                Text(
                                                  '인증 완료',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //시즌 9 정보란
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, top: 5.0),
                                              child: Text(
                                                '시즌 9 정보',
                                                style: TextStyle(
                                                  fontFamily: 'NanumSquare',
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      image_name_now),
                                                  height: 80.0,
                                                  width: 80.0,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                //Challenger/Grandmaster XXXLP
                                                Text(
                                                  '${summonerdata_now['tier']}' +
                                                      '   ' +
                                                      '${summonerdata_now['leaguePoints']}' +
                                                      'LP',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35.0,
                                                ),
                                                //Rank XXX
                                                Text(
                                                  'Rank\n' + '$rankinfo_now',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //Thin Line
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                              child: Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    '게임 수\n' +
                                                        '${summonerdata_now['gameCounts'].toString()}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '순방률\n' +
                                                        '${(summonerdata_now['wins'] / summonerdata_now['gameCounts'] * 100).toStringAsFixed(2)}' +
                                                        '%',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text(
                                                    '최신 패치 버전 게임 수\n' +
                                                        '$currentPatch_now',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                width: 390,
                                //height: 1000,
                                decoration: BoxDecoration(
                                  color: Color(0xFF003399),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    //코치 프로필
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 5, 5, 0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          SizedBox(
                                            width: 19.0,
                                          ),
                                          Text(
                                            '코치 프로필',
                                            style: TextStyle(
                                              fontFamily: 'NanumSquare',
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //코칭 소개글
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //코칭 소개글
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(
                                                  '코칭 소개글',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child: Container(
                                                  height: 0.5,
                                                  width: double.infinity,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  '\n' +
                                                      '$profile_article' +
                                                      '\n',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    //코칭 금액
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //코칭 금액
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(
                                                  '코칭 금액',
                                                  style: TextStyle(
                                                    fontFamily: 'NanumSquare',
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child: Container(
                                                  height: 0.5,
                                                  width: double.infinity,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              //단위
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    '단위',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 19,
                                                  ),
                                                  Wrap(
                                                    spacing: 8,
                                                    children: List.generate(
                                                        _choicesList5.length,
                                                        (index) {
                                                      return ChoiceChip(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFF0583F2),
                                                          ),
                                                        ),
                                                        labelPadding:
                                                            EdgeInsets.fromLTRB(
                                                                2, -2, 2, -2),
                                                        label: Text(
                                                          _choicesList5[index],
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        labelStyle: TextStyle(
                                                          color:
                                                              defaultChoiceIndex5 ==
                                                                      index
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                        selected:
                                                            defaultChoiceIndex5 ==
                                                                index,
                                                        selectedColor:
                                                            Color(0xFF0583F2),
                                                        onSelected: (value) {
                                                          setState(() {
                                                            null;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              //금액
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    '금액',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 19,
                                                  ),
                                                  Text(
                                                    '$coaching_fee ',
                                                    style: TextStyle(
                                                      textBaseline: TextBaseline.alphabetic,
                                                      fontFamily:
                                                          'NanumSquare',
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Image(
                                                    image: AssetImage('images/TTT_Token.png'),
                                                    fit: BoxFit.cover,
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                            ]),
                                      ),
                                    ),
                                    //코칭 가능한 유저
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //코칭 가능한 유저
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(
                                                '코칭 가능한 유저',
                                                style: TextStyle(
                                                  fontFamily: 'NanumSquare',
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            //Thin Line
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 10),
                                              child: Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.black,
                                              ),
                                            ),
                                            //게임 수
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  '게임 수',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Wrap(
                                                  spacing: 8,
                                                  children: List.generate(
                                                      _choicesList.length,
                                                      (index) {
                                                    return ChoiceChip(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0583F2),
                                                        ),
                                                      ),
                                                      labelPadding:
                                                          EdgeInsets.fromLTRB(
                                                              2, -2, 2, -2),
                                                      label: Container(
                                                        width: 30.0,
                                                        child: Center(
                                                          child: Text(
                                                            _choicesList[index],
                                                            style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color:
                                                            defaultChoiceIndex ==
                                                                    index
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                      selected:
                                                          defaultChoiceIndex ==
                                                              index,
                                                      selectedColor:
                                                          Color(0xFF0583F2),
                                                      onSelected: (value) {
                                                        setState(() {
                                                          null;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            //게임 수 조건
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 17,
                                                ),
                                                Text(
                                                  '조건',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 17,
                                                ),
                                                Wrap(
                                                  spacing: 8,
                                                  children: List.generate(
                                                      _choicesList2.length,
                                                      (index) {
                                                    return ChoiceChip(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0583F2),
                                                        ),
                                                      ),
                                                      labelPadding:
                                                          EdgeInsets.fromLTRB(
                                                              2, -2, 2, -2),
                                                      label: Text(
                                                        _choicesList2[index],
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color:
                                                            defaultChoiceIndex2 ==
                                                                    index
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                      selected:
                                                          defaultChoiceIndex2 ==
                                                              index,
                                                      selectedColor:
                                                          Color(0xFF0583F2),
                                                      onSelected: (value) {
                                                        setState(() {
                                                          null;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            //Thin Line
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 10, 5, 10),
                                              child: Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.black,
                                              ),
                                            ),
                                            //티어
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 17.0,
                                                ),
                                                Text(
                                                  '티어',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 17.0,
                                                ),
                                                Wrap(
                                                  spacing: 8,
                                                  children: List.generate(
                                                      _choicesList3.length,
                                                      (index) {
                                                    return ChoiceChip(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0583F2),
                                                        ),
                                                      ),
                                                      labelPadding:
                                                          EdgeInsets.fromLTRB(
                                                              2, -2, 2, -2),
                                                      label: Text(
                                                        _choicesList3[index],
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color:
                                                            defaultChoiceIndex3 ==
                                                                    index
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                      selected:
                                                          defaultChoiceIndex3 ==
                                                              index,
                                                      selectedColor:
                                                          Color(0xFF0583F2),
                                                      onSelected: (value) {
                                                        setState(() {
                                                          null;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            //티어 조건
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 17,
                                                ),
                                                Text(
                                                  '조건',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 17,
                                                ),
                                                Wrap(
                                                  spacing: 8,
                                                  children: List.generate(
                                                      _choicesList4.length,
                                                      (index) {
                                                    return ChoiceChip(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0583F2),
                                                        ),
                                                      ),
                                                      labelPadding:
                                                          EdgeInsets.fromLTRB(
                                                              2, -2, 2, -2),
                                                      label: Text(
                                                        _choicesList4[index],
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color:
                                                            defaultChoiceIndex4 ==
                                                                    index
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                      selected:
                                                          defaultChoiceIndex4 ==
                                                              index,
                                                      selectedColor:
                                                          Color(0xFF0583F2),
                                                      onSelected: (value) {
                                                        setState(() {
                                                          null;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        //코칭 조건에 맞는지를 확인하기
                                        final user = FirebaseAuth.instance.currentUser;
                                        //user info 확인하기
                                        Map user_info = await getUserInfo_fromFirebase(user!.uid);
                                        var gameCounts = user_info['summoner data']['gameCounts'];
                                        //tier => num으로 전환
                                        int tier = tier_to_num(user_info['summoner data']['tier']);

                                        print(name_now);
                                        Map Events = await getScheduleDataFromFireBaseToken('$name_now');

                                        //게임 수와 티어가 모두 상관 없는 경우
                                        if(defaultChoiceIndex2 == 2 && defaultChoiceIndex4 == 2){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return user_schedule_reservation(event: Events, coach_name: name_now,);
                                          }));
                                        }
                                        //게임 수는 제한 없는 경우
                                        else if(defaultChoiceIndex2 == 2){
                                          //티어 '이하'
                                          if(defaultChoiceIndex4 == 0){
                                            switch (defaultChoiceIndex3){
                                              case 0:
                                                if(tier <= 0){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 높습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 1:
                                                if(tier <= 1){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 높습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 2:
                                                if(tier <= 2){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 높습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 3:
                                                if(tier <= 3){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 높습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 4:
                                                if(tier <= 4){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 높습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                            }
                                          }
                                          //티어 '이상'
                                          else{
                                            switch (defaultChoiceIndex3){
                                              case 0:
                                                if(tier >= 0){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 낮습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 1:
                                                if(tier >= 1){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 낮습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 2:
                                                if(tier >= 2){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 낮습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 3:
                                                if(tier >= 3){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 낮습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 4:
                                                if(tier >= 4){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '티어가 조건보다 낮습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                            }
                                          }
                                        }
                                        //티어는 제한 없는 경우
                                        else if(defaultChoiceIndex4 == 2){
                                          //게임 수 이하
                                          if(defaultChoiceIndex2 == 0){
                                            switch (defaultChoiceIndex){
                                              case 0:
                                                if(gameCounts <= 50){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 1:
                                                if(gameCounts <= 100){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 2:
                                                if(gameCounts <= 200){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 3:
                                                if(gameCounts <= 300){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 4:
                                                if(gameCounts <= 400){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 5:
                                                if(gameCounts <= 500){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 많습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                            }
                                          }
                                          //게임 수 '이상'
                                          else{
                                            switch (defaultChoiceIndex){
                                              case 0:
                                                if(gameCounts >= 50){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 1:
                                                if(gameCounts >= 100){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 2:
                                                if(gameCounts >= 200){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 3:
                                                if(gameCounts >= 300){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 4:
                                                if(gameCounts >= 400){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              case 5:
                                                if(gameCounts >= 500){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return user_schedule_reservation(event: Events, coach_name: name_now,);
                                                  }));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                    msg: '게임 수가 조건보다 적습니다!',
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                            }
                                          }
                                        }
                                        //게임 수와 티어 모두 조건이 있는 경우
                                        else{
                                          //체크를 위한 플래그 설정
                                          int check_gamecount = 0;
                                          int check_tier = 0;
                                          //티어 체크
                                          if(defaultChoiceIndex2 != 2){
                                            //티어 '이하'
                                            if(defaultChoiceIndex4 == 0){
                                              switch (defaultChoiceIndex3){
                                                case 0:
                                                  if(tier <= 0){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 높습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 1:
                                                  if(tier <= 1){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 높습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 2:
                                                  if(tier <= 2){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 높습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 3:
                                                  if(tier <= 3){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 높습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 4:
                                                  if(tier <= 4){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 높습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                              }
                                            }
                                            //티어 '이상'
                                            else{
                                              switch (defaultChoiceIndex3){
                                                case 0:
                                                  if(tier >= 0){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 낮습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 1:
                                                  if(tier >= 1){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 낮습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 2:
                                                  if(tier >= 2){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 낮습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 3:
                                                  print('here?');
                                                  if(tier >= 3){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    print('here!!!');
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 낮습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 4:
                                                  if(tier >= 4){
                                                    check_tier = 0;
                                                  }
                                                  else{
                                                    check_tier = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '티어가 조건보다 낮습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                              }
                                            }
                                          }
                                          //게임 수 체크
                                          if(defaultChoiceIndex4 != 2){
                                            //게임 수 이하
                                            if(defaultChoiceIndex2 == 0){
                                              switch (defaultChoiceIndex){
                                                case 0:
                                                  if(gameCounts <= 50){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 1:
                                                  if(gameCounts <= 100){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 2:
                                                  if(gameCounts <= 200){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 3:
                                                  if(gameCounts <= 300){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 4:
                                                  if(gameCounts <= 400){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 5:
                                                  if(gameCounts <= 500){
                                                  }
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 많습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                              }
                                            }
                                            //게임 수 '이상'
                                            else{
                                              switch (defaultChoiceIndex){
                                                case 0:
                                                  if(gameCounts >= 50){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 1:
                                                  if(gameCounts >= 100){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 2:
                                                  if(gameCounts >= 200){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 3:
                                                  if(gameCounts >= 300){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 4:
                                                  if(gameCounts >= 400){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                                case 5:
                                                  if(gameCounts >= 500){}
                                                  else {
                                                    check_gamecount = 1;
                                                    Fluttertoast.showToast(
                                                      msg: '게임 수가 조건보다 적습니다!',
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  }
                                              }
                                            }
                                          }
                                          if(check_gamecount + check_tier == 0){
                                            print(check_gamecount);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return user_schedule_reservation(event: Events, coach_name: name_now,);
                                            }));
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(6.0),
                                            child: Center(
                                              child: Text(
                                                '코칭 신청하기',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'NanumSquare',
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                        width: 10.0,
                      )
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.event),
        //       label: 'Schedule',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.savings),
        //       label: 'Account',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   unselectedItemColor: Colors.black,
        //   selectedItemColor: Color(0xFF0003399),
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }
}
