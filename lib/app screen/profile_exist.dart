// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';
import 'dart:convert';
import 'package:top_tier_tutor/main.dart';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile_exist extends StatefulWidget {
  profile_exist({this.url, this.name, this.summonerdata, this.image_name, this.rankinfo, this.currentPatch});
  final url;
  final name;
  final summonerdata;
  final image_name;
  final rankinfo;
  final currentPatch;

  @override
  State<profile_exist> createState() => _profile_existState();
}

class _profile_existState extends State<profile_exist> {
  String coach_fee = '';
  String intro = '';
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
  String coaching_state = '코칭을 아직 신청할 수 없습니다';

  void initState() {
    super.initState();
    updateData(widget.url, widget.name, widget.summonerdata, widget.image_name, widget.rankinfo, widget.currentPatch);
    //print(summonerdata_now['tier']);
  }

  void updateData(
      dynamic url, String name, Map summonerdta, String image_name, dynamic rankinfo, int currentPatch) {
    url_now = url;
    name_now = name;
    summonerdata_now = summonerdta;
    image_name_now = image_name;
    rankinfo_now = rankinfo;
    currentPatch_now = currentPatch;
  }

  //For ChoiceChip
  int defaultChoiceIndex = 0;
  List<String> _choicesList = ['50', '100', '200', '300', '400', '500'];

  //For ChoiceChip2
  int defaultChoiceIndex2 = 0;
  List<String> _choicesList2 = ['이하', '이상', '제한 없음'];

  //For ChoiceChip3
  int defaultChoiceIndex3 = 0;
  List<String> _choicesList3 = ['브론즈', '실버', '플레', '다이아', '마스터'];

  //For ChoiceChip4
  int defaultChoiceIndex4 = 0;
  List<String> _choicesList4 = ['이하', '이상', '제한 없음'];

  //For ChoiceChip5
  int defaultChoiceIndex5 = 0;
  List<String> _choicesList5 = ['판 수당', '시간당'];

  //For ChoiceChip5
  int defaultChoiceIndex6 = 0;
  List<String> _choicesList6 = ['이하', '이상'];

  //For BottomNavigator Bar
  int _selectedIndex = 1;
  void _onItemTapped(int index) async {
    if (index == 0) {
      List<dynamic> entries_now = await getEntries('home');
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return home(entries: entries_now);
        }));
      });
    } else if (index == 1) {
      List<dynamic> result = await getData('과제많은넙죽이');
      rankinfo = await getRankInfo('과제많은넙죽이');
      patchgamecount = await getMatchData('과제많은넙죽이');
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return profile_exist(
            url: result[0],
            name: result[1],
            summonerdata: result[2],
            image_name: result[3],
            rankinfo: rankinfo,
            currentPatch: patchgamecount,
          );
        }));
      });
    } else if (index == 2)
      Navigator.pushNamed(context, '/schedule');
    else if (index == 3) Navigator.pushNamed(context, '/account');
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
                      height: MediaQuery.of(context).size.height - 300 -kBottomNavigationBarHeight,
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
                                          width: 75,
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
                                                  'Rank\n' +
                                                      '$rankinfo_now',
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
                                                  '\n'+'$profile_article'+'\n',
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
                                                  SizedBox(
                                                    width: 100.0,
                                                    height: 20.0,
                                                    child: Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontFamily: 'NanumSquare',
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
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
                                                  width: 12.0,
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
                                                  width: 19,
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
                                                  width: 19.0,
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
                                                  width: 19,
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
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            null;
                                          },
                                          child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                //정보 저장하기
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(6.0),
                                                  child: Center(
                                                    child: Text(
                                                      '$coaching_state',
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
                                              ]),
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
