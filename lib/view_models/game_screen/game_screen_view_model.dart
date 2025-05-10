import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/services/emotion_detection_service.dart';
import 'game_screen_state.dart';

class GameScreenViewModel extends StateNotifier<GameScreenState> {
  GameScreenViewModel() : super(GameScreenState(isCameraInitialized: false)) {
    _emotionService = EmotionDetectionService();
  }

  late final EmotionDetectionService _emotionService;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(frontCamera, ResolutionPreset.medium);
    await controller.initialize();

    state = state.copyWith(
      isCameraInitialized: true,
      cameraController: controller,
    );
  }

  Future<void> takePhoto() async {
    if (state.cameraController != null && state.cameraController!.value.isInitialized) {
      final image = await state.cameraController!.takePicture();
      print('Photo captured at: ${image.path}');

      final detectedEmotion = await _emotionService.detectEmotion(image.path);
      print('Detected Emotion: $detectedEmotion');

      // Optionally, update UI state with detected emotion
      state = state.copyWith(
        detectedEmotion: detectedEmotion,
      );

      // TODO: Save to DB, show in UI, or use in game logic
    }
  }

  @override
  void dispose() {
    state.cameraController?.dispose();
    _emotionService.dispose();
    super.dispose();
  }
}
