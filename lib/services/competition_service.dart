import 'dart:convert';

import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:http/http.dart' as http;
class CompetitionService {
  Future<List<Competition>> fetchCompetitions(int pageKey) async {
    List<Competition>? competitionslist;
    try {
      var res = await http.get(Uri.parse("https://apiv2.ethiochef.com/user/contest/competiton"));
      print("res.statusCode  == = == = = = == = = = ${res.statusCode}");

      var data = jsonDecode(res.body);
      if (data['message'] == 'All user video get successful') {
        var categoriesData = data['data'] as List;
        competitionslist = categoriesData.map((categoryData) => Competition.fromJson(categoryData)).toList();
      } else {
        throw Exception('Unexpected message from API: ${data['message']}');
      }
    } catch(e) {
      throw Exception (e);
    }



    if (pageKey > competitionslist.length) {
      throw Exception();
    }

    await Future.delayed(Duration(seconds: 1));
    return competitionslist;
  }
}
