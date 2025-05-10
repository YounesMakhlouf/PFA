import 'package:camera/camera.dart';

class GameScreenState {
  final bool isCameraInitialized;
  final CameraController? cameraController;
  final String? detectedEmotion;

  GameScreenState({
    required this.isCameraInitialized,
    this.cameraController,
    this.detectedEmotion,
  });

  GameScreenState copyWith({
    bool? isCameraInitialized,
    CameraController? cameraController,
    String? detectedEmotion,
  }) {
    return GameScreenState(
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      cameraController: cameraController ?? this.cameraController,
      detectedEmotion: detectedEmotion ?? this.detectedEmotion,
    );
  }
}
