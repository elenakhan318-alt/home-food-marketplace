import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'basket_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'meal': 'Chicken Biryani',
        'cook': "Amina's Kitchen",
        'emoji': '🍛',
        'date': '24 July 2026',
        'price': '£12.45',
        'status': 'Delivered',
      },
      {
        'meal': 'Caribbean Jerk Chicken',
        'cook': "Carla's Kitchen",
        'emoji': '🍗',
        'date': '18 July 2026',
        'price': '£11.45',
        'status': 'Delivered',
      },
      {
        'meal': 'Mediterranean Salad',
        'cook': "Layla's Table",
        'emoji': '🥗',
        'date': '15 July 2026',
        'price': '£10.00',
        'status': 'Delivered',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.page),
        itemCount: orders.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: AppSpacing.regular);
        },
        itemBuilder: (context, index) {
          final order = orders[index];

          return Container(
            padding: const EdgeInsets.all(AppSpacing.regular),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        order['emoji']!,
                        style: const TextStyle(fontSize: 38),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.regular),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['meal']!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order['cook']!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              order['status']!,
                              style: const TextStyle(
                                color: AppColors.secondaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order['price']!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.regular,
                  ),
                  child: Divider(),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order['date']!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BasketScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 18,
                      ),
                      label: const Text('Reorder'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}