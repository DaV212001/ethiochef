import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/models/sub_category.dart';

import '../models/contestants.dart';

class PlaceHolderData {
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
  static Map<String, dynamic> name = {
    'name': 'Zucchini Bread',
  };
  static Food food = Food(
    subcategoriesId: 1,
      categoryId: 1,

      thumbnail:
          "https://ethiochef.com/storage/app/public/food/96Bz0NqAKx9PksMzm1qg24AxwI2wz5KwgyaLQ7N3.jpeg",

      name: name['name'],

      description:
          "Savor the simplicity of Moist Zucchini Bread—a perfect fusion of fresh zucchini, aromatic spices, and tender crumb. A guilt-free, comforting treat for any time of day. Enjoy the homemade goodness!",

      // categories: categories,
      // menuTimes: menuTimes,

      video: "",
      // ingredient: ingredients,
      // steps: steps,
      servings: 2,
    mealTime: 2,
      // preparationTime: 1.5
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

  static List<Contestant> competitorList = [

  ];

  // School Subjects as Categories
  static List<Category> schoolSubjects = [
    Category(
      id: 1,
      name: "Mathematics",
      description: "Learn algebra, geometry, calculus, and problem-solving skills",
      image: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 2,
      name: "English Language",
      description: "Master grammar, literature, writing, and communication skills",
      image: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 3,
      name: "Science",
      description: "Explore physics, chemistry, biology, and scientific methods",
      image: "https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 4,
      name: "History",
      description: "Study past events, civilizations, and historical analysis",
      image: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 5,
      name: "Geography",
      description: "Learn about Earth's physical features, countries, and cultures",
      image: "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 6,
      name: "Computer Science",
      description: "Programming, algorithms, and digital technology fundamentals",
      image: "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  // Lessons as Foods (Lessons under each subject)
  static List<Food> mathLessons = [
    Food(
      id: 1,
      subcategoriesId: 1,
      categoryId: 1,
      name: "Introduction to Algebra",
      description: "Learn the basics of algebraic expressions, variables, and equations. Perfect for beginners starting their mathematical journey.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400",
      servings: 1,
      preparationTime: 45,
      stepsList: {
        "en": {
          "1": "Understand what variables are and how they represent unknown values",
          "2": "Learn to write algebraic expressions from word problems",
          "3": "Practice solving simple linear equations",
          "4": "Apply algebraic concepts to real-world problems"
        }
      },
      ingredients: {
        "en": {
          "1": "Basic arithmetic knowledge",
          "2": "Understanding of variables",
          "3": "Problem-solving mindset",
          "4": "Practice worksheets"
        }
      }
    ),
    Food(
      id: 2,
      subcategoriesId: 1,
      categoryId: 1,
      name: "Geometry Fundamentals",
      description: "Explore shapes, angles, and spatial relationships. Build a strong foundation in geometric concepts.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1596495578065-6e0763fa1178?w=400",
      servings: 1,
      preparationTime: 60,
      stepsList: {
        "en": {
          "1": "Learn about different types of angles and their properties",
          "2": "Study triangles, quadrilaterals, and polygons",
          "3": "Understand area and perimeter calculations",
          "4": "Practice geometric proofs and constructions"
        }
      },
      ingredients: {
        "en": {
          "1": "Ruler and compass",
          "2": "Protractor",
          "3": "Graph paper",
          "4": "Geometric shapes"
        }
      }
    ),
    Food(
      id: 3,
      subcategoriesId: 1,
      categoryId: 1,
      name: "Calculus Basics",
      description: "Introduction to limits, derivatives, and integrals. Advanced mathematics for serious learners.",
      mealTime: 3,
      thumbnail: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=400",
      servings: 1,
      preparationTime: 90,
      stepsList: {
        "en": {
          "1": "Understand the concept of limits and continuity",
          "2": "Learn to find derivatives using various rules",
          "3": "Master integration techniques",
          "4": "Apply calculus to optimization problems"
        }
      },
      ingredients: {
        "en": {
          "1": "Strong algebra foundation",
          "2": "Trigonometry knowledge",
          "3": "Graphing calculator",
          "4": "Practice problems"
        }
      }
    ),
  ];

  static List<Food> englishLessons = [
    Food(
      id: 4,
      subcategoriesId: 2,
      categoryId: 2,
      name: "Grammar Essentials",
      description: "Master the fundamental rules of English grammar including tenses, parts of speech, and sentence structure.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
      servings: 1,
      preparationTime: 50,
      stepsList: {
        "en": {
          "1": "Learn the eight parts of speech",
          "2": "Understand subject-verb agreement",
          "3": "Master different verb tenses",
          "4": "Practice proper punctuation usage"
        }
      },
      ingredients: {
        "en": {
          "1": "Grammar textbook",
          "2": "Writing exercises",
          "3": "Dictionary",
          "4": "Practice worksheets"
        }
      }
    ),
    Food(
      id: 5,
      subcategoriesId: 2,
      categoryId: 2,
      name: "Creative Writing",
      description: "Develop your creative writing skills through storytelling, poetry, and descriptive writing techniques.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400",
      servings: 1,
      preparationTime: 75,
      stepsList: {
        "en": {
          "1": "Learn the elements of a good story",
          "2": "Practice character development",
          "3": "Master dialogue writing",
          "4": "Create compelling narratives"
        }
      },
      ingredients: {
        "en": {
          "1": "Imagination and creativity",
          "2": "Writing journal",
          "3": "Literary examples",
          "4": "Peer feedback"
        }
      }
    ),
    Food(
      id: 6,
      subcategoriesId: 2,
      categoryId: 2,
      name: "Literature Analysis",
      description: "Analyze classic and contemporary literature to understand themes, symbolism, and literary devices.",
      mealTime: 3,
      thumbnail: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
      servings: 1,
      preparationTime: 80,
      stepsList: {
        "en": {
          "1": "Read and understand the text thoroughly",
          "2": "Identify literary devices and techniques",
          "3": "Analyze themes and character development",
          "4": "Write critical essays and responses"
        }
      },
      ingredients: {
        "en": {
          "1": "Classic literature books",
          "2": "Analysis frameworks",
          "3": "Critical thinking skills",
          "4": "Writing materials"
        }
      }
    ),
  ];

  static List<Food> scienceLessons = [
    Food(
      id: 7,
      subcategoriesId: 3,
      categoryId: 3,
      name: "Physics: Motion and Forces",
      description: "Understand the fundamental concepts of motion, velocity, acceleration, and the laws of physics.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400",
      servings: 1,
      preparationTime: 70,
      stepsList: {
        "en": {
          "1": "Learn about displacement, velocity, and acceleration",
          "2": "Understand Newton's three laws of motion",
          "3": "Study gravitational forces and friction",
          "4": "Apply physics concepts to real-world problems"
        }
      },
      ingredients: {
        "en": {
          "1": "Physics textbook",
          "2": "Laboratory equipment",
          "3": "Mathematical skills",
          "4": "Problem-solving exercises"
        }
      }
    ),
    Food(
      id: 8,
      subcategoriesId: 3,
      categoryId: 3,
      name: "Chemistry: Atomic Structure",
      description: "Explore the building blocks of matter, electron configuration, and chemical bonding.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=400",
      servings: 1,
      preparationTime: 65,
      stepsList: {
        "en": {
          "1": "Study the structure of atoms and subatomic particles",
          "2": "Learn about electron configuration and energy levels",
          "3": "Understand ionic and covalent bonding",
          "4": "Practice drawing Lewis structures"
        }
      },
      ingredients: {
        "en": {
          "1": "Chemistry textbook",
          "2": "Molecular model kit",
          "3": "Periodic table",
          "4": "Laboratory safety equipment"
        }
      }
    ),
    Food(
      id: 9,
      subcategoriesId: 3,
      categoryId: 3,
      name: "Biology: Cell Biology",
      description: "Discover the fundamental unit of life - the cell, its structure, and vital processes.",
      mealTime: 3,
      thumbnail: "https://images.unsplash.com/photo-1530026405186-ed1fbe3a9629?w=400",
      servings: 1,
      preparationTime: 85,
      stepsList: {
        "en": {
          "1": "Learn about cell theory and cell types",
          "2": "Study cell organelles and their functions",
          "3": "Understand cellular respiration and photosynthesis",
          "4": "Examine cell division and reproduction"
        }
      },
      ingredients: {
        "en": {
          "1": "Microscope",
          "2": "Cell slides",
          "3": "Biology textbook",
          "4": "Laboratory notebook"
        }
      }
    ),
  ];

  static List<Food> historyLessons = [
    Food(
      id: 10,
      subcategoriesId: 4,
      categoryId: 4,
      name: "Ancient Civilizations",
      description: "Explore the rise and fall of ancient civilizations including Egypt, Greece, and Rome.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400",
      servings: 1,
      preparationTime: 60,
      stepsList: {
        "en": {
          "1": "Study the geography and timeline of ancient civilizations",
          "2": "Learn about their political systems and governance",
          "3": "Explore cultural achievements and innovations",
          "4": "Analyze the factors that led to their decline"
        }
      },
      ingredients: {
        "en": {
          "1": "History textbook",
          "2": "Maps and timelines",
          "3": "Primary source documents",
          "4": "Historical artifacts"
        }
      }
    ),
    Food(
      id: 11,
      subcategoriesId: 4,
      categoryId: 4,
      name: "World Wars",
      description: "Examine the causes, events, and consequences of World War I and World War II.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400",
      servings: 1,
      preparationTime: 90,
      stepsList: {
        "en": {
          "1": "Analyze the political tensions that led to war",
          "2": "Study key battles and military strategies",
          "3": "Examine the impact on civilian populations",
          "4": "Understand the post-war consequences and changes"
        }
      },
      ingredients: {
        "en": {
          "1": "Historical documents",
          "2": "War maps and timelines",
          "3": "Photographs and videos",
          "4": "Biographies of key figures"
        }
      }
    ),
  ];

  static List<Food> geographyLessons = [
    Food(
      id: 12,
      subcategoriesId: 5,
      categoryId: 5,
      name: "Physical Geography",
      description: "Study Earth's physical features including landforms, climate, and natural resources.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400",
      servings: 1,
      preparationTime: 55,
      stepsList: {
        "en": {
          "1": "Learn about different types of landforms",
          "2": "Study climate zones and weather patterns",
          "3": "Explore natural resources and their distribution",
          "4": "Understand environmental processes and cycles"
        }
      },
      ingredients: {
        "en": {
          "1": "World maps and atlases",
          "2": "Climate data",
          "3": "Geographic tools",
          "4": "Environmental case studies"
        }
      }
    ),
    Food(
      id: 13,
      subcategoriesId: 5,
      categoryId: 5,
      name: "Human Geography",
      description: "Examine how humans interact with their environment and create cultural landscapes.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400",
      servings: 1,
      preparationTime: 70,
      stepsList: {
        "en": {
          "1": "Study population distribution and migration patterns",
          "2": "Learn about urbanization and city development",
          "3": "Explore cultural regions and diversity",
          "4": "Analyze economic activities and their geographic patterns"
        }
      },
      ingredients: {
        "en": {
          "1": "Population data",
          "2": "Cultural maps",
          "3": "Economic statistics",
          "4": "Case study materials"
        }
      }
    ),
  ];

  static List<Food> computerScienceLessons = [
    Food(
      id: 14,
      subcategoriesId: 6,
      categoryId: 6,
      name: "Programming Fundamentals",
      description: "Learn the basics of programming including variables, loops, and functions.",
      mealTime: 1,
      thumbnail: "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400",
      servings: 1,
      preparationTime: 80,
      stepsList: {
        "en": {
          "1": "Understand programming concepts and syntax",
          "2": "Learn about variables, data types, and operators",
          "3": "Master control structures like loops and conditionals",
          "4": "Practice writing and debugging code"
        }
      },
      ingredients: {
        "en": {
          "1": "Computer with programming environment",
          "2": "Programming language (Python/Java)",
          "3": "Code editor",
          "4": "Practice exercises"
        }
      }
    ),
    Food(
      id: 15,
      subcategoriesId: 6,
      categoryId: 6,
      name: "Data Structures and Algorithms",
      description: "Study fundamental data structures and algorithmic problem-solving techniques.",
      mealTime: 2,
      thumbnail: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400",
      servings: 1,
      preparationTime: 100,
      stepsList: {
        "en": {
          "1": "Learn about arrays, linked lists, and stacks",
          "2": "Study trees, graphs, and hash tables",
          "3": "Master sorting and searching algorithms",
          "4": "Practice algorithmic problem-solving"
        }
      },
      ingredients: {
        "en": {
          "1": "Algorithm textbook",
          "2": "Programming environment",
          "3": "Visualization tools",
          "4": "Coding challenges"
        }
      }
    ),
  ];

  // Get all lessons for a specific subject
  static List<Food> getLessonsForSubject(int categoryId) {
    switch (categoryId) {
      case 1: return mathLessons;
      case 2: return englishLessons;
      case 3: return scienceLessons;
      case 4: return historyLessons;
      case 5: return geographyLessons;
      case 6: return computerScienceLessons;
      default: return [];
    }
  }

  // Get all lessons combined
  static List<Food> getAllLessons() {
    return [
      ...mathLessons,
      ...englishLessons,
      ...scienceLessons,
      ...historyLessons,
      ...geographyLessons,
      ...computerScienceLessons,
    ];
  }
}
