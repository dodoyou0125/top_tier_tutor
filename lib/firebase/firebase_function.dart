import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier_tutor/schedule/utils.dart';

// ignore: non_constant_identifier_names
//리롤 계산기에 데이터 넘겨주는 함수
getData_fromFirebase(String level, String target_cost, String target_count,
    String target_except_count) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result = await firestore
      .collection("reroll_table")
      .where("A", isEqualTo: '$level')
      .where("B", isEqualTo: '$target_cost')
      .where("C", isEqualTo: '$target_count')
      .where("D", isEqualTo: '$target_except_count')
      .get();

  print('here');
  print(result.docs[0].data());
  print('there');
  return result.docs[0].data();
}

getUserInfo_fromFirebase(String? uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result =
      await firestore.collection("user").where("uid", isEqualTo: uid).get();

  print('here');
  print(result.docs[0].data());
  print('there');
  return result.docs[0].data();
}

getCoachProfileInfo(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    var result = await firestore
        .collection("user")
        .where("name", isEqualTo: '$name')
        .get();
    print('here_getCoachProfile');
    print(result.docs[0].data());
    return result.docs[0].data();
  } catch (e) {
    print("코치 데이터베이스에 없습니다");
    return null;
  }
}

getCoachTmpProfileInfo(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    var result = await firestore
        .collection("user")
        .where("name", isEqualTo: '$name')
        .get();
    print('here_getCoachTmpProfile');
    print(result.docs[0].data());
    return result.docs[0].data();
  } catch (e) {
    return null;
  }
}

///이름으로부터 해당되는 날짜의 예약 스케줄을 모두 반환
getScheduleData(String selectedDayData, String name) async {
  print(name);
  print(selectedDayData);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result = await firestore
      .collection("user")
      .where("name", isEqualTo: '$name')
      .get();
  return result.docs[0].data()["schedule"]["$selectedDayData"];
  print(result.docs[0].data()["schedule"]["$selectedDayData"]);
}

///이름을 매개변수로 하여 모든 Events를 반환함
Future<Map<DateTime, List<Event>>> getScheduleDataFromFireBase(
    String name) async {
  //print(name);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result = await firestore
      .collection("user")
      .where("name", isEqualTo: '$name')
      .get();
  //print(result.docs[0].data()["schedule"]);
  Map? tmp = result.docs[0].data()["schedule"];
  //print(tmp);
  Map<DateTime, List<Event>> Events = {};
  List<Event> Events_list = [];
  tmp?.keys.toList().forEach((key) {
    //print(key);
    Map tmp_key = tmp[key];
    //print(tmp[key]);
    List<Event> Events_list = [];
    List list_for_sort = tmp_key.keys.toList();
    //print(list_for_sort[0].split(' ')[0].split(':')[0]);
    list_for_sort.sort((a, b) => int.parse(a.split(' ')[0].split(':')[0])
        .compareTo(int.parse(b.split(' ')[0].split(':')[0])));
    list_for_sort.forEach((small_key) {
      //print(tmp[key][small_key]);
      //print(tmp[key][small_key]["시작"].runtimeType);
      // print(small_key);
      // print(small_key.runtimeType);
      // list_for_sort.add(int.parse(small_key.split(' ')[0].split(':')[0]+small_key.split(' ')[0].split(':')[0]));
      if (tmp[key][small_key]["시작"] != null){
        String startend =
            "시작 : ${tmp[key][small_key]["시작"]} ~ 종료 : ${tmp[key][small_key]["종료"]}";
        // print(startend);
        // print(startend.length);
        // if (startend.length < 23){
        //   print('here');
        //   for (int i = 0 ; i < 23 - startend.length + 1 ; i++){
        //     startend = startend + '    ';
        //   }
        //   startend = startend + ' ';
        // }
        // print(startend);
        String fee = "금액 : ${tmp[key][small_key]["금액"]}";
        Events_list.add(make_event(startend + '  ' + fee));
      }
    });
    Events.addAll({DateTime.parse(key): Events_list});
    //print('Events list');
    //print(Events_list.runtimeType);
  });
  print('Events');
  print(Events.runtimeType);
  return Events;
}

