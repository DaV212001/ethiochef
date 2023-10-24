import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';

class PlaceHolderData {
  static List<Category> menuTimes = [
    Category(
        id: 1,
        name: "Breakfast",
        image:
            "https://ethiochef.com/storage/app/public/category/EuDkbjdW468BhIWAdyCLXmhnRBr0PoruwUsdpYHV.jpeg"),
    Category(
        id: 2,
        name: "Supper",
        image:
            "https://ethiochef.com/storage/app/public/category/tHgvocmsG5lXBgBBaH6cxIYFmPuFvhKB0fO8nu17.jpeg")
  ];
  static List<Category> categories = [
    Category(
        id: 1,
        name: "Habesha dishes",
        image:
            "https://ethiochef.com/storage/app/public/category/hCiVLS8e3sHKspdE3za6IRiS8hZac5hhgU0Xl7w3.jpeg"),
    Category(
        id: 2,
        name: "European dish",
        image:
            "https://ethiochef.com/storage/app/public/category/VPNVHJqrWu1iD4mmJBxhhrgPsPellVa90ot41O52.jpeg"),
    Category(
        id: 3,
        name: "Bread & Cake",
        image:
            "https://ethiochef.com/storage/app/public/category/lr0s3semDLLRLvVLZVCzHy5BEAdIbxSpOrgeB0en.jpeg"),
    Category(
        id: 4,
        name: "Meat Product",
        image:
            "https://ethiochef.com/storage/app/public/category/j1ARKQllfTQ8w23XIKrhPW8aRVSC2MNwQD30nime.jpeg"),
    Category(
        id: 5,
        name: "Juice & Smoothie",
        image:
            "https://ethiochef.com/storage/app/public/category/OB4TdWDy7aFkuDTboMWTHXAaHqmMG5pSl6CQw4go.png"),
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
  static Food food = Food(
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
      preparationTime: 1.5);
  static List<Food> dishes = List.filled(10, food);

  static String videoLink = 'https://youtu.be/Z4Uf25pHpDM';
}
