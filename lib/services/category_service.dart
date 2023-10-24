import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';

class CategoryService {
  Future<List<Category>> fetchCategories(int pageKey) async{
    if(pageKey > 5) {
      throw Exception();
    }
    await Future.delayed(Duration(seconds: 1));
    return PlaceHolderData.categories;
  }
}
