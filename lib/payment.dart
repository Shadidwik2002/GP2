import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessing = false;
  bool _isPaymentSuccessful = false;

  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isValidExpiryDate() {
    if (_expiryDateController.text.isEmpty) return false;

    final parts = _expiryDateController.text.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return year > currentYear || (year == currentYear && month >= currentMonth);
  }

  void _submitPayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (_selectedPaymentMethod == 'Credit Card') {
      if (_cardHolderController.text.isEmpty ||
          _cardNumberController.text.isEmpty ||
          _expiryDateController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all credit card details')),
        );
        return;
      }
      if (_cardNumberController.text.length != 16) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card number must be 16 digits')),
        );
        return;
      }
      if (_cvvController.text.length != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CVV must be 3 digits')),
        );
        return;
      }
      if (!_expiryDateController.text.contains('/') ||
          _expiryDateController.text.length != 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expiry date must be in MM/YYYY format')),
        );
        return;
      }
      if (!_isValidExpiryDate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card has expired')),
        );
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _isPaymentSuccessful = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Successful!')),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a Payment Method:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedPaymentMethod,
                hint: const Text('Select Payment Method'),
                isExpanded: true,
                items: ['Cash', 'Credit Card']
                    .map((method) => DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (_selectedPaymentMethod == 'Credit Card') ...[
                const Text(
                  'Enter Credit Card Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(
                    labelText: 'Cardholder Name',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expiryDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          border: OutlineInputBorder(),
                          hintText: 'MM/YYYY',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryDateFormatter(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              ElevatedButton(
                onPressed: _isProcessing ? null : _submitPayment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Payment',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    final cursorPosition = newValue.selection.start;

    if (oldValue.text.length > newValue.text.length) {
      if (oldValue.text.length == 3 && oldValue.text.contains('/')) {
        text = text.substring(0, text.length - 1);
      }
      return TextEditingValue(
        text: text.length <= 2 ? text : '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(
          offset: cursorPosition,
        ),
      );
    }

    if (text.length >= 2) {
      int month = int.tryParse(text.substring(0, 2)) ?? 0;
      if (month == 0) {
        text = '01${text.substring(2)}';
      } else if (month > 12) {
        text = '12${text.substring(2)}';
      }

      text = '${text.substring(0, 2)}/${text.substring(2)}';

      if (text.length > 7) {
        text = text.substring(0, 7);
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }
}
