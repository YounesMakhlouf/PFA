import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/providers/app_language_notifier.dart';
import 'package:pfa/providers/global_providers.dart';

import '../mocks/mock_services.mocks.dart';

void main() {
  late MockSettingsService mockSettingsService;
  late MockLoggingService mockLoggingService;
  late ProviderContainer container;

  AppLanguageNotifier createNotifier({AppLanguage? initialLanguage}) {
    return AppLanguageNotifier(
      mockSettingsService,
      mockLoggingService,
      initialLanguage: initialLanguage,
    );
  }

  setUp(() {
    mockSettingsService = MockSettingsService();
    mockLoggingService = MockLoggingService();

    when(mockSettingsService.getAppLanguage(defaultValue: AppLanguage.arabic))
        .thenAnswer((_) async => AppLanguage.arabic);

    when(mockSettingsService.setAppLanguage(any)).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        settingsServiceProvider.overrideWithValue(mockSettingsService),
        loggingServiceProvider.overrideWithValue(mockLoggingService),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AppLanguageNotifier', () {
    test(
        'initializes with default ARABIC if no initialLanguage and no saved language',
        () async {
      // Arrange: SettingsService will return default (Arabic)
      when(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic)) // <<< ARABIC DEFAULT
          .thenAnswer((_) async => AppLanguage.arabic);

      final notifier = createNotifier();
      await Future.delayed(Duration.zero);

      expect(notifier.state, AppLanguage.arabic);
      verify(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic))
          .called(1); // <<< ARABIC DEFAULT
      verify(mockLoggingService
              .info("AppLanguageNotifier: Loaded language - ar"))
          .called(1);
    });

    test(
        'initializes with saved French language from SettingsService (when default is Arabic)',
        () async {
      // Arrange
      when(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic)) // <<< ARABIC DEFAULT
          .thenAnswer((_) async => AppLanguage.french);

      final notifier = createNotifier();
      await Future.delayed(Duration.zero);

      expect(notifier.state, AppLanguage.french);
      verify(mockLoggingService
              .info("AppLanguageNotifier: Loaded language - fr"))
          .called(1);
    });

    test(
        'initializes with forced initialLanguage English parameter (overrides Arabic default)',
        () {
      final notifier = createNotifier(initialLanguage: AppLanguage.english);

      expect(notifier.state, AppLanguage.english);
      verify(mockLoggingService.info(
              "AppLanguageNotifier: Initialized with forced language - en"))
          .called(1);
      verifyNever(mockSettingsService.getAppLanguage(
          defaultValue: AppLanguage.arabic)); // <<< ARABIC DEFAULT
    });

    test('updateLanguage sets new language and saves to SettingsService',
        () async {
      // Arrange: Start with Arabic
      when(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic)) // <<< ARABIC DEFAULT
          .thenAnswer((_) async => AppLanguage.arabic);
      final notifier = createNotifier();
      await Future.delayed(Duration.zero);
      expect(notifier.state, AppLanguage.arabic);

      // Act
      await notifier.updateLanguage(AppLanguage.french);

      // Assert
      expect(notifier.state, AppLanguage.french);
      verify(mockSettingsService.setAppLanguage(AppLanguage.french)).called(1);
    });

    test(
        'provider initializes and loads language correctly (defaulting to Arabic, then finding saved)',
        () async {
      // Arrange
      when(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic)) // <<< ARABIC DEFAULT
          .thenAnswer(
              (_) async => AppLanguage.french); // Simulate French is saved

      // Act
      container.read(appLanguageProvider.notifier);
      await Future.delayed(Duration.zero);

      // Assert
      expect(container.read(appLanguageProvider), AppLanguage.french);
      verify(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic))
          .called(1); // <<< ARABIC DEFAULT
    });

    test('provider updates language through notifier method', () async {
      // Arrange: Start with Arabic
      when(mockSettingsService.getAppLanguage(
              defaultValue: AppLanguage.arabic)) // <<< ARABIC DEFAULT
          .thenAnswer((_) async => AppLanguage.arabic);
      container.read(appLanguageProvider.notifier);
      await Future.delayed(Duration.zero);
      expect(container.read(appLanguageProvider), AppLanguage.arabic);

      final notifier = container.read(appLanguageProvider.notifier);
      await notifier.updateLanguage(AppLanguage.english);

      expect(container.read(appLanguageProvider), AppLanguage.english);
      verify(mockSettingsService.setAppLanguage(AppLanguage.english)).called(1);
    });
  });
}
