import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String categoryTitle;
  List<Meal> displayedMeals;
  var _loadedInitData = false;

  @override
  void initState() {
    // we are not initalizing our state with below method because here we are
    // using a certain dependency that is context, and initState does not
    // run with certain dependency.

    // final routeArgs =
    //     ModalRoute.of(context).settings.arguments as Map<String, String>;
    // categoryTitle = routeArgs['title'];
    // final categoryId = routeArgs['id'];
    // displayedMeals = DUMMY_MEALS.where((meal) {
    //   return meal.categories.contains(categoryId);
    // }).toList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // we are using a bool checker because didChangeDependencies runs a couple
    // of time after initializing state. It runs when dependency of the state
    // change and also the case when attached widget changes which here is the
    // case when we are calling setState here. So the setState changes are
    // overrunning here. Therefore for a certain state we are checking it with
    // a boolean to temporary remove the meal item from the screen.
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryId = routeArgs['id'];
      displayedMeals = widget.availableMeals.where((meal) {
        // here in categories (of meal which is an element of DUMMY_MEALS
        //(a list of Meal i.e meal is Meal's object))
        // we check for same category id.
        return meal.categories.contains(categoryId);
      }).toList();
    }
    _loadedInitData = true;
    super.didChangeDependencies();
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return MealItem(
            id: displayedMeals[index].id,
            title: displayedMeals[index].title,
            imageUrl: displayedMeals[index].imageUrl,
            duration: displayedMeals[index].duration,
            complexity: displayedMeals[index].complexity,
            affordability: displayedMeals[index].affordability,
          );
        }),
        itemCount: displayedMeals.length,
      ),
    );
  }
}
