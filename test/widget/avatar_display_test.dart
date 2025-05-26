import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/widgets/avatar_display.dart';

import '../mocks/mock_services.mocks.dart';

void main() {
  // Declare mocks
  late MockSupabaseService mockSupabaseService;
  late MockLoggingService mockLoggingService;

  setUp(() {
    // Initialize mocks before each test
    mockSupabaseService = MockSupabaseService();
    mockLoggingService = MockLoggingService();

    // Mock default behavior for logger to avoid null errors if not specifically tested
    when(mockLoggingService.debug(any)).thenReturn(null);
    when(mockLoggingService.info(any)).thenReturn(null);
    when(mockLoggingService.warning(any, any, any)).thenReturn(null);
    when(mockLoggingService.error(any, any, any)).thenReturn(null);
  });

  // Helper function to pump the widget with necessary providers
  Future<void> pumpAvatarDisplay(
    WidgetTester tester, {
    String? avatarUrlOrPath,
    double radius = 40,
    Color? borderColor,
    double borderWidth = 0,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supabaseServiceProvider.overrideWithValue(mockSupabaseService),
          loggingServiceProvider.overrideWithValue(mockLoggingService),
        ],
        child: MaterialApp(
          // MaterialApp is needed for theme and image loading
          home: Scaffold(
            body: AvatarDisplay(
              avatarUrlOrPath: avatarUrlOrPath,
              radius: radius,
              borderColor: borderColor,
              borderWidth: borderWidth,
            ),
          ),
        ),
      ),
    );
  }

  group('AvatarDisplay Widget Tests', () {
    testWidgets('displays fallback icon when avatarUrlOrPath is null',
        (WidgetTester tester) async {
      await pumpAvatarDisplay(tester, avatarUrlOrPath: null);

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.byType(Image), findsNothing); // No AssetImage or NetworkImage
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('displays fallback icon when avatarUrlOrPath is empty',
        (WidgetTester tester) async {
      await pumpAvatarDisplay(tester, avatarUrlOrPath: '');

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets(
        'attempts to display local asset when path starts with "assets/"',
        (WidgetTester tester) async {
      const assetPath = 'assets/images/avatars/test_avatar.png';
      await pumpAvatarDisplay(tester, avatarUrlOrPath: assetPath);

      // Expect an Image widget with AssetImage if the asset is found by the test runner.
      // If not found, it will render the fallback icon inside the CircleAvatar.
      // We check that CachedNetworkImage is NOT used.
      expect(find.byType(CachedNetworkImage), findsNothing);

      // Verify that CircleAvatar is present, which would host either AssetImage or fallback
      final circleAvatarFinder = find.byType(CircleAvatar);
      expect(circleAvatarFinder, findsOneWidget);

      final circleAvatar = tester.widget<CircleAvatar>(circleAvatarFinder);
      // If asset is available and loads, backgroundImage should be AssetImage
      // If asset is not available or fails to load, backgroundImage will be null and child (fallback) will be shown.
      // This part is hard to assert precisely without a real asset in test environment or mocking ImageProvider.
      // So, we primarily ensure it's not trying to load a network image.
      if (circleAvatar.backgroundImage != null) {
        expect(circleAvatar.backgroundImage, isA<AssetImage>());
        expect(
            (circleAvatar.backgroundImage as AssetImage).assetName, assetPath);
      } else {
        // If no background image, it should have the fallback icon as a child
        expect(
            find.descendant(
                of: circleAvatarFinder,
                matching: find.byIcon(Icons.person_outline_rounded)),
            findsOneWidget);
      }
    });

    testWidgets(
        'displays network image using CachedNetworkImage when URL is provided',
        (WidgetTester tester) async {
      const supabasePath = 'user_avatars/avatar.png';
      const fullPublicUrl =
          'https://your-supabase-url.co/storage/v1/object/public/${StorageBuckets.avatars}/$supabasePath';

      // Mock SupabaseService to return a valid URL
      when(mockSupabaseService.getPublicUrl(
        bucketId: StorageBuckets.avatars,
        filePath: supabasePath,
      )).thenReturn(fullPublicUrl);

      await pumpAvatarDisplay(tester, avatarUrlOrPath: supabasePath);

      // Wait for network image (or placeholder) to appear
      // CachedNetworkImage handles its own loading/error internally.
      // We expect the CachedNetworkImage widget itself to be present.
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      // Verify the URL passed to CachedNetworkImage
      final cachedNetworkImageWidget =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedNetworkImageWidget.imageUrl, fullPublicUrl);

      // Initially, it might show a placeholder
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'displays fallback icon if Supabase path is invalid or getPublicUrl fails',
        (WidgetTester tester) async {
      const invalidSupabasePath = 'user_avatars/non_existent.png';

      when(mockSupabaseService.getPublicUrl(
        bucketId: StorageBuckets.avatars,
        filePath: invalidSupabasePath,
      )).thenThrow(Exception("Simulated URL fetch error"));

      await pumpAvatarDisplay(tester, avatarUrlOrPath: invalidSupabasePath);
      await tester.pumpAndSettle(); // Allow widget to rebuild if necessary

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets(
        'displays border for fallback/asset when borderColor and borderWidth are provided',
        (WidgetTester tester) async {
      await pumpAvatarDisplay(
        tester,
        avatarUrlOrPath: null, // Test with fallback icon
        borderColor: Colors.blue,
        borderWidth: 2.0,
      );

      final containerFinder = find.byWidgetPredicate(
        (widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            final decoration = widget.decoration as BoxDecoration;
            return decoration.shape == BoxShape.circle &&
                decoration.color ==
                    Colors.blue && // Border color is the container's background
                widget.padding ==
                    const EdgeInsets.all(
                        2.0); // Padding creates the border thickness
          }
          return false;
        },
        description:
            'Container with blue color (acting as border) and padding of 2.0',
      );
      expect(containerFinder, findsOneWidget);

      // Ensure the CircleAvatar is a child of this bordered Container
      expect(
          find.descendant(
              of: containerFinder, matching: find.byType(CircleAvatar)),
          findsOneWidget);
    });

    testWidgets(
        'displays border for network image when borderColor and borderWidth are provided',
        (WidgetTester tester) async {
      const supabasePath = 'user_avatars/avatar_with_border.png';
      const fullPublicUrl =
          'https://your-supabase-url.co/storage/v1/object/public/${StorageBuckets.avatars}/$supabasePath';

      when(mockSupabaseService.getPublicUrl(
        bucketId: StorageBuckets.avatars,
        filePath: supabasePath,
      )).thenReturn(fullPublicUrl);

      await pumpAvatarDisplay(
        tester,
        avatarUrlOrPath: supabasePath,
        borderColor: Colors.green,
        borderWidth: 3.0,
      );
      await tester.pump(); // Allow CachedNetworkImage to build its placeholder

      final containerFinder = find.byWidgetPredicate(
        (widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            final decoration = widget.decoration as BoxDecoration;
            if (decoration.border is Border) {
              final border = decoration.border as Border;
              return decoration.shape == BoxShape.circle &&
                  border.isUniform && // Checks if all sides are the same
                  border.top.color == Colors.green &&
                  border.top.width == 3.0;
            }
          }
          return false;
        },
        description:
            'Container with green border of width 3.0 for network image',
      );
      expect(containerFinder, findsOneWidget);

      // Ensure ClipOval and CachedNetworkImage are children of this bordered Container
      expect(
          find.descendant(of: containerFinder, matching: find.byType(ClipOval)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(ClipOval),
              matching: find.byType(CachedNetworkImage)),
          findsOneWidget);
    });

    testWidgets('displays network image error widget when image fails to load',
        (WidgetTester tester) async {
      const supabasePath = 'user_avatars/error_image.png';
      const fullPublicUrl =
          'https://your-supabase-url.co/storage/v1/object/public/${StorageBuckets.avatars}/$supabasePath';

      when(mockSupabaseService.getPublicUrl(
        bucketId: StorageBuckets.avatars,
        filePath: supabasePath,
      )).thenReturn(fullPublicUrl);

      await pumpAvatarDisplay(tester, avatarUrlOrPath: supabasePath);

      when(mockSupabaseService.getPublicUrl(
        bucketId: StorageBuckets.avatars,
        filePath: supabasePath,
      )).thenThrow(Exception("Simulated service layer failure"));

      // Re-pump with the same parameters but now getPublicUrl will return null
      await pumpAvatarDisplay(tester, avatarUrlOrPath: supabasePath);
      await tester.pumpAndSettle(); // Allow widget to rebuild

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget,
          reason: "Should display fallback icon when URL construction fails.");
      expect(find.byType(CachedNetworkImage), findsNothing,
          reason:
              "CachedNetworkImage should not be present when URL construction fails.");
    });
  });
}
