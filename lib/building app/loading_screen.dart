import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:top_tier_tutor/building%20app/networking.dart';
import 'package:top_tier_tutor/building%20app/constants.dart';
import 'package:top_tier_tutor/app%20screen/home.dart';
import 'package:top_tier_tutor/app screen/profile_coach.dart';

String name_now = '';
dynamic summonerId = '';
dynamic summonerdata = {};
String image_name = '';
String puuid = '';
int currentPatch = 0;
String version = '';

Future<List<dynamic>> getEntries(String page) async {
  NetworkHelper networkHelper_challenger = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/challenger?api_key=$apiKey');
  var entries_challenger = await networkHelper_challenger.getData();
  NetworkHelper networkHelper_grandmaster = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/grandmaster?api_key=$apiKey');
  var entries_grandmaster = await networkHelper_grandmaster.getData();
  var entries = entries_challenger + entries_grandmaster;
  print(entries.runtimeType);
  return entries_challenger;
}

Future<Map> getDataNotCoach(String name) async{
  //소환사 아이디 받아오기
  NetworkHelper summonerIdCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  summonerId = await summonerIdCheck.getSummonerId();
  //소환사 정보 받아오기
  NetworkHelper getsummonerdata = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/$summonerId?api_key=$apiKey');
  summonerdata = await getsummonerdata.getSummonerData();
  return summonerdata;
}

Future<List<dynamic>> getData(String name) async {
  image_name = '';
  //소환사 아이디 받아오기
  NetworkHelper summonerIdCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  summonerId = await summonerIdCheck.getSummonerId();
  //소환사 정보 받아오기
  NetworkHelper getsummonerdata = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/$summonerId?api_key=$apiKey');
  summonerdata = await getsummonerdata.getSummonerData();
  //소환사 이름 받아오기
  NetworkHelper challengerlist = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/challenger?api_key=$apiKey');
  var entries_challenger = await challengerlist.getData();
  final name_now = entries_challenger.firstWhere((e) => e['summonerId'] == summonerId)['summonerName'];

  if (summonerdata['tier'] == 'CHALLENGER') {
    image_name = 'images/Challenger_Emblem_2022.png';
  } else if (summonerdata['tier'] == 'GRANDMASTER') {
    image_name = 'images/Grandmaster_Emblem_2022.png';
  }
  NetworkHelper versionCheck = NetworkHelper(ddragon_ver);
  var version = await versionCheck.getVersion();
  NetworkHelper iconNumCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name_now?api_key=$apiKey');
  var number = await iconNumCheck.getIconNum();
  String url =
      'https://ddragon.leagueoflegends.com/cdn/$version/img/profileicon/$number.png';
  //print([url, name, summonerdata, image_name]);
  return [url, name_now, summonerdata, image_name];
}

Future getRankInfo(String name) async {
  NetworkHelper challengerlist = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/challenger?api_key=$apiKey');
  NetworkHelper grandmasterlist = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/grandmaster?api_key=$apiKey');
  NetworkHelper summonerIdCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  final summonerId = await summonerIdCheck.getSummonerId();
  var entries_challenger = await challengerlist.getData();
  var entries_grandmaster = await grandmasterlist.getData();
  var list_final = await (entries_challenger + entries_grandmaster);
  final rank =
      list_final.firstWhere((e) => e['summonerId'] == summonerId, orElse: () {
    return 'UnRanked';
  });
  //print('rank');
  print(rank);
  if (rank != 'UnRanked') return list_final.indexOf(rank) + 1;
  else return rank;
}

Future getMatchData(String name) async {
  NetworkHelper puuidData = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  puuid = await puuidData.getpuuId();
  NetworkHelper matchdata = NetworkHelper(
      'https://asia.api.riotgames.com/tft/match/v1/matches/by-puuid/$puuid/ids?start=0&count=2000&api_key=$apiKey');
  NetworkHelper versionCheck = NetworkHelper(ddragon_ver);
  var version = await versionCheck.getVersion();
  currentPatch = await matchdata.getCurrentCount(version);
  print('current = $currentPatch');
  return currentPatch;
}

Future CheckingTier(String name) async{
  //소환사 아이디 받아오기
  NetworkHelper summonerIdCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  summonerId = await summonerIdCheck.getSummonerId();
  //소환사 정보 받아오기
  NetworkHelper getsummonerdata = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/$summonerId?api_key=$apiKey');
  summonerdata = await getsummonerdata.getSummonerData();
  print(summonerdata);
  return summonerdata['tier'];
}

List tier_convert(String tier){
  String _tier = '';
  String image_name = '';
  if (tier == 'CHALLENGER'){
    _tier = '챌린저';
    image_name = 'images/Challenger_Emblem_2022.png';
  }
  else if (tier == 'GRANDMASTER'){
    _tier = '그랜드마스터';
    image_name = 'images/Grandmaster_Emblem_2022.png';
  }
  else if (tier == 'MASTER'){
    _tier = '마스터';
    image_name = 'images/Master_Emblem_2022.png';
  }
  else if (tier == 'MASTER'){
    _tier = '마스터';
    image_name = 'images/Challenger_Emblem_2022.png';
  }
  else if (tier == 'DIAMOND'){
    _tier = '다이아몬드';
    image_name = 'images/Diamond_Emblem_2022.png';
  }
  else if (tier == 'PLATINUM'){
    _tier = '플레티넘';
    image_name = 'images/Platinum_Emblem_2022.png';
  }
  else if (tier == 'GOLD'){
    _tier = '골드';
    image_name = 'images/Gold_Emblem_2022.png';
  }
  else if (tier == 'SILVER'){
    _tier = '실버';
    image_name = 'images/Silver_Emblem_2022.png';
  }
  else if (tier == 'BRONZE'){
    _tier = '브론즈';
    image_name = 'images/Bronze_Emblem_2022.png';
  }
  else if (tier == 'IRON'){
    _tier = '아이언';
    image_name = 'images/Iron_Emblem_2022.png';
  }
  else{
    _tier = 'UnRanked';
    image_name = 'images/logo_image';
  }
  return [_tier, image_name];
}

Future<String> ConvertName(String name) async{
  //소환사 아이디 받아오기
  NetworkHelper summonerIdCheck = NetworkHelper(
      'https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/$name?api_key=$apiKey');
  summonerId = await summonerIdCheck.getSummonerId();
  //소환사 정보 받아오기
  NetworkHelper getsummonerdata = NetworkHelper(
      'https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/$summonerId?api_key=$apiKey');
  summonerdata = await getsummonerdata.getSummonerName();
  print(summonerdata);
  return summonerdata['summonerName'];
}