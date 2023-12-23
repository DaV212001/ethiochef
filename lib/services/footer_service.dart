import 'dart:convert';

import 'package:http/http.dart' as http;

class FooterService{
  Future<String?> getFooterText() async{
    String footertext;
    final response = await http.get(Uri.parse("https://apiv2.ethiochef.com/user/footer"));
    if(response.statusCode == 200){
      var footertextdata = jsonDecode(response.body);
      List <dynamic> footerlist = footertextdata['data'] as List;
      if (footerlist.isNotEmpty){
      footertext = footertextdata['data'][0];
      }
      else {
        footertext = '';
      }
      return footertext;
    }
    else{
      throw Exception('Unable to get footer');
    }
  }
}