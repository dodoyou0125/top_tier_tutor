import 'package:top_tier_tutor/kakao/firebase_auth_remote_data_source.dart';
import 'package:top_tier_tutor/social_login/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  MainViewModel(this._socialLogin);

  Future login() async{
    isLogined = await _socialLogin.login();
    if(isLogined) {
      user = await kakao.UserApi.instance.me();
      print('user response ${user}');
      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.properties!['nickname'],
        'email': user!.kakaoAccount!.email,
        'photoURL': user!.properties!['profile_image'],
      });
      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async{
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}