import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/providers/haptics_enabled_notifier.dart';
import 'package:pfa/widgets/option_widget.dart';

import '../mocks/mock_data.dart';
import '../mocks/mock_services.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSupabaseService mockSupabaseService;
  late MockLoggingService mockLoggingService;
  late MockAppLocalizations mockL10n;
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockSupabaseService = MockSupabaseService();
    mockLoggingService = MockLoggingService();
    mockL10n = MockAppLocalizations();
    mockSettingsService = MockSettingsService();

    // Default mock behaviors
    when(mockLoggingService.debug(any)).thenReturn(null);
    when(mockLoggingService.info(any)).thenReturn(null);
    when(mockLoggingService.warning(any, any, any)).thenReturn(null);
    when(mockLoggingService.error(any, any, any)).thenReturn(null);

    // Mock l10n calls used in Semantics
    when(mockL10n.selectableOption).thenReturn('Selectable Option');
    when(mockL10n.selected).thenReturn('Selected');
    when(mockL10n.matched).thenReturn('Matched');
    when(mockL10n.imageOption).thenReturn('Image Option');
    when(mockSettingsService.areHapticsEnabled(
            defaultValue: anyNamed('defaultValue')))
        .thenAnswer((_) async => true); // Default to true for tap tests
  });

  Future<void> pumpOptionWidget(
    WidgetTester tester, {
    required Option option,
    required VoidCallback onTap,
    Color? gameThemeColor,
    bool isSelected = false,
    bool isDisabled = false,
    bool isRevealed = true,
    bool isMatched = false,
    double size = 100.0,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supabaseServiceProvider.overrideWithValue(mockSupabaseService),
          loggingServiceProvider.overrideWithValue(mockLoggingService),
          settingsServiceProvider.overrideWithValue(mockSettingsService),
          hapticsEnabledProvider.overrideWith(
            (ref) => HapticsEnabledNotifier(
              ref.read(settingsServiceProvider),
              ref.read(loggingServiceProvider),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: OptionWidget(
                option: option,
                onTap: onTap,
                gameThemeColor: gameThemeColor,
                isSelected: isSelected,
                isDisabled: isDisabled,
                isRevealed: isRevealed,
                isMatched: isMatched,
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('OptionWidget Tests', () {
    testWidgets('displays text content when picturePath is null or empty',
        (WidgetTester tester) async {
      final option = mockOption(labelText: 'Test Text', picturePath: null);
      await pumpOptionWidget(tester, option: option, onTap: () {});

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byIcon(Icons.question_mark_rounded),
          findsNothing); // Should be revealed
    });

    testWidgets('displays image content when picturePath is valid',
        (WidgetTester tester) async {
      const imagePath = 'path/to/image.png';
      const fullUrl =
          'https://supabase.url/storage/v1/object/public/${StorageBuckets.gameAssets}/$imagePath';
      final option = mockOption(picturePath: imagePath, labelText: "Image Opt");

      when(mockSupabaseService.getPublicUrl(
              bucketId: StorageBuckets.gameAssets, filePath: imagePath))
          .thenReturn(fullUrl);

      await pumpOptionWidget(tester, option: option, onTap: () {});

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.imageUrl, fullUrl);
      expect(find.text("Image Opt"),
          findsNothing); // Text should not be shown if image is present
    });

    testWidgets('displays card back when isRevealed is false',
        (WidgetTester tester) async {
      final option = mockOption(labelText: 'Hidden Text');
      await pumpOptionWidget(tester,
          option: option, onTap: () {}, isRevealed: false);

      expect(find.byIcon(Icons.question_mark_rounded), findsOneWidget);
      expect(find.text('Hidden Text'), findsNothing);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('calls onTap callback when tapped and not disabled',
        (WidgetTester tester) async {
      bool tapped = false;
      final option = mockOption(labelText: 'Tap Me');
      await pumpOptionWidget(tester,
          option: option, onTap: () => tapped = true);

      await tester.tap(find.byType(OptionWidget));
      await tester.pump(); // Process tap

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap callback when disabled',
        (WidgetTester tester) async {
      bool tapped = false;
      final option = mockOption(labelText: 'Disabled');
      await pumpOptionWidget(tester,
          option: option, onTap: () => tapped = true, isDisabled: true);

      await tester.tap(find.byType(OptionWidget),
          warnIfMissed: false); // warnIfMissed: false for disabled
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('shows selected border when isSelected is true and not matched',
        (WidgetTester tester) async {
      final option = mockOption();
      await pumpOptionWidget(tester,
          option: option, onTap: () {}, isSelected: true, isMatched: false);

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder?;
      expect(
          shape?.side.color,
          Theme.of(tester.element(find.byType(OptionWidget)))
              .colorScheme
              .primary);
      expect(shape?.side.width, 3.0);
    });

    testWidgets('shows matched appearance when isMatched is true',
        (WidgetTester tester) async {
      final option = mockOption();
      await pumpOptionWidget(tester,
          option: option,
          onTap: () {},
          isMatched: true,
          isSelected: false); // isSelected can be false if matched

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder?;
      expect(card.color, AppColors.success.withValues(alpha: 0.25));
      expect(shape?.side.color, AppColors.success.withValues(alpha: 0.6));
    });

    testWidgets('applies opacity when disabled or matched',
        (WidgetTester tester) async {
      final option = mockOption();

      // Test isDisabled and not revealed (card back)
      await pumpOptionWidget(tester,
          option: option, onTap: () {}, isDisabled: true, isRevealed: false);
      var opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.6);

      // Test isDisabled and revealed (but not matched)
      await pumpOptionWidget(tester,
          option: option,
          onTap: () {},
          isDisabled: true,
          isRevealed: true,
          isMatched: false);
      opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.8);

      // Test isMatched
      await pumpOptionWidget(tester,
          option: option, onTap: () {}, isMatched: true);
      opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.7);
    });

    testWidgets(
        'uses gameThemeColor for background if provided and not matched',
        (WidgetTester tester) async {
      final option = mockOption();
      const testColor = Colors.purple;
      await pumpOptionWidget(tester,
          option: option,
          onTap: () {},
          gameThemeColor: testColor,
          isMatched: false);

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, testColor);
    });

    testWidgets('Semantics labels are set correctly', (WidgetTester tester) async {
      final textOption = mockOption(labelText: 'Semantic Text');
      final imageOption = mockOption(picturePath: 'path/image.png', labelText: null);

      when(mockSupabaseService.getPublicUrl(bucketId: anyNamed('bucketId'), filePath: anyNamed('filePath')))
          .thenReturn('http://dummyurl.com/image.png');

      // Test with text
      await pumpOptionWidget(tester, option: textOption, onTap: () {});
      // Find the OptionWidget first, then find the Semantics widget that is a descendant of it.
      final optionWidgetFinder = find.byType(OptionWidget);
      expect(optionWidgetFinder, findsOneWidget, reason: "OptionWidget itself should be found");

      final semanticsFinder = find.byKey(OptionWidget.semanticsKey);
      expect(semanticsFinder, findsOneWidget, reason: "Should find the OptionWidget's main Semantics node by key");

      expect(semanticsFinder, findsOneWidget, reason: "Should find one Semantics widget within OptionWidget");
      var semantics = tester.widget<Semantics>(semanticsFinder);
      expect(semantics.properties.label, 'Semantic Text');
      expect(semantics.properties.value, null);

      // Test with image (and no labelText)
      await pumpOptionWidget(tester, option: imageOption, onTap: () {});
      // Re-find because the widget tree was rebuilt
      semantics = tester.widget<Semantics>(find.byKey(OptionWidget.semanticsKey));
      expect(semantics.properties.label, 'Image Option');

      // Test selected state
      await pumpOptionWidget(tester, option: textOption, onTap: () {}, isSelected: true);
      semantics = tester.widget<Semantics>(find.byKey(OptionWidget.semanticsKey));
      expect(semantics.properties.value, 'Selected');

      // Test matched state
      await pumpOptionWidget(tester, option: textOption, onTap: () {}, isMatched: true);
      semantics = tester.widget<Semantics>(find.byKey(OptionWidget.semanticsKey));
      expect(semantics.properties.value, 'Matched');
    });
    });
}
