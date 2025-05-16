import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class InAppCameraWidget extends StatefulWidget {
  const InAppCameraWidget({super.key});

  @override
  State<InAppCameraWidget> createState() => _InAppCameraWidgetState();
}

class _InAppCameraWidgetState extends State<InAppCameraWidget> {
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _controller = CameraController(frontCamera, ResolutionPreset.medium);

    await _controller.initialize();
    if (!mounted) return;

    setState(() => _isCameraInitialized = true);
  }

  Future<void> _takePhoto() async {
    final image = await _controller.takePicture();
    // Handle image (save it, send it, analyze it, etc.)
    debugPrint('Photo saved at: ${image.path}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
        ElevatedButton(
          onPressed: _takePhoto,
          child: const Text("Capture Emotion Photo"),
        ),
      ],
    );
  }
}
