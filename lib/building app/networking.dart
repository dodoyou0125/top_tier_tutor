import 'dart:io';

import 'package:http/http.dart';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'dart:convert';

import 'package:top_tier_tutor/building%20app/loading_screen.dart';

class NetworkHelper{
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    List entries = [];
    Response response = await get(Uri.parse(url));
    if(response.statusCode == 200){
      String data = response.body;
      entries = jsonDecode(data)['entries'];
      //점수를 기준으로 list of map 정렬
      entries.sort((s1,s2) {
        return s2['leaguePoints'].compareTo(s1['leaguePoints']) as int;
      });
      return entries;
      //print(entries.indexOf(entries[0]).runtimeType);
    }
    else{
      print(response.statusCode);
    }
  }

  Future getVersion() async {
    String version = '';
    //최신 버전 받아오기
    Response response = await get(Uri.parse(url));
    String data = response.body;
    version = jsonDecode(data)[0];
    print(version); //13.18.1
    return version;
  }

  Future getIconNum() async {
    int iconId = 0;
    //소환사명으로 아이콘 정보 받아오기
    Response responseInfo = await get(Uri.parse(url));
    String dataInfo = responseInfo.body;
    iconId = jsonDecode(dataInfo)['profileIconId'];
    return iconId;
  }

  Future getSummonerId() async {
    //소환사명으로 소환사 고유 아이디 받아오기
    String summonerId = '';
    Response responseInfo = await get(Uri.parse(url));
    String dataInfo = responseInfo.body;
    summonerId = jsonDecode(dataInfo)['id'];
    return summonerId;
  }

  Future getpuuId() async {
    //소환사명으로 소환사 puuid 받아오기
    String puuid = '';
    Response responseInfo = await get(Uri.parse(url));
    String dataInfo = responseInfo.body;
    //print(jsonDecode(dataInfo));
    puuid = jsonDecode(dataInfo)['puuid'];
    return puuid;
  }

  Future getSummonerData() async {
    //고유 아이디로 소환사 승률 등 정보 받아오기
    Map summonerdata = {};
    Response responseInfo = await get(Uri.parse(url));
    String dataInfo = responseInfo.body;
    summonerdata['tier'] = jsonDecode(dataInfo)[0]['tier'].toString();
    summonerdata['leaguePoints'] = jsonDecode(dataInfo)[0]['leaguePoints'].toString();
    summonerdata['wins'] = jsonDecode(dataInfo)[0]['wins'];
    summonerdata['losses'] = jsonDecode(dataInfo)[0]['losses'];
    summonerdata['gameCounts'] = (jsonDecode(dataInfo)[0]['wins']+jsonDecode(dataInfo)[0]['losses']);
    return summonerdata;
  }

  Future checkCurrentPatch(String version) async{
    Map metadata = {};
    Response response = await get(Uri.parse(url));
    String data = response.body;
    metadata = jsonDecode(data);
    //print(version);
    print(metadata);
    if (metadata['info']['game_version'].split(' ')[1].split('.')[0]+'.'+metadata['info']['game_version'].split(' ')[1].split('.')[1] == version){
      print('1');
      return 1;
    }
    else {
      print('0');
      return 0;
    }
    //print(metadata['info']['game_version'].split(' ')[1].split('.')[0]+'.'+metadata['info']['game_version'].split(' ')[1].split('.')[1]);
  }

  Future getCurrentCount(String version) async {
    List matchdata = [];
    int result = 0;
    int api_count = 0;
    Response response = await get(Uri.parse(url));
    String data = response.body;
    matchdata = jsonDecode(data);
    version = version.split('.')[0] + '.' + version.split('.')[1];
    for(String matchid in matchdata){
      if (api_count == 20 ) {
        sleep(Duration(milliseconds: 500));
        api_count = 0;
      }
      NetworkHelper metadata = NetworkHelper('https://asia.api.riotgames.com/tft/match/v1/matches/$matchid?api_key=$apiKey');
      int check = await metadata.checkCurrentPatch(version);
      api_count += 1;
      if (check == 1){
        result = result+1;
      }
      else break;
    }
    print(result);
    return result;
    //print(matchdata);
  }

  Future getSummonerName() async {
    //고유 아이디로 소환사 승률 등 정보 받아오기
    Map summonerdata = {};
    Response responseInfo = await get(Uri.parse(url));
    String dataInfo = responseInfo.body;
    //print(dataInfo);
    summonerdata['summonerName'] = jsonDecode(dataInfo)[0]['summonerName'].toString();
    return summonerdata;
  }
}