///코치의 일정을 반환하되, 토큰 가격으로 보이게 끔 리턴하는 함수
Future<Map<DateTime, List<Event>>> getScheduleDataFromFireBaseToken(
    String name) async {
  //print(name);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result = await firestore
      .collection("user")
      .where("name", isEqualTo: '$name')
      .get();
  //print(result.docs[0].data()["schedule"]);
  Map? tmp = result.docs[0].data()["schedule"];
  //print(tmp);
  Map<DateTime, List<Event>> Events = {};
  List<Event> Events_list = [];
  tmp?.keys.toList().forEach((key) {
    //print(key);
    Map tmp_key = tmp[key];
    //print(tmp[key]);
    List<Event> Events_list = [];
    List list_for_sort = tmp_key.keys.toList();
    //print(list_for_sort[0].split(' ')[0].split(':')[0]);
    list_for_sort.sort((a, b) => int.parse(a.split(' ')[0].split(':')[0])
        .compareTo(int.parse(b.split(' ')[0].split(':')[0])));
    list_for_sort.forEach((small_key) {
      //print(tmp[key][small_key]);
      //print(tmp[key][small_key]["시작"].runtimeType);
      // print(small_key);
      // print(small_key.runtimeType);
      // list_for_sort.add(int.parse(small_key.split(' ')[0].split(':')[0]+small_key.split(' ')[0].split(':')[0]));
      if (tmp[key][small_key]["시작"] != null){
        String startend =
            "시작 : ${tmp[key][small_key]["시작"]} ~ 종료 : ${tmp[key][small_key]["종료"]}";
        // print(startend);
        // print(startend.length);
        // if (startend.length < 23){
        //   print('here');
        //   for (int i = 0 ; i < 23 - startend.length + 1 ; i++){
        //     startend = startend + '    ';
        //   }
        //   startend = startend + ' ';
        // }
        // print(startend);
        String fee = "금액 : ${tmp[key][small_key]["가격"]}";
        Events_list.add(make_event(startend + '  ' + fee));
      }
    });
    Events.addAll({DateTime.parse(key): Events_list});
    //print('Events list');
    //print(Events_list.runtimeType);
  });
  print('Events');
  print(Events.runtimeType);
  return Events;
}

///이름을 매개변수로 하여 모든 Events를 반환함
Future<Map<DateTime, List<Event>>> getScheduleDataFromFireBase_ForUser(
    String name) async {
  //print(name);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var result = await firestore
      .collection("user")
      .where("name", isEqualTo: '$name')
      .get();
  //print(result.docs[0].data()["schedule"]);
  Map? tmp = result.docs[0].data()["schedule"];
  //print(tmp);
  Map<DateTime, List<Event>> Events = {};
  List<Event> Events_list = [];
  tmp?.keys.toList().forEach((key) {
    //print(key);
    Map tmp_key = tmp[key];
    //print(tmp[key]);
    List<Event> Events_list = [];
    List list_for_sort = tmp_key.keys.toList();
    //print(list_for_sort[0].split(' ')[0].split(':')[0]);
    list_for_sort.sort((a, b) => int.parse(a.split(' ')[0].split(':')[0])
        .compareTo(int.parse(b.split(' ')[0].split(':')[0])));
    list_for_sort.forEach((small_key) {
      //print(tmp[key][small_key]);
      //print(tmp[key][small_key]["시작"].runtimeType);
      // print(small_key);
      // print(small_key.runtimeType);
      // list_for_sort.add(int.parse(small_key.split(' ')[0].split(':')[0]+small_key.split(' ')[0].split(':')[0]));
      if (tmp[key][small_key]["시작"] != null){
        String startend =
            "시작 : ${tmp[key][small_key]["시작"]} ~ 종료 : ${tmp[key][small_key]["종료"]}";
        // print(startend);
        // print(startend.length);
        // if (startend.length < 23){
        //   print('here');
        //   for (int i = 0 ; i < 23 - startend.length + 1 ; i++){
        //     startend = startend + '    ';
        //   }
        //   startend = startend + ' ';
        // }
        // print(startend);
        String coach = "코치 : ${tmp[key][small_key]["코치"]}";
        Events_list.add(make_event(startend + '\n' + '    ' + coach));
      }
    });
    Events.addAll({DateTime.parse(key): Events_list});
    //print('Events list');
    //print(Events_list.runtimeType);
  });
  print('Events');
  print(Events.runtimeType);
  return Events;
}
