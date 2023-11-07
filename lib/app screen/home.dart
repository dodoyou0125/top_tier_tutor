// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:top_tier_tutor/app%20screen/reroll_cal.dart';
import 'package:top_tier_tutor/app%20screen/schedule_coach.dart';
import 'package:top_tier_tutor/app%20screen/schedule_user.dart';
import 'package:top_tier_tutor/app%20screen/token_charge.dart';
import 'dart:convert';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app screen/profile_coach.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:top_tier_tutor/app screen/profile_edit.dart';
import 'package:top_tier_tutor/app screen/login_page.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_tier_tutor/app screen/profile_exist.dart';

class home extends StatefulWidget {
  home({this.entries});
  final entries;

  @override
  State<home> createState() => _homeState();
}

final user_search = <String, String>{
  "image url": '',
  "name": '',
  "summoner data": '',
  "images": '',
  "rankinfo": '',
  "currentPatch Game": '',
};

class _homeState extends State<home> {
  bool isloading = false;

  String search = '';
  dynamic entries_now;
  dynamic rankinfo;
  int patchgamecount = 0;

  late Map user_info;
  String summoner_name = '';
  String tier = '';
  final user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    updateData(widget.entries);
    if (user != null) {
      _asyncMethod();
    }
  }

  _asyncMethod() async {
    //user info 확인하기
    user_info = await getUserInfo_fromFirebase(user!.uid);
    setState(() {
      summoner_name = user_info['name'];
      tier = user_info['tier'];
      print(summoner_name);
      print(tier);
    });
  }

  void updateData(dynamic entries) {
    print(entries_now);
    print(entries);
    entries_now = entries;
  }

  //For ChoiceChip
  int defaultChoiceIndex = 0;
  List<String> _choicesList = ['50', '100', '200', '300', '400', '500'];

  //For ChoiceChip2
  int defaultChoiceIndex2 = 0;
  List<String> _choicesList2 = ['이하', '이상', '제한 없음'];

  //For ChoiceChip3
  int defaultChoiceIndex3 = 0;
  List<String> _choicesList3 = ['실버', '골드', '플레', '다이아', '마스터'];

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
  int _selectedIndex = 0;
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
      isLoading : isloading,
      color: Colors.white,
      child: MaterialApp(
        home: Scaffold(
          //resizeToAvoidBottomInset : false,
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('images/main_page_logo.png'),
                  ),
                  accountName: Text(summoner_name),
                  accountEmail: Text(tier),
                  decoration: BoxDecoration(
                    color: Color(0xFF003399),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.manage_accounts),
                  iconColor: Color(0xFF003399),
                  focusColor: Color(0xFF003399),
                  title: Text('내 프로필 편집'),
                  onTap: () async {
                    setState(() {
                      isloading = true;
                    });
                    if (user_info['currentPatch Game'] == null) {
                      List<dynamic> result = await getData(summoner_name);
                      rankinfo = await getRankInfo(summoner_name);
                      patchgamecount = await getMatchData(summoner_name);

                      //값 업데이트
                      var db = FirebaseFirestore.instance;
                      final washingtonRef =
                          db.collection("user").doc(summoner_name);
                      washingtonRef.update({
                        "image url": result[0],
                        "name": result[1],
                        "summoner data": result[2],
                        "rankinfo": rankinfo,
                        "currentPatch Game": patchgamecount,
                      }).then(
                          (value) =>
                              print("DocumentSnapshot successfully updated!"),
                          onError: (e) => print("Error updating document $e"));

                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return profile_edit(
                              url: result[0],
                              name: result[1],
                              summonerdata: result[2],
                              image_name: result[3],
                              rankinfo: rankinfo,
                              currentPatch: patchgamecount);
                        }));
                      });
                    } else {
                      print('else');
                      print(user_info['summoner data']);
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return profile_edit(
                              url: user_info['image url'],
                              name: user_info['name'],
                              summonerdata: user_info['summoner data'],
                              image_name: user_info['images'],
                              rankinfo: user_info['rankinfo'],
                              currentPatch: user_info['currentPatch Game']);
                        }));
                      });
                    }
                    setState(() {
                      isloading = false;
                    });
                  },
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  iconColor: Color(0xFF003399),
                  focusColor: Color(0xFF003399),
                  title: Text('설정'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  iconColor: Color(0xFF003399),
                  focusColor: Color(0xFF003399),
                  title: Text('로그아웃'),
                  onTap: () async {
                    await viewModel.logout();
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return login_page();
                      }));
                    });
                  },
                  trailing: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              '탑 티어 튜터',
              style: TextStyle(
                fontFamily: 'NanumSquare',
                color: Color(0xFF003399),
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Color(0xFF003399),
                ),
              );
            }),
            actions: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.notifications,
                    color: Color(0xFF003399),
                  ))
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Top Tier Ranking
                      Container(
                        width: double.infinity,
                        height: 45.0,
                        color: Color(0xFF003399),
                        child: Center(
                          child: Text(
                            'Top Tier Ranking',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      //DataTable + ScrollView
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            dataRowMinHeight: 10.0,
                            dataRowMaxHeight: 25.0,
                            headingRowHeight: 35.0,
                            headingTextStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Color(0xFF0583F2)),
                            columnSpacing: 0,
                            columns: [
                              DataColumn(
                                  label: Expanded(
                                      child: Text('순위',
                                          textAlign: TextAlign.center))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text('티어',
                                          textAlign: TextAlign.center))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text('소환사명',
                                          textAlign: TextAlign.center))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text('LP',
                                          textAlign: TextAlign.center))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text('티어조건',
                                          textAlign: TextAlign.center))),
                              DataColumn(
                                  label: Expanded(
                                      child: Text('금액',
                                          textAlign: TextAlign.center))),
                            ],
                            rows: [
                              for (var rowData in entries_now)
                                DataRow(cells: [
                                  DataCell(Center(
                                      child: Text(
                                          (entries_now.indexOf(rowData) + 1)
                                              .toString()))),
                                  DataCell(Center(
                                    child: Image(
                                      image: AssetImage(
                                          'images/Challenger_Emblem_2022.png'),
                                      width: 35.0,
                                      height: 35.0,
                                    ),
                                  )),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 150),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 7),
                                        child: Text(rowData['summonerName'],
                                            style: TextStyle(
                                                fontFamily: 'NanumSquare',
                                                fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                  DataCell(Center(
                                    child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 150),
                                        child: Text(
                                            rowData['leaguePoints'].toString(),
                                            overflow: TextOverflow.ellipsis)),
                                  )),
                                  DataCell(Center(child: Text('TBD'))),
                                  DataCell(Center(child: Text('TBD'))),
                                ]),
                            ],
                          ),
                        ),
                      ),
                      //나에게 맞는 코치 검색하기
                      Container(
                        width: double.infinity,
                        height: 45.0,
                        color: Color(0xFF003399),
                        child: Center(
                          child: Text(
                            '나에게 맞는 코치 검색하기',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      //선택 옵션
                      Container(
                        height: 170,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 1.0,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  //소홤사명으로 검색 라인
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        '소환사명으로 검색',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      SizedBox(
                                        width: 185.0,
                                        height: 20.0,
                                        child: TextField(
                                          onChanged: (value) {
                                            search = value;
                                            print(search);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      //검색 버튼
                                      SizedBox(
                                        height: 25.0,
                                        width: 80.0,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Color(0xFF003399))),
                                          onPressed: () async {
                                            setState(() {
                                              isloading = true;
                                            });
                                            //존재하는 소환사인지
                                            try {
                                              search = await ConvertName(search);
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: '존재하지 않은 소환사입니다',
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              return;
                                            }

                                            //FireStore에 저장된 정보가 있는 코치인지
                                            //없다면 null을 반환
                                            var profile_data =
                                                await getCoachProfileInfo(search);
                                            if (profile_data != null) {
                                              print('here1');
                                              //코치 로그인 이력이 일단 있는 경우임
                                              //프로필이 등록된 코치인지(등록한 코치인지)
                                              if (profile_data['profile'] !=
                                                  null) {
                                                print('here2');
                                                setState(() {
                                                  isloading = false;
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return profile_coach(
                                                      url: profile_data[
                                                          'image url'],
                                                      name: profile_data['name'],
                                                      summonerdata: profile_data[
                                                          'summoner data'],
                                                      image_name:
                                                          profile_data['images'],
                                                      rankinfo: profile_data[
                                                          'rankinfo'],
                                                      currentPatch: profile_data[
                                                          'currentPatch Game'],
                                                      intro:
                                                          profile_data['profile']
                                                              ['코치 소개글'],
                                                      coach_fee:
                                                          profile_data['profile']
                                                              ['코칭 금액 토큰'],
                                                      Index:
                                                          profile_data['profile']
                                                              ['유저 게임 수'],
                                                      Index2:
                                                          profile_data['profile']
                                                              ['게임 수 조건'],
                                                      Index3:
                                                          profile_data['profile']
                                                              ['유저 티어'],
                                                      Index4:
                                                          profile_data['profile']
                                                              ['유저 조건'],
                                                      Index5:
                                                          profile_data['profile']
                                                              ['코칭 금액 단위'],
                                                    );
                                                  }));
                                                });
                                              } else {
                                                print('here3');
                                                //전적이 계산된 적은 있는 경우
                                                if (profile_data[
                                                        'summoner data'] !=
                                                    null) {
                                                  print('here4');
                                                  setState(() {
                                                    isloading = false;
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return profile_exist(
                                                          url: profile_data[
                                                              'image url'],
                                                          name: profile_data[
                                                              'name'],
                                                          summonerdata:
                                                              profile_data[
                                                                  'summoner data'],
                                                          image_name:
                                                              profile_data[
                                                                  'images'],
                                                          rankinfo: profile_data[
                                                              'rankinfo'],
                                                          currentPatch: profile_data[
                                                              'currentPatch Game']);
                                                    }));
                                                  });
                                                }
                                                //전적이 계산된 적도 없는 경우
                                                else {
                                                  print('here5');
                                                  List<dynamic> result =
                                                      await getData(search);
                                                  rankinfo =
                                                      await getRankInfo(search);
                                                  patchgamecount =
                                                      await getMatchData(search);

                                                  var db =
                                                      FirebaseFirestore.instance;

                                                  db
                                                      .collection("user")
                                                      .doc(search)
                                                      .set(user_search)
                                                      .onError((error,
                                                              stackTrace) =>
                                                          print(
                                                              "Error writing document: $error"));

                                                  final washingtonRef = db
                                                      .collection("user")
                                                      .doc(search);
                                                  washingtonRef.update({
                                                    "image url": result[0],
                                                    "name": result[1],
                                                    "summoner data": result[2],
                                                    "images": result[3],
                                                    "rankinfo": rankinfo,
                                                    "currentPatch Game":
                                                        patchgamecount,
                                                  }).then(
                                                      (value) => print(
                                                          "DocumentSnapshot successfully updated!"),
                                                      onError: (e) => print(
                                                          "Error updating document $e"));
                                                  setState(() {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return profile_exist(
                                                          url: result[0],
                                                          name: result[1],
                                                          summonerdata: result[2],
                                                          image_name: result[3],
                                                          rankinfo: rankinfo,
                                                          currentPatch:
                                                              patchgamecount);
                                                    }));
                                                  });
                                                }
                                              }
                                            } else {
                                              print('here6');
                                              List<dynamic> result =
                                                  await getData(search);
                                              rankinfo =
                                                  await getRankInfo(search);
                                              patchgamecount =
                                                  await getMatchData(search);

                                              var db = FirebaseFirestore.instance;

                                              db
                                                  .collection("user")
                                                  .doc(search)
                                                  .set(user_search)
                                                  .onError((error, stackTrace) =>
                                                      print(
                                                          "Error writing document: $error"));

                                              final washingtonRef = db
                                                  .collection("user")
                                                  .doc(search);
                                              washingtonRef.update({
                                                "image url": result[0],
                                                "name": result[1],
                                                "summoner data": result[2],
                                                "images": result[3],
                                                "rankinfo": rankinfo,
                                                "currentPatch Game":
                                                    patchgamecount,
                                              }).then(
                                                  (value) => print(
                                                      "DocumentSnapshot successfully updated!"),
                                                  onError: (e) => print(
                                                      "Error updating document $e"));
                                              setState(() {
                                                isloading = false;
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return profile_exist(
                                                      url: result[0],
                                                      name: result[1],
                                                      summonerdata: result[2],
                                                      image_name: result[3],
                                                      rankinfo: rankinfo,
                                                      currentPatch:
                                                          patchgamecount);
                                                }));
                                              });
                                              print('here7');
                                              Fluttertoast.showToast(
                                                msg: '코치로 등록되지 않은 소환사입니다',
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '검색',
                                                style: TextStyle(
                                                  color: Color(0xFF003399),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Icon(
                                                Icons.search,
                                                color: Color(0xFF003399),
                                                size: 18.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  //코칭 조건으로 검색 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        '코칭조건으로 검색',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
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
                                        width: 5.0,
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        children: List.generate(
                                            _choicesList.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList[index],
                                              style: TextStyle(fontSize: 11.0),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected: defaultChoiceIndex == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex = value
                                                    ? index
                                                    : defaultChoiceIndex;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  //게임 수 조건 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 113.0,
                                      ),
                                      Text(
                                        '조건',
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
                                            _choicesList2.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList2[index],
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex2 == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected:
                                                defaultChoiceIndex2 == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex2 = value
                                                    ? index
                                                    : defaultChoiceIndex2;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  //티어 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 113.0,
                                      ),
                                      Text(
                                        '티어',
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
                                            _choicesList3.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList3[index],
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex3 == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected:
                                                defaultChoiceIndex3 == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex3 = value
                                                    ? index
                                                    : defaultChoiceIndex3;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  //티어 조건 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 113.0,
                                      ),
                                      Text(
                                        '조건',
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
                                            _choicesList4.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList4[index],
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex4 == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected:
                                                defaultChoiceIndex4 == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex4 = value
                                                    ? index
                                                    : defaultChoiceIndex4;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  //코칭 금액 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        '코칭금액으로 검색',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        '금액',
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
                                            _choicesList5.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList5[index],
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex5 == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected:
                                                defaultChoiceIndex5 == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex5 = value
                                                    ? index
                                                    : defaultChoiceIndex5;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  //코칭 금액 조건 행
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 148.0,
                                      ),
                                      SizedBox(
                                        width: 100.0,
                                        height: 20.0,
                                        child: TextField(),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        children: List.generate(
                                            _choicesList6.length, (index) {
                                          return ChoiceChip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                color: Color(0xFF0583F2),
                                              ),
                                            ),
                                            labelPadding:
                                                EdgeInsets.fromLTRB(2, -4, 2, -4),
                                            label: Text(
                                              _choicesList6[index],
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            labelStyle: TextStyle(
                                              color: defaultChoiceIndex6 == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selected:
                                                defaultChoiceIndex6 == index,
                                            selectedColor: Color(0xFF0583F2),
                                            onSelected: (value) {
                                              setState(() {
                                                defaultChoiceIndex6 = value
                                                    ? index
                                                    : defaultChoiceIndex6;
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
                            SizedBox(
                              width: 1.0,
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
