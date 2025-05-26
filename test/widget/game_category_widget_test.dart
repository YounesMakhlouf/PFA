import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/widgets/category_card_widget.dart';
import 'package:pfa/config/app_theme.dart';

Widget createTestableWidget({required Widget child}) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('CategoryCardWidget Tests', () {
    testWidgets('renders correctly with given category data',
        (WidgetTester tester) async {
      const testCategory = GameCategory.COLORS_SHAPES;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
          onTap: () {}, // Provide a no-op callback
        ),
      ));

      // Verify title (localized name of the category)
      // We need to get the AppLocalizations instance for the test environment
      final element = tester.element(find.byType(CategoryCardWidget));
      final l10n = AppLocalizations.of(element);
      expect(find.text(l10n.colorsAndShapes), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped and enabled',
        (WidgetTester tester) async {
      bool tapped = false;
      const testCategory = GameCategory.ANIMALS;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
          onTap: () {
            tapped = true;
          },
          isEnabled: true,
        ),
      ));

      await tester
          .tap(find.byType(InkWell)); // Tap the InkWell part of the card
      await tester.pump(); // Rebuild the widget after the tap

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap callback when tapped and disabled',
        (WidgetTester tester) async {
      bool tapped = false;
      const testCategory = GameCategory.NUMBERS;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
          onTap: () {
            tapped = true;
          },
          isEnabled: false, // Card is disabled
        ),
      ));

      // Attempt to tap. Since it's disabled, the InkWell's onTap should be null.
      // Direct tap on InkWell might still register visually but not call the callback.
      // A better way to test this is to check if the InkWell's onTap is null.
      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNull);

      // Even if we simulate a tap, the callback shouldn't fire.
      await tester
          .tap(find.byType(CategoryCardWidget)); // Tap the widget itself
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('shows reduced opacity when disabled',
        (WidgetTester tester) async {
      const testCategory = GameCategory.EMOTIONS;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
          isEnabled: false,
        ),
      ));

      // Find the Opacity widget and check its opacity value
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets('shows full opacity when enabled', (WidgetTester tester) async {
      const testCategory = GameCategory.FRUITS_VEGETABLES;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
          isEnabled: true,
        ),
      ));

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 1.0);
    });

    // Test for a different category to ensure mapping works
    testWidgets('renders correctly for LOGICAL_THINKING category',
        (WidgetTester tester) async {
      const testCategory = GameCategory.LOGICAL_THINKING;

      await tester.pumpWidget(createTestableWidget(
        child: CategoryCardWidget(
          category: testCategory,
        ),
      ));

      final element = tester.element(find.byType(CategoryCardWidget));
      final l10n = AppLocalizations.of(element);
      expect(find.text(l10n.logicalThinking), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });
  });
}
