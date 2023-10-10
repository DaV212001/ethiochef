import 'package:ethio_chef/models/category.dart';

class Food {
  String name;
  String thumbnail;
  String? description;
  List<Category> menuTimes;
  List<Category> categories;
  String? label;
  bool isSaved;

  Food({required this.thumbnail,
    required this.name,
    required this.menuTimes,
    required this.categories,
    this.description,
    this.label,
    this.isSaved = false,
  });
}
