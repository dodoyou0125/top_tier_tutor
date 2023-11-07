// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:top_tier_tutor/app%20screen/apply_dialog.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:top_tier_tutor/app%20screen/modify_dialog.dart';
import 'package:top_tier_tutor/app%20screen/payment_screen.dart';
import 'package:top_tier_tutor/app%20screen/reroll_cal.dart';
import 'package:top_tier_tutor/app%20screen/schedule_coach.dart';
import 'package:top_tier_tutor/app%20screen/schedule_user.dart';
import 'package:top_tier_tutor/app%20screen/token_charge.dart';
import 'package:top_tier_tutor/building%20app/colors.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app%20screen/alert_dialog.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'package:top_tier_tutor/schedule/utils.dart';
import 'package:intl/date_symbol_data_local.dart';

class user_schedule_reservation extends StatefulWidget {
  user_schedule_reservation({this.event, this.coach_name});
  final event;
  final coach_name;
  @override
  State<user_schedule_reservation> createState() =>
      _user_schedule_reservationState();
}

DateTime selectedDayData = DateTime.now();
Map Events = {};
String coach_name = '';

class _user_schedule_reservationState extends State<user_schedule_reservation> {
  bool isloading = false;
  late Map user_info;
  String summoner_name = '';


  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;
  var washingtonRef;
  List<bool> selected_list = List.generate(25, (i) => false);
  List _reservation = List.generate(25, (i) => null);
  List reservation = [];

  int _selectedIndex = 1;
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
  void initState() {
    super.initState();
    Events = widget.event;
    coach_name = widget.coach_name;
    print(Events);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    print('_selectedEvetns : $_selectedEvents');
    setState(() {
      _asyncMethod();
      DateTime _tmp = DateTime.parse(_focusedDay.toString().split(' ')[0]);
      _selectedEvents.value = _getEventsForDay(_tmp);
    });
    selectedDayData = DateTime.now();
  }

  //ko_KR 설정 위함
  _asyncMethod() async {
    await initializeDateFormatting();
    final user = FirebaseAuth.instance.currentUser;
    Map user_info = await getUserInfo_fromFirebase(user!.uid);
    String summoner_name = user_info['name'];
    var db = FirebaseFirestore.instance;
    washingtonRef = db.collection("user").doc(summoner_name);
    //kEvents = await getScheduleDataFromFireBase('Kanata Ch');
    //print('here = $kEvents');
    // print('here = $k_Events');
    //print(kEvents.runtimeType);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    // print(day);
    //print('kEvents[day] = ${kEvents[day]}');
    //print('kEvents[day] = ${kEvents[day].runtimeType}');
    //print(day.toString().replaceFirst('Z', ''));
    day = DateTime.parse(day.toString().replaceFirst('Z', ''));
    //print('day : $day');
    //print(day);
    //print(Events[day]);
    return Events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      selectedDay =
          DateTime.parse(selectedDay.toString().replaceFirst('Z', ''));
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        print('ondayselected: $_selectedDay');
        print(_focusedDay);
        selectedDayData = selectedDay;
        print(selectedDay);
        selected_list = List.generate(25, (i) => false);
        _reservation = List.generate(25, (i) => '');
        reservation = [];
      });
      //print(selectedDayData);
      //ListView 생성에 영향을 줌
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TTT_dark_blue,
        centerTitle: true,
        title: Text(
          '코칭 일정 선택하기',
          style: TextStyle(
            fontFamily: 'NanumSquare',
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height -
                2 -
                kBottomNavigationBarHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar<Event>(
                    availableGestures: AvailableGestures.horizontalSwipe,
                    locale: 'ko_KR',
                    daysOfWeekHeight: 20,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: _onDaySelected,
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: const TextStyle(
                        fontSize: 18.0,
                        color: TTT_sky_blue,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                        markerDecoration: BoxDecoration(
                          color: TTT_dark_blue,
                          shape: BoxShape.circle,
                        ),
                        isTodayHighlighted: false,
                        selectedDecoration: BoxDecoration(
                            color: TTT_sky_blue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0))),
                    // rangeStartDay: _rangeStart,
                    // rangeEndDay: _rangeEnd,
                    // calendarFormat: _calendarFormat,
                    // rangeSelectionMode: _rangeSelectionMode,
                    // calendarStyle: CalendarStyle(
                    //   // Use `CalendarStyle` to customize the UI
                    //   outsideDaysVisible: false,
                    // ),
                    // onFormatChanged: (format) {
                    //   if (_calendarFormat != format) {
                    //     setState(() {
                    //       _calendarFormat = format;
                    //     });
                    //   }
                    // },
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 6.0,
                          width: 30,
                          color: TTT_dark_blue,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '선택되지 않음',
                          style: TextStyle(
                            fontFamily: 'NanumSquare',
                            color: Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          height: 6.0,
                          width: 30,
                          color: TTT_sky_blue,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '선택됨',
                          style: TextStyle(
                            fontFamily: 'NanumSquare',
                            color: Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Container(
                    height: 400.0,
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              child: ListTile(
                                  tileColor: selected_list[index]
                                      ? TTT_sky_blue
                                      : TTT_dark_blue,
                                  textColor: Colors.white,
                                  //leading: Icon(Icons.radio_button_unchecked),
                                  title: Row(
                                    children: [
                                      Text('${index + 1}. ${value[index]} '),
                                      Image(
                                        image:
                                            AssetImage('images/TTT_Token.png'),
                                        fit: BoxFit.cover,
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                  //trailing: Icon(Icons.),
                                  onTap: () {
                                    print('${value[index]} + $value');
                                    setState(() {
                                      selected_list[index] =
                                          !selected_list[index];
                                      if (selected_list[index] == true) {
                                        _reservation[index] =
                                            value[index].toString();
                                        reservation.add(value[index].toString());
                                      } else {
                                        _reservation[index] = null;
                                        reservation.removeWhere((element) => element == value[index].toString());
                                      }
                                      print('reservation: $reservation');
                                      print(_reservation);
                                    });
                                    // showApplyEventDialog(
                                    //     context, '${value[index]}', coach_name)
                                    //     .then((value) => setState(() {
                                    //   DateTime _tmp = DateTime.parse(_focusedDay.toString().split(' ')[0]);
                                    //   _selectedEvents.value = _getEventsForDay(_tmp);
                                    // }));
                                  }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          for (int i = 0; i < reservation.length; i++) {
            if (reservation[i] != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return payment_screen(
                    reservation: reservation, date: _selectedDay, coach_name: coach_name);
              }));
              return;
            }
          }
          Fluttertoast.showToast(
            msg: '예약할 시간을 선택해 주세요',
            gravity: ToastGravity.BOTTOM,
          );
        },
        label: Column(
          children: [
            Text(
              '결제하기',
              style: TextStyle(
                fontFamily: 'NanumSquare',
                color: Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Icon(
              Icons.payment,
              color: Colors.white,
            ),
          ],
        ),
        shape: CircleBorder(),
        backgroundColor: TTT_sky_blue,
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
}
