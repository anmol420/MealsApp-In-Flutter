import 'package:flutter_riverpod/flutter_riverpod.dart/';

import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarain,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super(
          {
            Filter.glutenFree: false,
            Filter.lactoseFree: false,
            Filter.vegan: false,
            Filter.vegetarain: false,
          },
        );

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider(
  (ref) {
    final meals = ref.watch(mealsProvider);
    final activeFilter = ref.watch(filtersProvider);
    
    return meals.where(
      (meal) {
        if (activeFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
          return false;
        }

        if (activeFilter[Filter.lactoseFree]! && !meal.isLactoseFree) {
          return false;
        }

        if (activeFilter[Filter.vegetarain]! && !meal.isVegetarian) {
          return false;
        }

        if (activeFilter[Filter.vegan]! && !meal.isVegan) {
          return false;
        }
        return true;
      },
    ).toList();
  },
);
