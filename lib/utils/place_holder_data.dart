import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/models/competitor.dart';
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
        name: "Lunch",
        image:
            "https://ethiochef.com/storage/app/public/food/4bZDeO7bYN9G2SYYTxlStaUmQJERrzjR3SFZGotq.jpeg"),
    Category(
        id: 3,
        name: "Supper",
        image:
            "https://ethiochef.com/storage/app/public/category/tHgvocmsG5lXBgBBaH6cxIYFmPuFvhKB0fO8nu17.jpeg"),
    Category(
        id: 4,
        name: "Dinner",
        image:
            "https://ethiochef.com/storage/app/public/food/d9JyoZ1U64XDRCOOzqyLfH1EM6h1mLZnj9B65zD2.jpeg")
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
          "https://ethiochef.com/storage/app/public/food/96Bz0NqAKx9PksMzm1qg24AxwI2wz5KwgyaLQ7N3.jpeg",

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

  static List<Competition> foodCompetitionList = [
    Competition(
        name: "Cooking Challenge",
        description:
            "Show off your culinary skills in a head-to-head cooking competition.",
        image:
            "https://www.courier-journal.com/gcdn/presto/2018/09/13/PLOU/d947ceae-15e4-44d6-82d2-7fabf8fa785f-Gerron_Hurt_on_Masterchef_finale.jpg?width=660&height=440&fit=crop&format=pjpg&auto=webp",
        daysLeft: 10,
        votes: 500,
        competitor: competitorList,
        video: videoLink),
    Competition(
        name: "Baking Championship",
        description:
            "Compete in a series of baking challenges and win the title of the best baker.",
        image:
            "https://thumbs.dreamstime.com/b/cooking-master-competition-vector-illustration-53111191.jpg",
        daysLeft: 5,
        votes: 300,
        competitor: competitorList,
        video: videoLink),
    Competition(
        name: "Pizza Eating Contest",
        description:
            "How many slices of pizza can you devour in a set time? Test your limits!",
        image: "https://i.ytimg.com/vi/7j9NB_boaOE/hqdefault.jpg",
        daysLeft: 7,
        votes: 800,
        competitor: competitorList,
        video: videoLink),
    Competition(
        name: "Chili Cook-Off",
        description:
            "Prepare your best chili recipe and see if it's the spiciest in town.",
        image:
            "https://mummyfique.com/wp-content/uploads/2017/06/Mummyfique-Presents-an-All-New-Cooking-Competition-Home-Chef-2017-01.jpg",
        daysLeft: 15,
        votes: 400,
        competitor: competitorList,
        video: videoLink),
    Competition(
        name: "Sushi Masterclass",
        description:
            "Learn the art of making sushi and compete to become the Sushi Master.",
        image:
            "https://www.courier-journal.com/gcdn/presto/2018/09/13/PLOU/d947ceae-15e4-44d6-82d2-7fabf8fa785f-Gerron_Hurt_on_Masterchef_finale.jpg",
        daysLeft: 20,
        votes: 700,
        competitor: competitorList,
        video: videoLink),
  ];

  static List<Competitor> competitorList = [
    Competitor(
      "John Doe",
      500,
      "john_doe_image.jpg",
    ),
    Competitor(
      "Jane Smith",
      300,
      "jane_smith_image.jpg",
    ),
    Competitor(
      "Pizza Lover",
      800,
      "pizza_lover_image.jpg",
    ),
    Competitor(
      "Spice Master",
      400,
      "spice_master_image.jpg",
    ),
    Competitor(
      "Sushi Sensei",
      700,
      "sushi_sensei_image.jpg",
    ),
  ];
}
