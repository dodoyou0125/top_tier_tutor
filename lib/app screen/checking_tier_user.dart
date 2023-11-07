// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types
// ignore: prefer_const_constructors
// ignore: camel_case_types
import 'package:flutter/material.dart';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'package:top_tier_tutor/building%20app/loading_screen.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';

class checking_tier_user extends StatefulWidget {
  const checking_tier_user({this.name, this.tier, this.images});
  final name;
  final tier;
  final images;

  @override
  State<checking_tier_user> createState() => _checking_tier_userState();
}

class _checking_tier_userState extends State<checking_tier_user> {
  String _name = '과제 많은 넙죽이';
  String _tier = 'Challenger';
  String _images = '';

  void initState() {
    super.initState();
    _name = widget.name;
    _tier = widget.tier;
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '어서오세요',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 200.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      // '가나다라마바사아자차카타파하가나',
                                      '$_name',
                                      style: TextStyle(
                                          fontFamily: 'NanumSquare',
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '님!',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.white,
                              height: 1.0,
                              width: 200.0,
                            ),
                            SizedBox(
                              height: 30.0,
                              width: 220,
                            ),
                            Text(
                              'TFT 현재 티어는',
                              style: TextStyle(
                                fontFamily: 'NanumSquare',
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 140.0,
                                  child: Text(
                                    // '가나다라마바사아자차카타파하가나',
                                    '$_tier',
                                    style: TextStyle(
                                        fontFamily: 'NanumSquare',
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  '이시군요!',
                                  style: TextStyle(
                                    fontFamily: 'NanumSquare',
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.white,
                              height: 1.0,
                              width: 140.0,
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ),
                        Image(
                          image: AssetImage(_images),
                          width: 160.0,
                          height: 160.0,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                    Column(),
                  ],
                ),
                GestureDetector(
                  onTap: () async{
                    List<dynamic> entries_now = await getEntries('home');
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return home(entries: entries_now);
                      }));
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 250.0,
                      height: 40.0,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          '코칭 받으러 가기',
                          style: TextStyle(
                            fontFamily: 'NanumSquareB',
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
