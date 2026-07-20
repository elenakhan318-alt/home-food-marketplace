import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'Visa',
      'lastFour': '4242',
      'expiry': '08/28',
      'isDefault': true,
    },
    {
      'type': 'Mastercard',
      'lastFour': '8391',
      'expiry': '11/27',
      'isDefault': false,
    },
  ];

  void _setDefaultPaymentMethod(int selectedIndex) {
    setState(() {
      for (int index = 0; index < _paymentMethods.length; index++) {
        _paymentMethods[index]['isDefault'] = index == selectedIndex;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default payment method updated.'),
      ),
    );
  }

  void _deletePaymentMethod(int index) {
    final bool isDefault = _paymentMethods[index]['isDefault'] as bool;

    setState(() {
      _paymentMethods.removeAt(index);

      if (isDefault && _paymentMethods.isNotEmpty) {
        _paymentMethods[0]['isDefault'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method deleted.'),
      ),
    );
  }

  void _showAddCardDialog() {
    final TextEditingController cardNumberController =
        TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Payment Card'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Card number',
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Expiry date',
                    hintText: 'MM/YY',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String cardNumber =
                    cardNumberController.text.replaceAll(' ', '').trim();
                final String expiry = expiryController.text.trim();

                if (cardNumber.length < 4 || expiry.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid card details.'),
                    ),
                  );
                  return;
                }

                final String lastFour =
                    cardNumber.substring(cardNumber.length - 4);

                setState(() {
                  _paymentMethods.add({
                    'type': 'Card',
                    'lastFour': lastFour,
                    'expiry': expiry,
                    'isDefault': _paymentMethods.isEmpty,
                  });
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment card added.'),
                  ),
                );
              },
              child: const Text('Add Card'),
            ),
          ],
        );
      },
    );
  }

  IconData _getCardIcon(String type) {
    if (type == 'Visa') {
      return Icons.credit_card_rounded;
    }

    if (type == 'Mastercard') {
      return Icons.payment_rounded;
    }

    return Icons.credit_card_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D342F),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF3D342F),
        ),
      ),
      body: _paymentMethods.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              itemCount: _paymentMethods.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                final Map<String, dynamic> paymentMethod =
                    _paymentMethods[index];

                return _buildPaymentCard(paymentMethod, index);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCardDialog,
        backgroundColor: const Color(0xFFFFD5C7),
        foregroundColor: const Color(0xFF6B3E2E),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Card',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    Map<String, dynamic> paymentMethod,
    int index,
  ) {
    final bool isDefault = paymentMethod['isDefault'] as bool;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDefault
            ? Border.all(
                color: const Color(0xFFEB6A3A),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE1D6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCardIcon(paymentMethod['type'] as String),
              color: const Color(0xFFDB7049),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      paymentMethod['type'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D342F),
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDECDD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF59815A),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '•••• •••• •••• ${paymentMethod['lastFour']}',
                  style: const TextStyle(
                    color: Color(0xFF766C67),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires ${paymentMethod['expiry']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9A908A),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'default') {
                _setDefaultPaymentMethod(index);
              } else if (value == 'delete') {
                _deletePaymentMethod(index);
              }
            },
            itemBuilder: (context) {
              return [
                if (!isDefault)
                  const PopupMenuItem<String>(
                    value: 'default',
                    child: Row(
                      children: [
                        Icon(Icons.star_outline),
                        SizedBox(width: 10),
                        Text('Set as default'),
                      ],
                    ),
                  ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 10),
                      Text('Delete'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card_off_outlined,
              size: 70,
              color: Color(0xFFDB7049),
            ),
            const SizedBox(height: 18),
            const Text(
              'No payment methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D342F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a card to make checkout faster.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF766C67),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddCardDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }
}