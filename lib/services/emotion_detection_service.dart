import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:pfa/models/emotions_enum.dart';

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

Future<Emotion> detectEmotion(String imagePath) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  final faces = await _faceDetector.processImage(inputImage);

  if (faces.isEmpty) {
    return Emotion.uncertain;
  }

  final face = faces.first;
  final smileProb = face.smilingProbability ?? -1;
  final headEulerAngleY = face.headEulerAngleY ?? 0;
  final headEulerAngleZ = face.headEulerAngleZ ?? 0;

  return _mapEmotion(smileProb, headEulerAngleY, headEulerAngleZ);
}

Emotion _mapEmotion(double smileProb, double angleY, double angleZ) {
  if (smileProb > 0.7) {
    return Emotion.joy;
  } else if (smileProb < 0.3 && smileProb >= 0) {
    return Emotion.sad;
  } else if (angleZ.abs() > 20) {
    return Emotion.surprised;
  } else if (angleY.abs() > 30) {
    return Emotion.angry;
  } else if (smileProb >= 0.3 && smileProb <= 0.7) {
    return Emotion.neutral;
  } else {
    return Emotion.uncertain;
  }
}


  void dispose() {
    _faceDetector.close();
  }
}
