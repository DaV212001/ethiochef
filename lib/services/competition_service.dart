import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

class CompetitionService {
  Future<List<Competition>> fetchCompetitions(int pageKey) async {
    if (pageKey > 5) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.foodCompetitionList;
  }
}
