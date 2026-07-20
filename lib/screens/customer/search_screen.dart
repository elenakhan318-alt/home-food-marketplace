import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'meal_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCuisine = 'All';

  final List<Map<String, dynamic>> meals = [
    {
      'name': 'Chicken Biryani',
      'cook': "Amina's Kitchen",
      'price': '£9.95',
      'rating': 4.9,
      'reviews': 128,
      'delivery': 'Delivery • 25 mins',
      'emoji': '🍛',
      'cuisine': 'Pakistani',
      'description':
          'A fragrant homemade chicken biryani prepared with tender chicken, basmati rice, warming spices and fresh herbs.',
      'ingredients': [
        'Chicken',
        'Basmati rice',
        'Onion',
        'Tomato',
        'Yoghurt',
        'Fresh herbs',
        'Biryani spices',
      ],
      'allergens': ['Milk'],
    },
    {
      'name': 'Caribbean Jerk Chicken',
      'cook': "Carla's Kitchen",
      'price': '£8.95',
      'rating': 4.8,
      'reviews': 96,
      'delivery': 'Delivery • 30 mins',
      'emoji': '🍗',
      'cuisine': 'Caribbean',
      'description':
          'Spicy jerk chicken served with rice, vegetables and a rich homemade sauce.',
      'ingredients': [
        'Chicken',
        'Rice',
        'Peppers',
        'Onion',
        'Jerk seasoning',
      ],
      'allergens': ['None'],
    },
    {
      'name': 'Mediterranean Salad',
      'cook': "Layla's Table",
      'price': '£7.50',
      'rating': 4.7,
      'reviews': 74,
      'delivery': 'Delivery • 20 mins',
      'emoji': '🥗',
      'cuisine': 'Mediterranean',
      'description':
          'A fresh Mediterranean salad with crisp vegetables, herbs and a light dressing.',
      'ingredients': [
        'Lettuce',
        'Tomato',
        'Cucumber',
        'Olives',
        'Fresh herbs',
      ],
      'allergens': ['None'],
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredMeals {
    final query = searchController.text.trim().toLowerCase();

    return meals.where((meal) {
      final matchesSearch =
          meal['name'].toString().toLowerCase().contains(query) ||
          meal['cook'].toString().toLowerCase().contains(query) ||
          meal['cuisine'].toString().toLowerCase().contains(query);

      final matchesCuisine =
          selectedCuisine == 'All' || meal['cuisine'] == selectedCuisine;

      return matchesSearch && matchesCuisine;
    }).toList();
  }

  void _openMeal(Map<String, dynamic> meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(
          mealName: meal['name'],
          cookName: meal['cook'],
          price: meal['price'],
          rating: meal['rating'],
          reviewCount: meal['reviews'],
          deliveryText: meal['delivery'],
          emoji: meal['emoji'],
          imageUrl: null,
          description: meal['description'],
          ingredients: List<String>.from(meal['ingredients']),
          allergens: List<String>.from(meal['allergens']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cuisines = [
      'All',
      'Pakistani',
      'Caribbean',
      'Mediterranean',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Meals'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search meals, cooks or cuisines',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.page,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: cuisines.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: AppSpacing.small);
              },
              itemBuilder: (context, index) {
                final cuisine = cuisines[index];
                final isSelected = selectedCuisine == cuisine;

                return ChoiceChip(
                  label: Text(cuisine),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCuisine = cuisine;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.regular),
          Expanded(
            child: filteredMeals.isEmpty
                ? _buildEmptyResults()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      0,
                      AppSpacing.page,
                      AppSpacing.page,
                    ),
                    itemCount: filteredMeals.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: AppSpacing.regular);
                    },
                    itemBuilder: (context, index) {
                      return _buildMealResult(filteredMeals[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealResult(Map<String, dynamic> meal) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () {
          _openMeal(meal);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.regular),
          child: Row(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                alignment: Alignment.center,
                child: Text(
                  meal['emoji'],
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(width: AppSpacing.regular),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['name'],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal['cook'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
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
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${meal['reviews']})',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal['delivery'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                meal['price'],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.regular),
            Text(
              'No meals found',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppSpacing.small),
            Text(
              'Try another meal, cook or cuisine.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}