import 'package:better_hm/home/dashboard/card_list_tile.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('adding, removing cards works', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await addTwoCards(tester);

    final Finder deleteButtons = find.byIcon(Icons.delete_forever_rounded);

    expect(deleteButtons, findsNWidgets(2));
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    expect(find.byType(CardListTile), findsOneWidget);

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(DashboardCard), findsOneWidget);

    await tester.tap(find.byType(ManageCardsButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_forever_rounded));
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardCard), findsNothing);
  });

  testWidgets('moving Widgets works', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await addTwoCards(tester);

    final Finder dragHandler = find.byIcon(Icons.drag_handle);
    expect(dragHandler, findsNWidgets(2));

    await tester.drag(dragHandler.first, const Offset(0, 50));

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(DashboardCard), findsNWidgets(2));

    // TODO check if the order is correct
  });
}

/// Navigates from the home screen to the manage Cards screen
/// and adds one SemesterStatus and one NextDepartures card
Future<void> addTwoCards(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final Finder manageCardsButton = find.byType(ManageCardsButton);
  expect(manageCardsButton, findsOneWidget);
  await tester.tap(manageCardsButton);
  await tester.pumpAndSettle();

  final Finder fab = find.byType(FloatingActionButton);
  expect(fab, findsOneWidget);

  await tester.tap(fab);
  await tester.pumpAndSettle();
  await tester.tap(find.text("semesterStatus"));
  await tester.pumpAndSettle();
  await tester.tap(fab);
  await tester.pumpAndSettle();
  await tester.tap(find.text("nextDepartures"));
  await tester.pumpAndSettle();
}
