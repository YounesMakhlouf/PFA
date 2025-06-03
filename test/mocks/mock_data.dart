// test/mocks/mock_data.dart
import 'package:pfa/models/game.dart';
import 'package:pfa/models/game_session.dart' as gs_model;
import 'package:pfa/models/level.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/repositories/game_repository.dart';

// --- Child Mocks (Example) ---
final mockChild1 = Child(
    childId: 'child-uuid-001',
    accountId: 'parent-auth-uuid-001',
    firstName: 'Alex',
    lastName: 'Test',
    birthdate: DateTime(2018, 5, 10),
    specialConditions: {SpecialCondition.AUTISM},
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    avatarUrl: 'assets/images/avatars/avatar1.png');

// --- Option Mocks ---
Option mockOption({
  String id = 'opt_default_id',
  String screenId = 'scr_default_id',
  String? labelText = 'Default Option Label',
  String? picturePath,
  String? audioPath,
  bool isCorrect = false,
  String? pairId,
}) {
  return Option(
    optionId: id,
    screenId: screenId,
    labelText: labelText,
    picturePath: picturePath,
    audioPath: audioPath,
    isCorrect: isCorrect,
    pairId: pairId,
  );
}

// --- Screen Mocks ---
MultipleChoiceScreen mockMCScreen({
  String id = 'mc_screen_default_id',
  String levelId = 'lvl_default_id',
  int number = 1,
  String? instruction = 'Tap the correct option.',
}) {
  return MultipleChoiceScreen(
    screenId: id,
    levelId: levelId,
    screenNumber: number,
    instruction: instruction,
  );
}

MemoryScreen mockMemoryScreen({
  String id = 'mem_screen_default_id',
  String levelId = 'lvl_default_id',
  int number = 1,
  String? instruction = 'Find the matching pairs.',
}) {
  return MemoryScreen(
    screenId: id,
    levelId: levelId,
    screenNumber: number,
    instruction: instruction,
  );
}

// --- ScreenWithOptionsMenu Mocks ---
ScreenWithOptionsMenu mockScreenWithMcOptions({
  String screenId = 'mc_swo_id',
  List<Option>? options,
}) {
  final screen = mockMCScreen(id: screenId);
  return ScreenWithOptionsMenu(
    screen: screen,
    options: options ??
        [
          mockOption(
              id: '${screenId}_opt1',
              screenId: screenId,
              labelText: 'Option 1',
              isCorrect: true),
          mockOption(
              id: '${screenId}_opt2',
              screenId: screenId,
              labelText: 'Option 2'),
        ],
  );
}

ScreenWithOptionsMenu mockScreenWithMemoryOptions({
  String screenId = 'mem_swo_id',
  List<Option>? options,
}) {
  final screen = mockMemoryScreen(id: screenId);
  return ScreenWithOptionsMenu(
    screen: screen,
    options: options ??
        [
          // Example pairs
          mockOption(
              id: '${screenId}_optA1',
              screenId: screenId,
              labelText: 'Card A',
              pairId: 'pairA'),
          mockOption(
              id: '${screenId}_optA2',
              screenId: screenId,
              labelText: 'Card A',
              pairId: 'pairA'),
          mockOption(
              id: '${screenId}_optB1',
              screenId: screenId,
              labelText: 'Card B',
              pairId: 'pairB'),
          mockOption(
              id: '${screenId}_optB2',
              screenId: screenId,
              labelText: 'Card B',
              pairId: 'pairB'),
        ],
  );
}

// --- Level Mocks ---
Level mockLevel({
  String id = 'lvl_default_id',
  String gameId = 'game_default_id',
  int number = 1,
}) {
  return Level(
    levelId: id,
    gameId: gameId,
    levelNumber: number,
  );
}

