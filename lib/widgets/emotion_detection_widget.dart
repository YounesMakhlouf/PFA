import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/viewmodels/game_state.dart';
import 'package:pfa/viewmodels/game_viewmodel.dart';
import 'package:pfa/providers/global_providers.dart';

class EmotionDetectionWidget extends ConsumerWidget {
  final String gameId;
  final Option currentOption;

  const EmotionDetectionWidget({
    super.key,
    required this.gameId,
    required this.currentOption,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameViewModel = ref.watch(gameViewModelProvider(gameId).notifier);
    final cameraController = gameViewModel.cameraController;
    final GameState state = ref.watch(gameViewModelProvider(gameId));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Option image (emotion to imitate)

        // Camera preview
        AspectRatio(
          aspectRatio: 1,
          child: state.isCameraInitialized && cameraController != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(cameraController),
                )
              : const Center(child: CircularProgressIndicator()),
        ),

        const SizedBox(height: 16),

        // Detected emotion label
        Text(
          state.detectedEmotion ?? "Detecting emotion...",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
