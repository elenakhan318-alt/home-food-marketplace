import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'favourites_data.dart';
import 'meal_details_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  void _removeFavourite(int index) {
    final favouriteMeals = favouritesData.favouriteMeals;
    final String mealName =
        favouriteMeals[index]['name'] as String;

    favouritesData.removeFavourite(mealName);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$mealName removed from favourites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _openMeal(Map<String, dynamic> meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(
          mealName: meal['name'] as String,
          cookName: meal['cook'] as String,
          price: meal['price'] as String,
          rating: (meal['rating'] as num).toDouble(),
          reviewCount: meal['reviews'] as int,
          deliveryText: meal['delivery'] as String,
          emoji: meal['emoji'] as String,
          imageUrl: meal['imageUrl'] as String?,
          description: meal['description'] as String,
          ingredients: List<String>.from(
            meal['ingredients'] as List,
          ),
          allergens: List<String>.from(
            meal['allergens'] as List,
          ),
        ),
      ),
    );
  }

  void _addToBasket(String mealName) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$mealName added to basket',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: favouritesData,
      builder: (context, child) {
        final favouriteMeals =
            favouritesData.favouriteMeals;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Favourite Meals'),
            centerTitle: true,
          ),
          body: favouriteMeals.isEmpty
              ? _buildEmptyFavourites()
              : ListView.separated(
                  padding: const EdgeInsets.all(
                    AppSpacing.page,
                  ),
                  itemCount: favouriteMeals.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: AppSpacing.regular,
                    );
                  },
                  itemBuilder: (context, index) {
                    return _buildFavouriteCard(
                      favouriteMeals[index],
                      index,
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildFavouriteCard(
    Map<String, dynamic> meal,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.regular,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppRadius.card,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(
              AppRadius.medium,
            ),
            onTap: () {
              _openMeal(meal);
            },
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppRadius.medium,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    meal['emoji'] as String,
                    style: const TextStyle(
                      fontSize: 42,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.regular,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal['name'] as String,
                        style: const TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal['cook'] as String,
                        style: const TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.rating,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${meal['rating']}',
                            style: const TextStyle(
                              color:
                                  AppColors.textPrimary,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${meal['reviews']})',
                            style: const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meal['delivery'] as String,
                        style: const TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _removeFavourite(index);
                      },
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      meal['price'] as String,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.regular,
          ),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              onPressed: () {
                _addToBasket(
                  meal['name'] as String,
                );
              },
              icon: const Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
              ),
              label: const Text('Add to Basket'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavourites() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.page,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 55,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(
              height: AppSpacing.large,
            ),
            const Text(
              'No favourite meals',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: AppSpacing.small,
            ),
            const Text(
              'Tap the heart icon on a meal to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}