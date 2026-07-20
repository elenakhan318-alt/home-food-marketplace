import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'Card';

  final TextEditingController addressController = TextEditingController(
    text: '12 New Street, Birmingham, B2 4QA',
  );

  final TextEditingController phoneController = TextEditingController(
    text: '07123 456789',
  );

  final TextEditingController instructionsController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  void _placeOrder() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const OrderConfirmationScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Delivery Address'),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                hintText: 'Enter delivery address',
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            _buildSectionTitle('Contact Number'),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: 'Enter phone number',
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            _buildSectionTitle('Delivery Instructions'),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: instructionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.notes_rounded),
                hintText: 'Example: Leave at the front door',
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: AppSpacing.small),
            _buildPaymentOption(
              title: 'Card',
              subtitle: 'Visa ending in 4242',
              icon: Icons.credit_card_rounded,
            ),
            const SizedBox(height: AppSpacing.small),
            _buildPaymentOption(
              title: 'Cash',
              subtitle: 'Pay when your meal arrives',
              icon: Icons.payments_outlined,
            ),
            const SizedBox(height: AppSpacing.large),
            _buildOrderSummary(),
            const SizedBox(height: 110),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = selectedPaymentMethod == title;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.card),
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.regular),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
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
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.large),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSpacing.small),
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),

        Container(
          padding: const EdgeInsets.all(AppSpacing.regular),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: const Row(
            children: [
              Text(
                '🍛',
                style: TextStyle(fontSize: 34),
              ),
              SizedBox(width: AppSpacing.regular),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chicken Biryani',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Amina's Kitchen",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '£9.95',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.large),

        const _SummaryRow(
          title: 'Subtotal',
          price: '£9.95',
        ),

        SizedBox(height: AppSpacing.regular),

        const _SummaryRow(
          title: 'Delivery Fee',
          price: '£2.50',
        ),

        SizedBox(height: AppSpacing.regular),

        const Divider(),

        SizedBox(height: AppSpacing.regular),

        const _SummaryRow(
          title: 'Total',
          price: '£12.45',
          isTotal: true,
        ),
      ],
    ),
  );
}
 Widget _buildBottomButton() {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.regular,
        12,
        AppSpacing.regular,
        AppSpacing.regular,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton(
          onPressed: _placeOrder,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 18,
              ),
              SizedBox(width: AppSpacing.small),
              Text(
                'Place Order',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: AppSpacing.small),
              Text('•'),
              SizedBox(width: AppSpacing.small),
              Text(
                '£12.45',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String price;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.price,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          price,
          style: TextStyle(
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
            fontSize: isTotal ? 19 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}