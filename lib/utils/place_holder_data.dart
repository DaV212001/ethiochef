import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';

class PlaceHolderData{
  static List<Category> menuTimes = [
    Category(id: 1, name: "Breakfast"),
    Category(id: 2, name: "Supper")
  ];
  static List<Category> categories = [
    Category(id: 1, name: "Bakery"),
    Category(id: 2, name: "Dessert"),
    Category(id: 3, name: "Vegetarian"),
    Category(id: 4, name: "Healthy"),
    Category(id: 5, name: "Homemade"),
  ];
  static List<String> ingredients = [
    "¾ cup milk",
    "2 tablespoons white vinegar ",
    "1 cup all-purpose flour ",
    "2 tablespoons white sugar ",
    "1 teaspoon baking powder ",
    "½ teaspoon baking soda ",
    "½ teaspoon salt ",
    "1 egg",
    "2 tablespoons butter, melted ",
    "cooking spray"
  ];
  static List<String> steps = [
    "Combine milk with vinegar in a medium bowl and set aside for 5 minutes to \"sour\".",
    "Combine flour, sugar, baking powder, baking soda, and salt in a large mixing bowl. Whisk egg and butter into \"soured\" milk. Pour the flour mixture into the wet ingredients and whisk until lumps are gone.",
    "Heat a large skillet over medium heat, and coat with cooking spray. Pour 1/4 cupfuls of batter onto the skillet, and cook until bubbles appear on the surface. Flip with a spatula, and cook until browned on the other side."
  ];
  static  Food food = Food(
      thumbnail:
      "https://ethiochef.com/storage/app/public/food/lHV2tjemk6rxwB4FuWxBjUKwFuaYzIov0SmbwiSy.png",
      name: "Zucchini Bread",
      description:
      "Savor the simplicity of Moist Zucchini Bread—a perfect fusion of fresh zucchini, aromatic spices, and tender crumb. A guilt-free, comforting treat for any time of day. Enjoy the homemade goodness!",
      categories: categories,
      menuTimes: menuTimes,
      video: "",
      ingredient: ingredients,
      steps: steps,
      servings: 2,
      preparationTime: 1.5
  );
  static List<Food> dishes = List.filled(10, food);

  static String videoLink = 'https://youtu.be/Z4Uf25pHpDM';
}