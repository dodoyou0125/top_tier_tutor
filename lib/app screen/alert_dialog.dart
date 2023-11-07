import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:top_tier_tutor/building app/colors.dart';
import 'package:top_tier_tutor/app screen/schedule_coach.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'package:top_tier_tutor/schedule/utils.dart';

Future<dynamic> showAddEventDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) {
      return alert_dialog();
    },
  );
}

class alert_dialog extends StatefulWidget {
  const alert_dialog({super.key});

  @override
  State<alert_dialog> createState() => _alert_dialogState();
}

class _alert_dialogState extends State<alert_dialog> {

  int TTT_Token = 0;
  int Money = 0;

  String fee = '';
  // String introduction = '';
  Map reload_Events = {};

  final descpController = TextEditingController();

  Duration start_duration = Duration(hours: 00, minutes: 00);
  Duration end_duration = Duration(hours: 01, minutes: 00);
  String ssDuration = '0:00';
  String seDuration = '1:00';

  var f = NumberFormat('###,###,###,###');

  //코칭 금액을 입력 받아 그 값의 범위에 따라 Token 단위로 변경하는 함수
  int change_as_token(String coach_fee){
    int token = 0;
    String fee = change_as_string(coach_fee);
    int int_fee = int.parse(fee);
    if (int_fee < 20000){
      token = (int_fee*1.237/12.31).round();
    }
    else if (int_fee < 30000){
      token = (int_fee*1.235/12.31).round();
    }
    else if (int_fee < 50000){
      token = (int_fee*1.2335/12.31).round();
    }
    else{
      token = (int_fee*1.2325/12.31).round();
    }
    return token;
  }

