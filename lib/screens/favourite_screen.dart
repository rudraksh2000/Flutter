import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavouriteScreen extends StatelessWidget {
  final List<Meal> favouriteMealsShown;
  FavouriteScreen(this.favouriteMealsShown);

  @override
  Widget build(BuildContext context) {
    if (favouriteMealsShown.isEmpty) {
      return Center(
        child: Text('No favourite meals added!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: ((ctx, index) {
          return MealItem(
            id: favouriteMealsShown[index].id,
            title: favouriteMealsShown[index].title,
            imageUrl: favouriteMealsShown[index].imageUrl,
            duration: favouriteMealsShown[index].duration,
            complexity: favouriteMealsShown[index].complexity,
            affordability: favouriteMealsShown[index].affordability,
          );
        }),
        itemCount: favouriteMealsShown.length,
      );
    }
  }
}
