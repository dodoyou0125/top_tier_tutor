// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_tier_tutor/app%20screen/schedule_user.dart';

import 'package:top_tier_tutor/building app/colors.dart';
import 'package:top_tier_tutor/app screen/schedule_coach.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'package:top_tier_tutor/schedule/utils.dart';

Future<dynamic> showDeleteEventDialog(BuildContext context, String plan, DateTime selectedDayData_User) async {
  await showDialog(
    context: context,
    builder: (_) {
      return delete_dialog(plan, selectedDayData_User);
    },
  );
}

class delete_dialog extends StatefulWidget {
  const delete_dialog(this.plan, this.selectedDayData_User);
  final plan;
  final selectedDayData_User;

  @override
  State<delete_dialog> createState() => _delete_dialogState();
}

final textEditingController = TextEditingController();

class _delete_dialogState extends State<delete_dialog> {
  DateTime selectedDayData_User = DateTime.now();

  String fee = '';
  Map reload_Events = {};
  String plan = '';

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

  Future<Map> updataEvents(String name) async{
    reload_Events = await getScheduleDataFromFireBase('$name');
    return reload_Events;
  }

  @override
  void initState() {
    super.initState();
    plan = widget.plan;
    ssDuration = plan.split(' ')[2];
    ssDuration_check = ssDuration;
    seDuration = plan.split(' ')[6].replaceAll(' ', '').replaceAll('\n', '');
    seDuration_check = seDuration;
    print(seDuration);
    textEditingController.addListener(() {});
    textEditingController.text = plan.split(' ')[12];
    selectedDayData_User = widget.selectedDayData_User;
    print(selectedDayData_User);
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
        '예약 취소',
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
                  '${selectedDayData_User.toString().split(' ')[0]}',
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
                      onPressed: () => null,
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
                      onPressed: () => null,
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
          //코치
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 10.0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '코치',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 85.0,
                  height: 20.0,
                  child: Theme(
                    data: ThemeData(
                      disabledColor: Colors.black,
                    ),
                    child: TextField(
                      enabled: false,
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.5, 10.0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '코칭 시작 시간을 기준으로\n'+'12시간 전까지 취소 가능합니다.',
                  style: TextStyle(
                    fontFamily: 'NanumSquare',
                    color: Colors.black,
                    fontSize: 11.0,
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
            DateTime now = DateTime.now();
            DateTime want_to_delete = selectedDayData_User.add(Duration(hours: int.parse(ssDuration.split(':')[0]), minutes: int.parse(ssDuration.split(':')[1]))).subtract(Duration(hours: 12));
            print('want to delete = $want_to_delete');
            print(selectedDayData_User);
            bool flag = true;
            print('add data');
            final user = FirebaseAuth.instance.currentUser;
            Map user_info = await getUserInfo_fromFirebase(user!.uid);
            String summoner_name = user_info['name'];
            var db = FirebaseFirestore.instance;
            final washingtonRef = db.collection("user").doc(summoner_name);

            if (want_to_delete.isAfter(now)) {
              //겹치는 시간이 없다면 기존 값 삭제 및 값 추가
              washingtonRef.update({
                "schedule.${selectedDayData_User.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check":
                FieldValue.delete(),
                "schedule.${selectedDayData_User.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check.시작":
                FieldValue.delete(),
                "schedule.${selectedDayData_User.toString().split(' ')[0]}.$ssDuration_check - $seDuration_check.종료":
                FieldValue.delete(),
              }).then(
                      (value) => print("DocumentSnapshot successfully updated!"),
                  onError: (e) => print("Error updating document $e"));
              EventsUser = await getScheduleDataFromFireBase_ForUser('$summoner_name');
              //print(Events);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg:
                '예약을 취소했습니다',
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg:
                '취소할 수 없는 예약입니다. 시간을 확인하세요',
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
          child: Text(
            '취소하기',
            style: TextStyle(
              fontFamily: 'NanumSquare',
              color: Colors.redAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
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
