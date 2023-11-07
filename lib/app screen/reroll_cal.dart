// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:top_tier_tutor/app%20screen/profile_coach.dart';
import 'package:top_tier_tutor/app%20screen/schedule_coach.dart';
import 'package:top_tier_tutor/app%20screen/schedule_user.dart';
import 'package:top_tier_tutor/app%20screen/token_charge.dart';
import 'package:top_tier_tutor/building%20app/colors.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/building%20app/numeric_range_formatter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'home.dart';

class reroll_cal extends StatefulWidget {
  const reroll_cal({super.key});

  @override
  State<reroll_cal> createState() => _reroll_calState();
}

List<String> dropdownList_level = ['4', '5', '6', '7', '8', '9', '10', '11'];
String selectedDropdown_level = '7';

List<String> dropdownList_level4 = ['1', '2', '3'];
String selectedDropdown_level4 = '1';

List<String> dropdownList_level5 = ['1', '2', '3', '4'];
String selectedDropdown_level5 = '1';

List<String> dropdownList_level7 = ['1', '2', '3', '4', '5'];
String selectedDropdown_level7 = '1';

final textEditingController1 = TextEditingController();
final textEditingController2 = TextEditingController();

class _reroll_calState extends State<reroll_cal> {
  bool isloading = false;

  int min = 0;
  int max_count = 22;
  int max_except_count = 286;
  int final_max_except_count = 286;

  String level = '7';
  String target_cost = '2';
  String target_count = '0';
  String target_except_count = '0';

  List<String> dropdownList_some_level = ['1', '2', '3', '4', '5'];
  String selectedDropdown_some_level = '2';

  Color cost = cost_2;
  Color font_color = Colors.white;

  String probability = '';
  String expectation = '';

  var result = {};

  /*void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }*/
  String search = '';
  dynamic entries_now;
  dynamic rankinfo;
  int patchgamecount = 0;

