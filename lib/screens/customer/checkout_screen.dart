import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'basket_data.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  static const double _deliveryFee = 2.50;

  String _fulfilmentType = 'delivery';
  bool _isSubmitting = false;

  bool get _isDelivery => _fulfilmentType == 'delivery';

  double _priceToDouble(dynamic value) {
    final String priceText = value
        .toString()
        .replaceAll('£', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(priceText) ?? 0;
  }

  double get _subtotal {
    double amount = 0;

    for (final Map<String, dynamic> item in basketData.basketItems) {
      final double price = _priceToDouble(item['price']);
      final int quantity = item['quantity'] as int? ?? 1;

      amount += price * quantity;
    }

    return amount;
  }

  double get _currentDeliveryFee {
    return _isDelivery ? _deliveryFee : 0;
  }

  double get _total {
    return _subtotal + _currentDeliveryFee;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUserDetails();
  }

  void _loadCurrentUserDetails() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      _nameController.text = user.displayName!.trim();
    }

    if (user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty) {
      _phoneController.text = user.phoneNumber!.trim();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your full name';
    }

    if (value.trim().length < 2) {
      return 'Enter a valid name';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your phone number';
    }

    final String cleanedPhone = value.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleanedPhone.length < 7) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  String? _validateAddress(String? value) {
    if (!_isDelivery) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'Enter your delivery address';
    }

    if (value.trim().length < 8) {
      return 'Enter a complete delivery address';
    }

    return null;
  }

  List<Map<String, dynamic>> _buildOrderItems() {
    return basketData.basketItems.map((item) {
      final double unitPrice = _priceToDouble(item['price']);
      final int quantity = item['quantity'] as int? ?? 1;

      return <String, dynamic>{
        'mealId': item['mealId']?.toString() ?? '',
        'cookId': item['cookId']?.toString() ?? '',
        'name': item['name']?.toString() ?? 'Meal',
        'cook': item['cook']?.toString() ?? 'Home cook',
        'emoji': item['emoji']?.toString() ?? '🍽️',
        'imageUrl': item['imageUrl']?.toString(),
        'unitPrice': unitPrice,
        'quantity': quantity,
        'itemTotal': unitPrice * quantity,
      };
    }).toList();
  }

  Set<String> _getCookIds() {
    return basketData.basketItems
        .map((item) => item['cookId']?.toString() ?? '')
        .where((cookId) => cookId.isNotEmpty)
        .toSet();
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();

    if (basketData.basketItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your basket is empty'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in before placing your order'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<Map<String, dynamic>> orderItems = _buildOrderItems();
      final Set<String> cookIds = _getCookIds();

      final DocumentReference<Map<String, dynamic>> orderReference =
          FirebaseFirestore.instance.collection('orders').doc();

      await orderReference.set({
        'orderId': orderReference.id,
        'customerId': user.uid,
        'customerEmail': user.email ?? '',
        'customerName': _nameController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'fulfilmentType': _fulfilmentType,
        'deliveryAddress':
            _isDelivery ? _addressController.text.trim() : '',
        'notes': _notesController.text.trim(),
        'items': orderItems,
        'cookIds': cookIds.toList(),
        'subtotal': _subtotal,
        'deliveryFee': _currentDeliveryFee,
        'total': _total,
        'status': 'pending',
        'paymentStatus': 'unpaid',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      basketData.clearBasket();

      if (!mounted) {
        return;
      }

      await _showOrderSuccessDialog(orderReference.id);
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? 'Unable to place your order',
            ),
          ),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong. Please try again.',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showOrderSuccessDialog(String orderId) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.large),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.secondaryDark,
                  size: 46,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              const Text(
                'Order placed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              const Text(
                'Your order has been sent to the cook.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.regular),
              Text(
                'Order ${orderId.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: basketData,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Checkout'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.large,
                AppSpacing.page,
                140,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Contact details'),
                  const SizedBox(height: AppSpacing.regular),
                  _buildCustomerDetailsCard(),
                  const SizedBox(height: AppSpacing.section),
                  _buildSectionTitle('How would you like your order?'),
                  const SizedBox(height: AppSpacing.regular),
                  _buildFulfilmentSelector(),
                  if (_isDelivery) ...[
                    const SizedBox(height: AppSpacing.regular),
                    _buildAddressField(),
                  ],
                  const SizedBox(height: AppSpacing.section),
                  _buildSectionTitle('Order notes'),
                  const SizedBox(height: AppSpacing.regular),
                  _buildNotesField(),
                  const SizedBox(height: AppSpacing.section),
                  _buildSectionTitle('Your order'),
                  const SizedBox(height: AppSpacing.regular),
                  _buildItemsCard(),
                  const SizedBox(height: AppSpacing.regular),
                  _buildOrderSummary(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: basketData.basketItems.isEmpty
              ? null
              : _buildPlaceOrderArea(),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
    );
  }

  Widget _buildCustomerDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: _validateName,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.regular),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: _validatePhone,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFulfilmentSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildFulfilmentOption(
            value: 'delivery',
            title: 'Delivery',
            subtitle: 'Delivered to you',
            icon: Icons.delivery_dining_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.regular),
        Expanded(
          child: _buildFulfilmentOption(
            value: 'collection',
            title: 'Collection',
            subtitle: 'Collect from cook',
            icon: Icons.storefront_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildFulfilmentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = _fulfilmentType == value;

    return InkWell(
      onTap: _isSubmitting
          ? null
          : () {
              setState(() {
                _fulfilmentType = value;
              });
            },
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.regular),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceSoft,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
              size: 30,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight:
                    isSelected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: TextFormField(
        controller: _addressController,
        validator: _validateAddress,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.streetAddress,
        minLines: 2,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: 'Delivery address',
          alignLabelWithHint: true,
          prefixIcon: Icon(Icons.location_on_outlined),
          hintText: 'House number, street and postcode',
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: TextFormField(
        controller: _notesController,
        textCapitalization: TextCapitalization.sentences,
        minLines: 3,
        maxLines: 5,
        maxLength: 250,
        decoration: const InputDecoration(
          labelText: 'Additional notes',
          alignLabelWithHint: true,
          prefixIcon: Icon(Icons.notes_rounded),
          hintText: 'Delivery instructions or requests',
        ),
      ),
    );
  }

  Widget _buildItemsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: basketData.basketItems.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> item = entry.value;

          final String name = item['name']?.toString() ?? 'Meal';
          final String emoji = item['emoji']?.toString() ?? '🍽️';
          final int quantity = item['quantity'] as int? ?? 1;
          final double unitPrice = _priceToDouble(item['price']);
          final double itemTotal = unitPrice * quantity;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.regular),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: $quantity',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '£${itemTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (index < basketData.basketItems.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.regular,
                  ),
                  child: Divider(height: 1),
                ),
            ],
          );
        }).toList(),
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
      ),
      child: Column(
        children: [
          _buildPriceRow(
            title: 'Subtotal',
            price: '£${_subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.regular),
          _buildPriceRow(
            title: _isDelivery ? 'Delivery fee' : 'Collection',
            price: _isDelivery
                ? '£${_currentDeliveryFee.toStringAsFixed(2)}'
                : 'Free',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.regular,
            ),
            child: Divider(),
          ),
          _buildPriceRow(
            title: 'Total',
            price: '£${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String title,
    required String price,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isTotal ? 17 : 14,
            fontWeight:
                isTotal ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          price,
          style: TextStyle(
            color:
                isTotal ? AppColors.primary : AppColors.textPrimary,
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.regular),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 18,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _isSubmitting ? null : _placeOrder,
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Place Order  •  £${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}