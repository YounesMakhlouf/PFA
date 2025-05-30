enum Emotion {
  joy,
  sad,
  angry,
  surprised,
  neutral,
  uncertain,
}

extension EmotionExtension on Emotion {
  String get code {
    switch (this) {
      case Emotion.joy:
        return 'joy';
      case Emotion.sad:
        return 'sad';
      case Emotion.angry:
        return 'angry';
      case Emotion.surprised:
        return 'surprised';
      case Emotion.neutral:
        return 'neutral';
      case Emotion.uncertain:
        return 'uncertain';
    }
  }

  static Emotion fromCode(String? code) {
    switch (code) {
      case 'joy':
        return Emotion.joy;
      case 'sad':
        return Emotion.sad;
      case 'angry':
        return Emotion.angry;
      case 'surprised':
        return Emotion.surprised;
      case 'neutral':
        return Emotion.neutral;
      case 'uncertain':
      default:
        return Emotion.uncertain;
    }
  }
}
