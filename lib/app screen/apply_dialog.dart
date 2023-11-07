import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:top_tier_tutor/building app/colors.dart';
import 'package:top_tier_tutor/app screen/schedule_coach.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'package:top_tier_tutor/schedule/utils.dart';

Future<dynamic> showApplyEventDialog(BuildContext context, String plan, String coach_name) async {
  await showDialog(
    context: context,
    builder: (_) {
      return modify_dialog(plan, coach_name);
    },
  );
}

class modify_dialog extends StatefulWidget {
  const modify_dialog(this.plan, this.coach_name);
  final plan;
  final coach_name;

  @override
  State<modify_dialog> createState() => _modify_dialogState();
}

final textEditingController = TextEditingController();

class _modify_dialogState extends State<modify_dialog> {
  String fee = '';
  Map reload_Events = {};
  String plan = '';
  String coach_name = '';

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  Duration start_duration = Duration(hours: 00, minutes: 00);
  Duration end_duration = Duration(hours: 01, minutes: 00);
  String ssDuration = '0:00';
  String ssDuration_check = '';
  String seDuration = '1:00';
  String seDuration_check = '';

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
  void initState() {
    super.initState();
    plan = widget.plan;
    ssDuration = plan.split(' ')[2];
    ssDuration_check = ssDuration;
    seDuration = plan.split(' ')[6];
    seDuration_check = seDuration;
    textEditingController.addListener(() {});
    textEditingController.text = plan.split(' ')[10];
    coach_name = widget.coach_name;
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
        '코칭 시간 선택',
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8.0, 10.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    '시작 시간',
                    style: TextStyle(
                      fontFamily: 'NanumSquare',
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    '$ssDuration',
                    style: TextStyle(
                      fontFamily: 'NanumSquare',
                      color: TTT_dark_blue,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Time Picker2
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8.0, 10.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    '종료 시간',
                    style: TextStyle(
                      fontFamily: 'NanumSquare',
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    '$seDuration',
                    style: TextStyle(
                      fontFamily: 'NanumSquare',
                      color: TTT_dark_blue,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
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
                    readOnly: true,
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
                    },
                    controller: textEditingController,
                  ),
                ),
              ],
            ),
          ),
          //코칭 소개글 입력
          //buildTextField(controller: descpController, hint: '코칭 소개글 입력(선택)'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // bool flag = true;
            // print('add data');
            // final user = FirebaseAuth.instance.currentUser;
            // Map user_info = await getUserInfo_fromFirebase(user!.uid);
            // String summoner_name = user_info['name'];
            // var db = FirebaseFirestore.instance;
            // final washingtonRef = db.collection("user").doc(summoner_name);
            //
            // try {
            //   Map schedule = await getScheduleData(
            //       selectedDayData.toString().split(' ')[0], summoner_name);
            //   List schedule_list = schedule.keys.toList();
            //   print('schedule');
            //   print(schedule_list);
            //   List end_plan_as_digit = [];
            //
            //   int start_duration_as_digit = int.parse(
            //       ssDuration.split(':')[0] + ssDuration.split(':')[1]);
            //   int origin_end_plan_as_digit = int.parse(
            //       seDuration_check.split(':')[0] +
            //           seDuration_check.split(':')[1]);
            //
            //   for (String plan in schedule_list) {
            //     end_plan_as_digit.add(int.parse(
            //         plan.split(' ')[2].split(':')[0] +
            //             plan.split(' ')[2].split(':')[1]));
            //     print(end_plan_as_digit);
            //   }
            //   print('end_plan');
            //   print(end_plan_as_digit);
            //   end_plan_as_digit.remove(origin_end_plan_as_digit);
            //   print(end_plan_as_digit);
            //   //00:20같은 데이터를 수정 + 2400 (이미 고려한 조건문)
            //   for (int i = 0; i < end_plan_as_digit.length; i++) {
            //     if (end_plan_as_digit[i] < 100) {
            //       end_plan_as_digit[i] = end_plan_as_digit[i] + 2400;
            //     }
            //   }
            //   end_plan_as_digit.sort();
            //   print(end_plan_as_digit);
            //   print(start_duration_as_digit);
            //   for (int i = 0; i < end_plan_as_digit.length; i++) {
            //     if (end_plan_as_digit[i] - start_duration_as_digit < 200 &&
            //         end_plan_as_digit[i] - start_duration_as_digit > 0) {
            //       flag = false;
            //       break;
            //     }
            //   }
            // } catch (e) {
            //   print(e);
            // }
            // //시간이 안 겹치는지를 확인
            // if (flag) {
            //   //겹치는 시간이 없다면 기존 값 삭제 및 값 추가
            //   washingtonRef.update({
            //     "schedule.${selectedDayData.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check":
            //         FieldValue.delete(),
            //     "schedule.${selectedDayData.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check.시작":
            //         FieldValue.delete(),
            //     "schedule.${selectedDayData.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check.종료":
            //         FieldValue.delete(),
            //   });
            //   washingtonRef.set({
            //     "schedule": {
            //       '${selectedDayData.toString().split(' ')[0]}': {
            //         '$ssDuration - $seDuration': {
            //           '시작': '$ssDuration',
            //           '종료': '$seDuration',
            //           '금액': '${textEditingController.text}',
            //           '코치': '$coach_name'
            //         }
            //       }
            //     },
            //   }, SetOptions(merge: true)).then(
            //       (value) => print("DocumentSnapshot successfully updated!"),
            //       onError: (e) => print("Error updating document $e"));
            //   Events = await getScheduleDataFromFireBase('$summoner_name');
            //   print(Events);
            //   // ignore: use_build_context_synchronously
            //   Navigator.pop(context);
            // } else {
            //   Navigator.pop(context);
            //   Fluttertoast.showToast(
            //     msg: '일정이 중복됩니다! 일정 삭제 후 등록해주세요',
            //     gravity: ToastGravity.BOTTOM,
            //   );
            // }
          },
          child: Text(
            '신청하기',
            style: TextStyle(
              fontFamily: 'NanumSquare',
              color: TTT_dark_blue,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