  late Map user_info;
  String summoner_name = '';
  String tier = '';

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    textEditingController1.addListener(() {});
    textEditingController2.addListener(() {});
  }

  //For BottomNavigator Bar
  int _selectedIndex = 2;
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
    return LoadingOverlay(
      isLoading: isloading,
      color: Colors.white,
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF003399),
            centerTitle: true,
            title: Text(
              '리롤 계산기',
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
              SizedBox(
                height: 5.0,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 340,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: TTT_sky_blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '내 레벨',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 165.0,
                          ),
                          DropdownButton(
                            dropdownColor: TTT_sky_blue,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            underline: SizedBox.shrink(),
                            value: selectedDropdown_level,
                            items: dropdownList_level.map((String item) {
                              return DropdownMenuItem<String>(
                                child: Text('$item'),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                level = value;
                                if (value == '4') {
                                  dropdownList_some_level = dropdownList_level4;
                                } else if (value == '5' || value == '6') {
                                  dropdownList_some_level = dropdownList_level5;
                                } else {
                                  dropdownList_some_level = dropdownList_level7;
                                  cost = cost_1;
                                }

                                selectedDropdown_level = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 10.0,
                    ),
                    Container(
                      width: 340,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cost,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '목표 코스트',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: font_color,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 129.0,
                          ),
                          SizedBox(
                            width: 42.0,
                            child: DropdownButton(
                              dropdownColor: cost,
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: font_color,
                              ),
                              style: TextStyle(
                                color: font_color,
                              ),
                              underline: SizedBox.shrink(),
                              value: selectedDropdown_some_level,
                              items: dropdownList_some_level.map((String item) {
                                return DropdownMenuItem<String>(
                                  child: Text('$item'),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  target_cost = value;
                                  selectedDropdown_some_level = value;
                                  if (value == '1') {
                                    cost = cost_1;
                                    font_color = Colors.white;
                                    max_count = 29;
                                    max_except_count = 377;
                                    final_max_except_count = 377;
                                  } else if (value == '2') {
                                    cost = cost_2;
                                    font_color = Colors.white;
                                    max_count = 22;
                                    max_except_count = 286;
                                    final_max_except_count = 286;
                                  } else if (value == '3') {
                                    cost = cost_3;
                                    font_color = Colors.white;
                                    max_count = 18;
                                    max_except_count = 234;
                                    final_max_except_count = 234;
                                  } else if (value == '4') {
                                    cost = cost_4;
                                    font_color = Colors.white;
                                    max_count = 12;
                                    max_except_count = 144;
                                    final_max_except_count = 144;
                                  } else {
                                    cost = cost_5;
                                    font_color = Colors.black;
                                    max_count = 10;
                                    max_except_count = 80;
                                    final_max_except_count = 80;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 10.0,
                    ),
                    Container(
                      width: 340,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '목표 기물이 팔린 수',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 63.0,
                          ),
                          SizedBox(
                            width: 42.0,
                            height: 20.0,
                            child: TextField(
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                                NumericRangeFormatter(min: min, max: max_count),
                              ],
                              onChanged: (value) {
                                int targetCount = int.parse(value);
                                setState(() {
                                  target_count = value;
                                  final_max_except_count =
                                      max_except_count - targetCount;
                                });
                                print(targetCount);
                              },
                              controller: textEditingController1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 10.0,
                    ),
                    Container(
                      width: 340,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cost,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '같은 코스트가 팔린 수',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: font_color,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 45.0,
                          ),
                          SizedBox(
                            width: 42.0,
                            height: 20.0,
                            child: TextField(
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: font_color),
                              )),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: font_color,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                                NumericRangeFormatter(
                                    min: min, max: final_max_except_count),
                              ],
                              onChanged: (value) {
                                int targetExceptCount = int.parse(value);
                                print(targetExceptCount);
                                setState(() {
                                  target_except_count = value;
                                });
                              },
                              controller: textEditingController2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 340,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                min = 0;
                                max_count = 22;
                                max_except_count = 286;
                                final_max_except_count = 286;
                                dropdownList_some_level = ['1', '2', '3', '4', '5'];
                                selectedDropdown_some_level = '2';
                                selectedDropdown_level = '7';
                                cost = cost_2;
                                font_color = Colors.white;
                                textEditingController1.text = '';
                                textEditingController2.text = '';
                                probability = '';
                              });
                            },
                            child: Container(
                              width: 155,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: TTT_sky_blue,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.trip_origin,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '초기화하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquareB',
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.0,
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print('level = $level');
                              print('cost = $target_cost');
                              print('tc = $target_count');
                              print('tec = $target_except_count');
                              result = await getData_fromFirebase(level,
                                  target_cost, target_count, target_except_count);
                              print(result);
                              setState(() {
                                probability = result['E'];
                                expectation = result['F'];
                              });
                            },
                            child: Container(
                              width: 155,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calculate_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '계산하기',
                                    style: TextStyle(
                                      fontFamily: 'NanumSquareB',
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                      height: 20.0,
                    ),
                    Container(
                      width: 340,
                      height: 170,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cost,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '리롤 1번에 1장 이상 등장할 확률',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: font_color,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: 300,
                            height: 40,
                            padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '$probability' + '%',
                                style: TextStyle(
                                  fontFamily: 'NanumSquareB',
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '$expectation' + '원을 쓰면 1장 이상\n' + '찾을 수 있다고 기대됩니다',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: font_color,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 340,
                      padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cost),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '추가 설명',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            """계산된 확률은 상대방의 상점이 존재하지 않는다는 가정 하에 계산된 확률입니다. 목표로 하는 기물이 상대방 상점에 떠 있을 경우 계산된 확률과 다소 차이가 발생할 수 있습니다.""",
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            '아래에 따라 입력 가능한 최대값이 정해집니다.\n'
                            +'1코스트 기물 개수 = 29, 총 개수 = 377\n'
                            +'2코스트 기물 개수 = 22, 총 개수 = 286\n'
                            +'3코스트 기물 개수 = 18, 총 개수 = 234\n'
                            +'4코스트 기물 개수 = 12, 총 개수 = 144\n'
                            +'5코스트 기물 개수 = 10, 총 개수 = 80',
                            style: TextStyle(
                              fontFamily: 'NanumSquareB',
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
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
        ),
      ),
    );
  }
}