  String change_as_string (String coach_fee){
    var list = coach_fee.split('');
    String fee = '';
    for (String i in list){
      if (isNumeric(i)){
        print(i);
        print(i.runtimeType);
        fee += i;
        print(fee);
      }
    }
    return fee;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts
  // a CupertinoTimerPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Widget buildTextField(
      {String? hint, required TextEditingController controller}) {
    return SizedBox(
      height: 45.0,
      child: TextField(
        onChanged: (value) {
          // introduction = value;
        },
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: hint ?? '',
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: TTT_dark_blue, width: 1.2),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: TTT_dark_blue, width: 1.2),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      backgroundColor: Colors.white,
      title: Text(
        '코칭 일정을 추가하세요',
        style: TextStyle(
          fontFamily: 'NanumSquare',
          color: TTT_dark_blue,
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          //날짜
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '날짜',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '${selectedDayData_Coach.toString().split(' ')[0]}',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          //Time Picker1
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _TimerPickerItem(
                  children: <Widget>[
                    const Text(
                      '시작 시간',
                      style: TextStyle(
                        fontFamily: 'NanumSquare',
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    CupertinoButton(
                      // Display a CupertinoTimerPicker with hour/minute mode.
                      onPressed: () => _showDialog(
                        CupertinoTimerPicker(
                          minuteInterval: 5,
                          mode: CupertinoTimerPickerMode.hm,
                          initialTimerDuration: start_duration,
                          // This is called when the user changes the timer's
                          // duration.
                          onTimerDurationChanged: (Duration newDuration) {
                            print('changed');
                            print(newDuration);
                            setState(() {
                              if (newDuration.inHours == 23) {
                                Duration calDuration =
                                    newDuration - Duration(hours: 23);
                                start_duration = newDuration;
                                end_duration = calDuration;
                                ssDuration =
                                    "${newDuration.inHours}:${newDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                                seDuration =
                                    "${calDuration.inHours}:${calDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                              } else {
                                Duration calDuration =
                                    newDuration + Duration(hours: 1);
                                start_duration = newDuration;
                                end_duration = calDuration;
                                ssDuration =
                                    "${newDuration.inHours}:${newDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                                seDuration =
                                    "${calDuration.inHours}:${calDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                              }
                            });
                            ;
                          },
                        ),
                      ),
                      // In this example, the timer's value is formatted manually.
                      // You can use the intl package to format the value based on
                      // the user's locale settings.
                      child: Text(
                        '$ssDuration',
                        style: TextStyle(
                          fontFamily: 'NanumSquare',
                          color: TTT_dark_blue,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Time Picker2
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _TimerPickerItem(
                  children: <Widget>[
                    const Text(
                      '종료 시간',
                      style: TextStyle(
                        fontFamily: 'NanumSquare',
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    CupertinoButton(
                      // Display a CupertinoTimerPicker with hour/minute mode.
                      onPressed: () => _showDialog(
                        CupertinoTimerPicker(
                          minuteInterval: 5,
                          mode: CupertinoTimerPickerMode.hm,
                          initialTimerDuration: start_duration,
                          // This is called when the user changes the timer's
                          // duration.
                          onTimerDurationChanged: (Duration newDuration) {
                            print('changed');
                            print(newDuration);
                            setState(() {
                              if (newDuration.inHours == 0) {
                                Duration calDuration =
                                    newDuration + Duration(hours: 23);
                                start_duration = calDuration;
                                end_duration = newDuration;
                                ssDuration =
                                    "${calDuration.inHours}:${calDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                                seDuration =
                                    "${newDuration.inHours}:${newDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                              } else {
                                Duration calDuration =
                                    newDuration - Duration(hours: 1);
                                start_duration = calDuration;
                                end_duration = newDuration;
                                ssDuration =
                                    "${calDuration.inHours}:${calDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                                seDuration =
                                    "${newDuration.inHours}:${newDuration.inMinutes.remainder(60).toString().padLeft(2, "0")}";
                              }
                            });
                            ;
                          },
                        ),
                      ),
                      // In this example, the timer's value is formatted manually.
                      // You can use the intl package to format the value based on
                      // the user's locale settings.
                      child: Text(
                        '$seDuration',
                        style: TextStyle(
                          fontFamily: 'NanumSquare',
                          color: TTT_dark_blue,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          //금액
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '금액',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: 'ko',
                        decimalDigits: 0,
                        symbol: '￦',
                      ),
                    ],
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      fee = value;
                      print(fee);
                      setState(() {
                        TTT_Token = change_as_token(fee);
                        Money = (int.parse(change_as_string(fee))*0.956).floor();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          //표기금액
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 10, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '표기금액',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${f.format(TTT_Token)}',
                      style: TextStyle(
                        fontFamily: 'NanumSquare',
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Image(
                      image: AssetImage('images/TTT_Token.png'),
                      fit: BoxFit.cover,
                      height: 17,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          //실수령액
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '실수령액',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\u20A9${f.format(Money)}',
                      style: TextStyle(
                        fontFamily: 'NanumSquare',
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      width: 9.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          //코칭 소개글 입력
          // buildTextField(
          //   controller: descpController,
          //   hint: '코칭 소개글 입력(선택)',
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            bool flag = true;
            print('add data');
            final user = FirebaseAuth.instance.currentUser;
            Map user_info = await getUserInfo_fromFirebase(user!.uid);
            String summoner_name = user_info['name'];
            var db = FirebaseFirestore.instance;
            final washingtonRef = db.collection("user").doc(summoner_name);

            try {
              Map schedule = await getScheduleData(
                  selectedDayData_Coach.toString().split(' ')[0], summoner_name);
              List schedule_list = schedule.keys.toList();

              List end_plan_as_digit = [];
              int start_duration_as_digit = int.parse(
                  ssDuration.split(':')[0] + ssDuration.split(':')[1]);
              for (String plan in schedule_list) {
                end_plan_as_digit.add(int.parse(
                    plan.split(' ')[2].split(':')[0] +
                        plan.split(' ')[2].split(':')[1]));
                print(end_plan_as_digit);
              }
              //00:20같은 데이터를 수정 + 2400 (이미 고려한 조건문)
              for (int i = 0; i < end_plan_as_digit.length; i++) {
                if (end_plan_as_digit[i] < 100) {
                  end_plan_as_digit[i] = end_plan_as_digit[i] + 2400;
                }
              }
              end_plan_as_digit.sort();
              print(end_plan_as_digit);
              print(start_duration_as_digit);
              for (int i = 0; i < end_plan_as_digit.length; i++) {
                if (end_plan_as_digit[i] - start_duration_as_digit < 200 &&
                    end_plan_as_digit[i] - start_duration_as_digit > 0) {
                  flag = false;
                  break;
                }
              }
            } catch (e) {
              print(e);
            }
            //시간이 안 겹치는지를 확인
            if (flag) {
              //겹치는 시간이 없다면 값 추가
              washingtonRef.set({
                "schedule": {
                  '${selectedDayData_Coach.toString().split(' ')[0]}': {
                    '$ssDuration - $seDuration': {
                      '시작': '$ssDuration',
                      '종료': '$seDuration',
                      '금액': '$fee',
                      '가격': '$TTT_Token',
                    }
                  }
                },
              }, SetOptions(merge: true)).then(
                  (value) => print("DocumentSnapshot successfully updated!"),
                  onError: (e) => print("Error updating document $e"));
              ///여기서 코치에게 보여주는 이벤트 내용 서식 구성
              Events = await getScheduleDataFromFireBase('$summoner_name');
              print(Events);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: '일정이 중복됩니다! 일정 삭제 후 등록해주세요',
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
          child: Text(
            '추가하기',
            style: TextStyle(
              fontFamily: 'NanumSquare',
              color: TTT_dark_blue,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }
}

// This class simply decorates a row of widgets.
class _TimerPickerItem extends StatelessWidget {
  const _TimerPickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
