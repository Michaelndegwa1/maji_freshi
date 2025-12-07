import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maji_freshi/widgets/product_card.dart';
import 'package:maji_freshi/widgets/wholesale_card.dart';

void main() {
  testWidgets('ProductCard quantity test', (WidgetTester tester) async {
    int addedQuantity = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            title: 'Test Product',
            price: 'KSH 100',
            imagePath:
                'assets/images/bottle_20l.png', // Ensure this asset exists or mock it
            onAdd: (q) {
              addedQuantity = q;
            },
          ),
        ),
      ),
    );

    // Initial state: quantity 0, ADD button disabled
    expect(find.text('0'), findsOneWidget);
    final addButton = tester.widget<ElevatedButton>(
        find.text('ADD').findAncestorWidgetOfExactType<ElevatedButton>()!);
    expect(addButton.onPressed, isNull);

    // Increment
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // ADD button enabled
    final addButtonEnabled = tester.widget<ElevatedButton>(
        find.text('ADD').findAncestorWidgetOfExactType<ElevatedButton>()!);
    expect(addButtonEnabled.onPressed, isNotNull);

    // Click ADD
    await tester.tap(find.text('ADD'));
    await tester.pump();

    // Verify callback and reset
    expect(addedQuantity, 1);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('WholesaleCard quantity test', (WidgetTester tester) async {
    String addedTitle = '';
    int addedQuantity = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: WholesaleCard(
              onAdd: (t, q) {
                addedTitle = t;
                addedQuantity = q;
              },
            ),
          ),
        ),
      ),
    );

    // Find first item's add button (0.5L)
    // We need to find the specific item. Let's look for text "0.5L (24-Pack)"
    final itemFinder = find.text('0.5L (24-Pack)');
    expect(itemFinder, findsOneWidget);

    // Find the row containing this item
    final rowFinder =
        find.ancestor(of: itemFinder, matching: find.byType(Row)).first;

    // Find the add button in this row.
    // This is tricky with multiple items. Let's tap the first "+" icon we find, which should be for the first item.
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    // Find the "ADD" button. There are multiple. We need the first one.
    await tester.tap(find.text('ADD').first);
    await tester.pump();

    expect(addedTitle, '0.5L (24-Pack)');
    expect(addedQuantity, 1);
  });
}
