import 'package:top_tier_tutor/social_login/social_login.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';


class KakaoLogin implements SocialLogin{
  @override
  Future<bool> login() async{
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try{
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (error) {
          return false;
        }
      }
      else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (error) {
          return false;
        }
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> logout() async{
    try {
      await UserApi.instance.logout();
      return true;
    } catch (error) {
      return false;
    }

  }

}