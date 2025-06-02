# pfa - Autism Learning App

**Version: 1.0.0**

## Description

An educational Flutter application designed for children, particularly those with autism, featuring
interactive games, progress tracking, and customizable settings to support learning and development.

## Features

- **User Authentication**: Supabase-backed sign-up, sign-in, and sign-out.
- **Child Profile Management**: Creation, selection, and management of child profiles, including
  associating special conditions (e.g., Autism, ADHD, Dyslexia).
- **Educator Linking**: Functionality for educators/parents to link their accounts to children's
  profiles for monitoring and content management.
- **Game Discovery**: Browsing and selecting games, categorized for ease of access (e.g., Logical
  Thinking, Education, Emotions, Animals).
- **Gameplay Engine**:
    - Supports multiple game types (Multiple Choice, Memory games confirmed).
    - Level and screen-based game structure for progressive learning.
    - Interactive answer validation and immediate feedback (visual and auditory).
    - Emotion detection capabilities for specific game interactions, allowing children to learn
      about emotions.
- **Progress Tracking**: Detailed recording of game sessions (start/end times, completion) and
  individual screen attempts (correctness, time taken).
- **Statistics Display**: Visualization of child performance data to track learning progress.
- **Application Settings**: Customizable options for:
    - App language (English, Arabic, French).
    - Text-to-Speech (TTS) voice and speech rate.
    - Sound effects.
    - Haptic feedback.
- **Localization**: Multi-language support throughout the application interface.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Ensure you have Flutter installed on your system. For installation instructions, see
  the [official Flutter documentation](https://docs.flutter.dev/get-started/install).
- A Supabase backend is required for full functionality. You will need to set up your own Supabase
  project and populate the necessary environment variables.

### Installation & Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your_username/pfa.git
   cd pfa
   ```
2. **Set up environment variables:**
   Create a `.env` file in the root of the project with your Supabase URL and Anon Key:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```
   Replace `your_supabase_url` and `your_supabase_anon_key` with your actual Supabase project
   details.
3. **Install dependencies:**
   ```sh
   flutter pub get
   ```
4. **Run the application:**
   ```sh
   flutter run
   ```

## Folder Structure

A brief overview of the main directories:

**`lib/`**: Contains all the Dart code for the application.

- `main.dart`: The entry point of the application. Initializes services and sets up the root widget.
- `models/`: Defines the data structures and domain objects (e.g., `User`, `Game`, `Child`).
- `services/`: Contains business logic, utility functions, and interactions with external services
  like Supabase, TTS, audio.
- `repositories/`: Acts as a data abstraction layer, mediating between services/viewmodels and data
  sources (e.g., Supabase database).
- `providers/`: Holds Riverpod providers for state management, dependency injection, and managing
  global application state (e.g., active child, settings).
- `screens/`: UI widgets representing different views/pages of the application (e.g., `HomeScreen`,
  `GameScreenWidget`, `SettingsScreen`).
- `widgets/`: Reusable UI components used across multiple screens (e.g., `CategoryCardWidget`,
  `AvatarDisplay`).
- `games/`: Contains higher-level widgets that orchestrate specific game types, often consuming
  ViewModels (e.g., `MultipleChoiceGame`).
- `viewmodels/`: Manages UI state and logic for complex views, particularly for gameplay (
  `GameViewModel`).
- `config/`: Application-wide configurations like themes (`app_theme.dart`) and navigation routes (
  `routes.dart`).
- `l10n/`: Localization files for different languages.
- **`assets/`**: Contains static assets used by the application, such as images (`assets/images/`),
  audio files (`assets/audio/`), and Lottie animations (`assets/animations/`).
- **`docs/`**: Includes project documentation, such as the Entity Relationship Diagram (
  `entity_diagram.puml`).
- **`test/`**: Contains unit and widget tests for the application.

## Contributing

Contributions are welcome! Please follow the standard GitHub flow:

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is currently not licensed. All rights reserved.