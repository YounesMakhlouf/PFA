import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class EmotionDetectionService {
  late final FaceDetector _faceDetector;

  EmotionDetectionService() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<String> detectEmotion(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      return 'No face detected';
    }

    final face = faces.first;
    final smileProb = face.smilingProbability ?? -1;
    final leftEyeOpenProb = face.leftEyeOpenProbability ?? -1;
    final rightEyeOpenProb = face.rightEyeOpenProbability ?? -1;

    print('Smile: $smileProb, Left Eye: $leftEyeOpenProb, Right Eye: $rightEyeOpenProb');

    return _mapEmotion(smileProb);
  }

  String _mapEmotion(double smileProb) {
    if (smileProb > 0.7) {
      return 'Joy';
    } else if (smileProb < 0.3 && smileProb >= 0) {
      return 'Neutral or Sad';
    } else {
      return 'Uncertain';
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}
