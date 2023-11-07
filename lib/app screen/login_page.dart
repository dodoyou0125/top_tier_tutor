// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:top_tier_tutor/social_login/main_view_model.dart';
import 'package:top_tier_tutor/social_login/kakao_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../building app/loading_screen.dart';
import 'home.dart';



class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

final viewModel = MainViewModel(KakaoLogin());

class _login_pageState extends State<login_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TFT 실력 향상은',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '탑 티어 튜터',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Color(0xFF0003399),
                                fontSize: 35.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Hero(
                          tag: 'logo',
                          child: Image(
                            image: AssetImage('images/login_image.png'),
                            width: 130.0,
                            height: 130.0,
                          ),
                        ),
                      ],
                    ),
                    Column(),
                  ],
                ),
              ),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return GestureDetector(
                      onTap: () async{
                        await viewModel.login().then((value) => setState(() async{
                          List<dynamic> entries_now = await getEntries('home');
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return home(entries: entries_now);
                            }));
                          });
                        }));;
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        color: Color(0xfffae100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 60.0,
                                ),
                                Image(
                                  image: AssetImage('images/kakao_png.png'),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ],
                            ),
                            Text(
                              '카카오톡으로 로그인',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.black,
                                fontSize: 23.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return login_page();
                      }));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      color: Color(0xfffae100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 40.0,
                              ),
                              Image(
                                image: AssetImage('images/kakao_png.png'),
                                width: 40.0,
                                height: 40.0,
                              ),
                            ],
                          ),
                          Text(
                            '카카오톡 로그아웃',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.black,
                              fontSize: 23.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/login_page_tmp');
                },
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  color: Color(0xFF003399),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Riot(임시 이메일)으로 로그인하기',
                            style: TextStyle(
                              fontFamily: 'NanumSquare',
                              color: Colors.white,
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/signin_page_tmp');
                },
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  color: Color(0xFFD13639),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                            image: AssetImage('images/riot_logo.png'),
                          ),
                        ],
                      ),
                      Text(
                        'Riot으로 가입하기',
                        style: TextStyle(
                            fontFamily: 'NanumSquare',
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
