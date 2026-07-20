import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/meal_card.dart';
import 'meal_details_screen.dart';
import 'search_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedNavigationIndex = 0;
  bool _isDeliverySelected = true;

  void _showTemporaryMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }

  void _showCategory(String category) {
    _showTemporaryMessage('$category meals will open here.');
  }
  void _showMeal(String mealName) {
  _showTemporaryMessage('$mealName details will open here.');
}

void _changeNavigationPage(int index) {
  if (index == 0) {
    setState(() {
      _selectedNavigationIndex = 0;
    });
    return;
  }

  if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
    return;
  }

  if (index == 2) {
    _showTemporaryMessage('Basket tab connection coming next.');
    return;
  }

  if (index == 3) {
    _showTemporaryMessage('Profile page coming next.');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.page,
              right: AppSpacing.page,
              bottom: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: AppSpacing.large),
                _buildLocation(),
                const SizedBox(height: AppSpacing.extraLarge),
                _buildGreeting(),
                const SizedBox(height: AppSpacing.large),
                _buildOrderTypeSelector(),
                const SizedBox(height: AppSpacing.regular),
                _buildSearchBar(),
                const SizedBox(height: AppSpacing.large),
                _buildPromotionBanner(),
                const SizedBox(height: AppSpacing.section),
                _buildMealsOfTheDay(),
                const SizedBox(height: AppSpacing.section),
                _buildCuisineSection(),
                const SizedBox(height: AppSpacing.section),
                _buildPopularMeals(),
                const SizedBox(height: AppSpacing.section),
                _buildCookSpotlight(),
              ],
            ),
          ),
        ),
      ),
    );
  }
Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.small),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppSpacing.small),
          Text(
            'Home',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _showTemporaryMessage('You have no new notifications.');
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: () {
        _showTemporaryMessage('Location selection will open here.');
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivering to',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Birmingham',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good evening 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        const Text(
          'What are you craving today?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildOrderTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOrderTypeButton(
              title: 'Delivery',
              icon: Icons.delivery_dining_rounded,
              isSelected: _isDeliverySelected,
              onTap: () {
                setState(() {
                  _isDeliverySelected = true;
                });
              },
            ),
          ),
          Expanded(
            child: _buildOrderTypeButton(
              title: 'Collection',
              icon: Icons.shopping_bag_outlined,
              isSelected: !_isDeliverySelected,
              onTap: () {
                setState(() {
                  _isDeliverySelected = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      readOnly: true,
      onTap: () {
        _showTemporaryMessage('Meal search will open here.');
      },
      decoration: const InputDecoration(
        hintText: 'Search meals, cooks or cuisines',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 225,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC85E32), Color(0xFFEDA16C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -10,
            child: Icon(
              Icons.restaurant_rounded,
              size: 180,
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                const Spacer(),
                const Text(
                  'Authentic Home\nCooked Meals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                const Text(
                  'Freshly prepared by trusted local cooks.',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.regular),
                FilledButton(
                  onPressed: () {
                    _showTemporaryMessage('Browse meals will open here.');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Browse Meals'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsOfTheDay() {
    const mealTimes = [('🍳', 'Breakfast'), ('🥪', 'Lunch'), ('🍽️', 'Dinner')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          title: 'Meals of the Day',
          subtitle: 'Find something for any time of day',
          onViewAll: () {
            _showTemporaryMessage('All meal times will open here.');
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: mealTimes.map((mealTime) {
            return ActionChip(
              avatar: Text(mealTime.$1),
              label: Text(mealTime.$2),
              onPressed: () {
                _showCategory(mealTime.$2);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCuisineSection() {
    const cuisines = [
      ('🍛', 'Pakistani'),
      ('🍲', 'Indian'),
      ('🌴', 'Caribbean'),
      ('🍗', 'Soul Food'),
      ('🌍', 'African'),
      ('🍝', 'Italian'),
      ('🥙', 'Middle Eastern'),
      ('🫒', 'Mediterranean'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          title: 'Browse by Cuisine',
          subtitle: 'Discover authentic flavours near you',
          onViewAll: () {
            _showTemporaryMessage('All cuisines will open here.');
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        Wrap(
          spacing: 9,
          runSpacing: 10,
          children: cuisines.map((cuisine) {
            return ActionChip(
              avatar: Text(cuisine.$1),
              label: Text(cuisine.$2),
              onPressed: () {
                _showCategory(cuisine.$2);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          title: 'Popular Near You',
          subtitle: 'Meals customers in Birmingham love',
          onViewAll: () {
            _showTemporaryMessage('Popular meals will open here.');
          },
        ),
        const SizedBox(height: AppSpacing.regular),
        SizedBox(
          height: 390,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard(
                mealName: 'Chicken Biryani',
                cookName: "Amina's Kitchen",
                price: '£9.95',
                rating: 4.9,
                reviewCount: 128,
                deliveryText: 'Delivery • 25 mins',
                emoji: '🍛',
                imageUrl:
                    'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?auto=format&fit=crop&w=900&q=80',
  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const MealDetailsScreen(
        mealName: 'Chicken Biryani',
        cookName: "Amina's Kitchen",
        price: '£9.95',
        rating: 4.9,
        reviewCount: 128,
        deliveryText: 'Delivery • 25 mins',
        emoji: '🍛',
        imageUrl:
            'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?auto=format&fit=crop&w=1200&q=80',
        description:
            'A fragrant homemade chicken biryani prepared with tender chicken, basmati rice, warming spices and fresh herbs. Served fresh by a trusted local cook.',
        ingredients: [
          'Chicken',
          'Basmati rice',
          'Onion',
          'Tomato',
          'Yoghurt',
          'Fresh herbs',
          'Biryani spices',
        ],
        allergens: [
          'Milk',
        ],
      ),
    ),
  );
},
),        
              const SizedBox(width: 14),
              MealCard(
                mealName: 'Caribbean Jerk Chicken',
                cookName: "Carla's Kitchen",
                price: '£8.95',
                rating: 4.8,
                reviewCount: 96,
                deliveryText: 'Delivery • 30 mins',
                emoji: '🍗',
                imageUrl:
                    'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80',
                onTap: () {
                  _showMeal('Caribbean Jerk Chicken');
                },
              ),
              const SizedBox(width: 14),
              MealCard(
                mealName: 'Mediterranean Salad',
                cookName: "Layla's Table",
                price: '£7.50',
                rating: 4.7,
                reviewCount: 74,
                deliveryText: 'Delivery • 20 mins',
                emoji: '🥗',
                imageUrl:
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80',
                onTap: () {
                  _showMeal('Mediterranean Salad');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCookSpotlight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          title: 'Cook Spotlight',
          subtitle: 'Meet one of our trusted local cooks',
          onViewAll: () {
            _showTemporaryMessage('Cook profiles will open here.');
          },
        ),
        const SizedBox(height: AppSpacing.regular),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.regular),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.regular),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amina's Kitchen",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pakistani home cooking',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.rating,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '4.9 · 128 reviews',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _showTemporaryMessage("Amina's profile will open here.");
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    required VoidCallback onViewAll,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        TextButton(onPressed: onViewAll, child: const Text('View all')),
      ],
    );
  }

Widget _buildBottomNavigation() {
  return NavigationBar(
    selectedIndex: _selectedNavigationIndex,
    onDestinationSelected: _changeNavigationPage,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.search_rounded),
        label: 'Search',
      ),
      NavigationDestination(
        icon: Icon(Icons.shopping_basket_outlined),
        selectedIcon: Icon(Icons.shopping_basket_rounded),
        label: 'Basket',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ],
  );
}
}