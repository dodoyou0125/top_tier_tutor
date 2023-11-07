import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_tier_tutor/app%20screen/checking_tier_coach.dart';
import 'package:top_tier_tutor/building app/loading_screen.dart';
import 'package:top_tier_tutor/app screen/checking_tier_user.dart';

class signin_page_tmp extends StatefulWidget {
  @override
  _signin_page_tmpState createState() => _signin_page_tmpState();
}

final user = <String, dynamic>{
  "tier": 'tier',
  "name": "summoner name",
  "images": 'images',
  "uid": 'user id',
  "token" : 0,
};

class _signin_page_tmpState extends State<signin_page_tmp> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String summoner_name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 120.0,
              child: Image.asset('images/main_page_logo.png'),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your password.',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) async{
                //Do something with the user input.
                print(value);
                summoner_name = value;
              },
              decoration: const InputDecoration(
                hintText: '소환사명을 입력하세요',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    summoner_name = await ConvertName(summoner_name);
                    //Implement login functionality.
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      String? uid = newUser.user?.uid;
                      var db = FirebaseFirestore.instance;
                      if (newUser != null) {
                        //새로운 DB 콜렉션 추가
                        db
                            .collection("user")
                            .doc(summoner_name)
                            .set(user)
                            .onError((error, stackTrace) =>
                                print("Error writing document: $error"));

                        //소환사명으로 티어 체크
                        dynamic rankinfo = await CheckingTier(summoner_name);
                        //한글명과 이미지 바꾸기
                        List tier_info = tier_convert(rankinfo);
                        print(tier_info);

                        //값 업데이트
                        final washingtonRef =
                            db.collection("user").doc(summoner_name);
                        washingtonRef.update({
                          "name": await summoner_name,
                          "tier": tier_info[0],
                          "images": tier_info[1],
                          "uid" : uid,
                          "token" : 0,
                        }).then(
                            (value) =>
                                print("DocumentSnapshot successfully updated!"),
                            onError: (e) =>
                                print("Error updating document $e"));

                        if (rankinfo == 'CHALLENGER' ||
                            rankinfo == 'GRANDMASTER') {
                          // ignore: use_build_context_synchronously
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return checking_tier_coach(
                                name: summoner_name,
                                tier: tier_info[0],
                                images: tier_info[1]);
                          }));
                        } else {
                          Map result = await getDataNotCoach(summoner_name);
                          print(result);
                          //값 업데이트
                          final washingtonRef =
                          db.collection("user").doc(summoner_name);
                          washingtonRef.update({
                            "summoner data": result,
                          }).then(
                                  (value) =>
                                  print("DocumentSnapshot successfully updated!"),
                              onError: (e) => print("Error updating document $e"));

                          // ignore: use_build_context_synchronously
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return checking_tier_user(
                                name: summoner_name,
                                tier: tier_info[0],
                                images: tier_info[1]);
                          }));
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Sign In',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}