// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:top_tier_tutor/app%20screen/delete_dialog.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:top_tier_tutor/app%20screen/modify_dialog.dart';
import 'package:top_tier_tutor/app%20screen/reroll_cal.dart';
import 'package:top_tier_tutor/building%20app/colors.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app%20screen/alert_dialog.dart';
import 'package:top_tier_tutor/firebase/firebase_function.dart';

import 'package:top_tier_tutor/schedule/utils.dart';
import 'package:intl/date_symbol_data_local.dart';

class schedule_user extends StatefulWidget {
  schedule_user({this.event});
  final event;
  @override
  State<schedule_user> createState() => _schedule_userState();
}

Map EventsUser = {};

class _schedule_userState extends State<schedule_user> {
  DateTime selectedDayData_User = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;
  var washingtonRef;

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
      Navigator.pushNamed(context, '/schedule_coach');
    } else if (index == 2)
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return reroll_cal();
      }));
    else if (index == 3) Navigator.pushNamed(context, '/account');
  }

  @override
  void initState() {
    super.initState();
    EventsUser = widget.event;
    print(EventsUser);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    print('_selectedEvetns : $_selectedEvents');
    setState(() {
      _asyncMethod();
      DateTime _tmp = DateTime.parse(_focusedDay.toString().split(' ')[0]);
      _selectedEvents.value = _getEventsForDay(_tmp);
    });
    selectedDayData_User = DateTime.now();
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
    //print(Events[day]);
    return EventsUser[day] ?? [];
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
        selectedDayData_User = selectedDay;
        print('SelectedUserDate : $selectedDayData_User');
        print(selectedDay);
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
        backgroundColor: TTT_dark_blue,
        centerTitle: true,
        title: Text(
          '내 예약 일정 확인',
          style: TextStyle(
            fontFamily: 'NanumSquare',
            color: Colors.white,
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
              color: Colors.white,
            ),
          );
        }),
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
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
                    height: 6.0,
                  ),
                  Container(
                    height: 400.0,
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final item = "${value[index]}";
                            return Container(
                              color: TTT_dark_blue,
                              height: 70.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              child: ListTile(
                                  textColor: Colors.white,
                                  //leading: Icon(Icons.radio_button_unchecked),
                                  title: Text('${index + 1}. ${value[index]}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '결제 완료',
                                        style: TextStyle(
                                          fontFamily: 'NanumSquare',
                                          color: TTT_light_sky_blue,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Text(
                                        '탭해서 취소',
                                        style: TextStyle(
                                          fontFamily: 'NanumSquare',
                                          color: Colors.white30,
                                        ),
                                      ),
                                    ],
                                  ),
                                onTap: (){
                                  showDeleteEventDialog(
                                      context, '${value[index]}', selectedDayData_User)
                                      .then((value) => setState(() {
                                    DateTime _tmp = DateTime.parse(_focusedDay.toString().split(' ')[0]);
                                    _selectedEvents.value = _getEventsForDay(_tmp);
                                  }));
                                },
                              ),
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
