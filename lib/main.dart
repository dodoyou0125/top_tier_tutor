// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:top_tier_tutor/app screen/checking_tier_coach.dart';
import 'package:top_tier_tutor/app screen/login_page.dart';
import 'package:top_tier_tutor/app%20screen/checking_tier_user.dart';
import 'package:top_tier_tutor/app%20screen/schedule_coach.dart';
import 'package:top_tier_tutor/tmp/login_page_tmp.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:top_tier_tutor/app screen/profile_coach.dart';
import 'package:top_tier_tutor/app screen/profile_edit.dart';
import 'package:top_tier_tutor/app screen/reroll_cal.dart';
import 'package:top_tier_tutor/tmp/signin_page_tmp.dart';


import 'package:top_tier_tutor/app screen/profile_coach.dart';
import 'package:top_tier_tutor/tmp/signin_page_tmp.dart';

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers


void main() async{
  kakao.KakaoSdk.init(nativeAppKey: 'a4eaa69256012b14f6439395e93bc6e2');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TTT());
}

class TTT extends StatelessWidget {
  const TTT({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Tier Tutor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(title: 'TTT'),
        '/login_page' : (context) => login_page(),
        '/checking_tier_coach' : (context) => checking_tier_coach(),
        '/checking_tier_user' : (context) => checking_tier_user(),
        '/home': (context) => home(),
        '/profile' : (context) => profile_coach(),
        '/login_page_tmp' : (context) => login_page_tmp(),
        '/signin_page_tmp' : (context) => signin_page_tmp(),
        '/profile_edit' : (context) => profile_edit(),
        '/reroll_cal' : (context) => reroll_cal(),
        '/schedule_coach' : (context) => schedule_coach(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void initState() {
    Timer(Duration(milliseconds: 1000), () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return login_page();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF003399),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image(
                  image: AssetImage('images/main_page_logo.png'),
                  width: 190.0,
                  height: 190.0,
                ),
              ),
              Text(
                'Top Tier Tutor',
                style: TextStyle(
                  fontFamily: 'NanumSquare',
                  color: Color(0xFF04FFFF),
                  fontSize: 27.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
