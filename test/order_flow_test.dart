import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maji_freshi/models/cart_model.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/screens/order/order_confirmation_screen.dart';
import 'package:maji_freshi/screens/payment/mpesa_payment_screen.dart';

void main() {
  testWidgets('Order flow test', (WidgetTester tester) async {
    // 1. Add item to cart
    final cart = CartService();
    cart.clearCart();
    cart.addItem('Test Item', 100, 'assets/images/test.png', 1);

    expect(cart.items.length, 1);
    expect(cart.totalAmount, 100);

    // 2. Build OrderConfirmationScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderConfirmationScreen(),
      ),
    );

    // 3. Verify total amount is displayed
    expect(find.text('KSH 100'), findsOneWidget);

    // 4. Tap Place Order
    await tester.tap(find.text('PLACE ORDER'));
    await tester.pumpAndSettle();

    // 5. Verify Order Created
    final orderService = OrderService();
    expect(orderService.orders.length, 1);
    expect(orderService.currentOrder!.totalAmount, 100);
    expect(cart.items.length, 0); // Cart should be cleared

    // 6. Verify Navigation to MpesaPaymentScreen
    expect(find.byType(MpesaPaymentScreen), findsOneWidget);
    expect(find.text('KSH 100'), findsOneWidget);
  });
}