// --- Game Mocks ---
Game mockGame({
  String id = 'game_default_id',
  String name = 'Default Test Game',
  String? imagePath = 'default/game_image.png',
  String? description = 'This is a default test game.',
  GameCategory category = GameCategory.EDUCATION,
  GameType type = GameType.MULTIPLE_CHOICE,
  String? themeColorCode = '#4CAF50',
  String? iconName = 'default_icon',
  String? educatorId,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Game(
    gameId: id,
    name: name,
    pictureUrl: imagePath,
    description: description,
    category: category,
    type: type,
    themeColorCode: themeColorCode,
    iconName: iconName,
    educatorId: educatorId,
    createdAt: createdAt ?? DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: updatedAt ?? DateTime.now(),
  );
}

// --- GameSession Mocks (Example) ---
gs_model.GameSession mockGameSession({
  String sessionId = 'session_default_id',
  String childId = 'child_default_id',
  String gameId = 'game_default_id',
  String levelId = 'level_default_id',
  DateTime? startTime,
  DateTime? endTime,
  bool completed = false,
  int totalAttempts = 0,
  int correctAttempts = 0,
  int hintsUsed = 0,
}) {
  return gs_model.GameSession(
    sessionId: sessionId,
    childId: childId,
    gameId: gameId,
    levelId: levelId,
    startTime: startTime ?? DateTime.now().subtract(const Duration(minutes: 5)),
    endTime: endTime,
    completed: completed,
    totalAttempts: totalAttempts,
    correctAttempts: correctAttempts,
    hintsUsed: hintsUsed,
  );
}

// --- Commonly used sets of mock data for specific test scenarios ---
// A complete game setup for initialization tests
final mockFullGameSetup = _MockFullGameData();

class _MockFullGameData {
  final Game game;
  final Level level1;
  final Level level2;
  final MultipleChoiceScreen mcScreenL1S1;
  final Option mcOptionCorrectL1S1;
  final Option mcOptionIncorrectL1S1;
  late final ScreenWithOptionsMenu mcScreenDataL1S1;

  final MemoryScreen memScreenL2S1;
  final Option memOptionA1L2S1;
  final Option memOptionA2L2S1;
  final Option memOptionB1L2S1;
  final Option memOptionB2L2S1;
  late final ScreenWithOptionsMenu memScreenDataL2S1;

  final List<String> level1ScreenIds;
  final List<String> level2ScreenIds;

  _MockFullGameData()
      : game = mockGame(id: 'full_game_id', name: 'Full Test Game'),
        level1 =
            mockLevel(id: 'full_lvl1_id', gameId: 'full_game_id', number: 1),
        level2 =
            mockLevel(id: 'full_lvl2_id', gameId: 'full_game_id', number: 2),
        mcScreenL1S1 = mockMCScreen(
            id: 'mc_s1_l1_full',
            levelId: 'full_lvl1_id',
            number: 1,
            instruction: 'MC L1S1 Instruction'),
        memScreenL2S1 = mockMemoryScreen(
            id: 'mem_s1_l2_full',
            levelId: 'full_lvl2_id',
            number: 1,
            instruction: 'Memory L2S1 Instruction'),
        level1ScreenIds = ['mc_s1_l1_full'],
        level2ScreenIds = ['mem_s1_l2_full'],
        // --- Define specific options here ---
        mcOptionCorrectL1S1 = mockOption(
            id: 'mc_opt_c_full',
            screenId: 'mc_s1_l1_full',
            isCorrect: true,
            labelText: 'Correct MC'),
        mcOptionIncorrectL1S1 = mockOption(
            id: 'mc_opt_i_full',
            screenId: 'mc_s1_l1_full',
            labelText: 'Incorrect MC'),
        memOptionA1L2S1 = mockOption(
            id: 'mem_opt_a1_full',
            screenId: 'mem_s1_l2_full',
            pairId: 'pairA_full',
            labelText: 'Mem Card A1'),
        memOptionA2L2S1 = mockOption(
            id: 'mem_opt_a2_full',
            screenId: 'mem_s1_l2_full',
            pairId: 'pairA_full',
            labelText: 'Mem Card A2'),
        memOptionB1L2S1 = mockOption(
            id: 'mem_opt_b1_full',
            screenId: 'mem_s1_l2_full',
            pairId: 'pairB_full',
            labelText: 'Mem Card B1'),
        memOptionB2L2S1 = mockOption(
            id: 'mem_opt_b2_full',
            screenId: 'mem_s1_l2_full',
            pairId: 'pairB_full',
            labelText: 'Mem Card B2') {
    // Populate ScreenWithOptionsMenu with the defined options
    mcScreenDataL1S1 = ScreenWithOptionsMenu(
      screen: mcScreenL1S1,
      options: [mcOptionCorrectL1S1, mcOptionIncorrectL1S1],
    );
    memScreenDataL2S1 = ScreenWithOptionsMenu(
      screen: memScreenL2S1,
      options: [
        memOptionA1L2S1,
        memOptionA2L2S1,
        memOptionB1L2S1,
        memOptionB2L2S1
      ],
    );
  }
}
