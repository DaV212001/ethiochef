import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

class FoodService{
  Future<List<Food>> fetchDishesForCategory(int id,int pageKey) async{
    if(pageKey > 5) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.dishes;
  }


}