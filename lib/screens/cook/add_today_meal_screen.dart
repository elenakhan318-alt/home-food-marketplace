import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AddTodayMealScreen extends StatefulWidget {
  const AddTodayMealScreen({super.key});

  @override
  State<AddTodayMealScreen> createState() => _AddTodayMealScreenState();
}

class _AddTodayMealScreenState extends State<AddTodayMealScreen> {
  final _formKey = GlobalKey<FormState>();

  final _mealNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _portionsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _allergensController = TextEditingController();

  TimeOfDay? _readyTime;
  TimeOfDay? _cutOffTime;

  bool _deliveryAvailable = true;
  bool _collectionAvailable = true;

  @override
  void dispose() {
    _mealNameController.dispose();
    _priceController.dispose();
    _portionsController.dispose();
    _ingredientsController.dispose();
    _allergensController.dispose();
    super.dispose();
  }

  Future<void> _selectReadyTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _readyTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _readyTime = selectedTime;
      });
    }
  }

  Future<void> _selectCutOffTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _cutOffTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _cutOffTime = selectedTime;
      });
    }
  }

  void _publishMeal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_readyTime == null || _cutOffTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose the ready time and order cut-off time.',
          ),
        ),
      );
      return;
    }

    if (!_deliveryAvailable && !_collectionAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose delivery, collection, or both.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_mealNameController.text} has been published for today.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Choose time';
    }

    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Today’s Meal'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.regular,
              AppSpacing.page,
              120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotoSection(),
                const SizedBox(height: AppSpacing.large),
                _buildTextField(
                  controller: _mealNameController,
                  label: 'Meal name',
                  hint: 'Example: Chicken Biryani',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a meal name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.regular),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: 'Price per portion',
                        hint: '9.95',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixText: '£',
                        validator: (value) {
                          final price = double.tryParse(value ?? '');

                          if (price == null || price <= 0) {
                            return 'Enter a valid price.';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.regular),
                    Expanded(
                      child: _buildTextField(
                        controller: _portionsController,
                        label: 'Portions available',
                        hint: '10',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final portions = int.tryParse(value ?? '');

                          if (portions == null || portions <= 0) {
                            return 'Enter portions.';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.large),
                _buildTimeCard(
                  title: 'Ready from',
                  value: _formatTime(_readyTime),
                  icon: Icons.schedule_rounded,
                  onTap: _selectReadyTime,
                ),
                const SizedBox(height: AppSpacing.regular),
                _buildTimeCard(
                  title: 'Order cut-off time',
                  value: _formatTime(_cutOffTime),
                  icon: Icons.timer_outlined,
                  onTap: _selectCutOffTime,
                ),
                const SizedBox(height: AppSpacing.large),
                _buildFulfilmentSection(),
                const SizedBox(height: AppSpacing.large),
                _buildTextField(
                  controller: _ingredientsController,
                  label: 'Ingredients',
                  hint: 'Rice, chicken, onions, spices...',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the ingredients.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.regular),
                _buildTextField(
                  controller: _allergensController,
                  label: 'Allergens',
                  hint: 'Example: Milk, nuts, gluten, or none',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter allergen information.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.large),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _publishMeal,
                    icon: const Icon(Icons.publish_rounded),
                    label: const Text('Publish Meal for Today'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo upload will be connected next.'),
            ),
          );
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 44,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.small),
            Text(
              'Add a meal photo',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Use a clear photo of today’s food',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.regular),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.regular),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFulfilmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How can customers receive this meal?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _deliveryAvailable,
            title: const Text('Delivery'),
            subtitle: const Text('You can deliver this meal'),
            onChanged: (value) {
              setState(() {
                _deliveryAvailable = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _collectionAvailable,
            title: const Text('Collection'),
            subtitle: const Text('Customer can collect from you'),
            onChanged: (value) {
              setState(() {
                _collectionAvailable = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }
}