import 'package:flutter/material.dart';

import '../screens/customer/favourites_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class MealCard extends StatefulWidget {
  final String mealName;
  final String cookName;
  final String price;
  final double rating;
  final int reviewCount;
  final String deliveryText;
  final String emoji;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onAddToBasket;

  const MealCard({
    super.key,
    required this.mealName,
    required this.cookName,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.deliveryText,
    required this.emoji,
    this.imageUrl,
    this.onTap,
    this.onAddToBasket,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  bool get isFavourite {
    return favouritesData.isFavourite(widget.mealName);
  }

  void _toggleFavourite() {
    favouritesData.toggleFavourite({
      'name': widget.mealName,
      'cook': widget.cookName,
      'price': widget.price,
      'rating': widget.rating,
      'reviews': widget.reviewCount,
      'delivery': widget.deliveryText,
      'emoji': widget.emoji,
      'imageUrl': widget.imageUrl,
      'description':
          'A freshly prepared homemade ${widget.mealName} from ${widget.cookName}.',
      'ingredients': <String>[],
      'allergens': <String>[],
    });

    setState(() {});

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isFavourite
                ? '${widget.mealName} added to favourites'
                : '${widget.mealName} removed from favourites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMealImage(),
              _buildMealInformation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF5D4BC),
            Color(0xFFEFA46F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.emoji,
        style: const TextStyle(fontSize: 82),
      ),
    );
  }

  Widget _buildMealImage() {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: widget.imageUrl != null &&
                  widget.imageUrl!.isNotEmpty
              ? Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _buildEmojiPlaceholder();
                  },
                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    );
                  },
                )
              : _buildEmojiPlaceholder(),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.94,
              ),
              borderRadius: BorderRadius.circular(
                AppRadius.pill,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4),
                Text(
                  'Popular',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: Colors.white.withValues(
              alpha: 0.95,
            ),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggleFavourite,
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Icon(
                  isFavourite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 21,
                  color: isFavourite
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealInformation(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mealName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  widget.cookName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: AppColors.rating,
              ),
              const SizedBox(width: 3),
              Text(
                widget.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '(${widget.reviewCount})',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              const Text(
                '25 min',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(
                      AppRadius.pill,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delivery_dining_rounded,
                        size: 16,
                        color: AppColors.secondaryDark,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.deliveryText,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:
                                AppColors.secondaryDark,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.price,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              onPressed: () {
                if (widget.onAddToBasket != null) {
                  widget.onAddToBasket!();
                  return;
                }

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.mealName} added to basket',
                      ),
                      duration:
                          const Duration(seconds: 2),
                    ),
                  );
              },
              icon: const Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
              ),
              label: const Text(
                'Add to Basket',
                maxLines: 1,
              ),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}