# 🌌 Skyfall Defender

**Skyfall Defender** is a cross-platform 2D arcade-style shooter game developed using Flutter and the Flame game engine. Defend the skies by moving left and right to shoot down falling enemies! Featuring responsive controls, dynamic audio, and optimized performance for mobile, web, and desktop.

---

## 🎯 Features

- 🎮 Smooth and responsive player controls
- 🔫 Shooting mechanics with bullet cooldown
- 👾 Dynamic enemy spawning
- 🎵 Game sound effects and background music
- ⏸️ Pause and resume functionality
- 🧠 State management using GetX
- 🌐 Universal platform support (Android, iOS, Web, Windows, macOS, Linux)

---

## 🚀 Tech Stack

| Technology      | Description                         |
| --------------- | ----------------------------------- |
| Flutter         | Cross-platform UI toolkit           |
| Flame           | Game engine for Flutter             |
| GetX            | State management and logic handling |
| audioplayers    | Sound playback for SFX and BGM      |
| universal_html  | Platform detection on web           |

---

## 🛠️ Getting Started

### ✅ Prerequisites

- Flutter SDK (latest stable)
- Git (optional)
- IDE (Android Studio / VS Code / IntelliJ)

### 🔧 Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ThiruvidhiRevanth/Skyfall_Defender.git
   cd Skyfall_Defender
   ```

2. **Get the dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**

   - **Android/iOS:**
     ```bash
     flutter run
     ```
   - **Web:**
     ```bash
     flutter run -d chrome
     ```
   - **Desktop (Windows/macOS/Linux):**
     ```bash
     flutter run -d windows  # Replace with 'macos' or 'linux' if needed
     ```

---

## 🎮 Gameplay Controls

| Action        | Mobile            | Keyboard        |
| ------------- | ----------------- | --------------- |
| Move Left     | On-screen button  | Left Arrow key  |
| Move Right    | On-screen button  | Right Arrow key |
| Shoot         | Tap fire button   | Spacebar        |
| Pause/Resume  | Pause icon tap    | A key           |

---

## 🔊 Audio Guide

Ensure the following files exist under `assets/audio/` and are referenced in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/audio/background.mp3
    - assets/audio/move.wav
    - assets/audio/bullet.mp3
```


---

## 📁 Directory Structure

```
Skyfall_Defender/
├── lib/
│   ├── main.dart
│   ├── block_game.dart
│   ├── game_controller.dart
│   ├── bullet.dart
│   └── enemy.dart
├── assets/
│   ├── audio/
│   │   ├── background.mp3
│   │   ├── move.wav
│   │   └── bullet.mp3
│   └── images/
│       ├── appicon.png
│       ├── background.png
│       ├── block.png
│       ├── player.png
│       └── splash_screen.png
├── pubspec.yaml
└── README.md
```

---

## 🌍 Supported Platforms

| Platform | Supported | Notes                        |
| -------- | --------- | --------------------------- |
| Android  | ✅        | Fully functional            |
| iOS      | ✅        | Fully functional            |
| Web      | ✅        | Sound starts after interaction |
| Windows  | ✅        | Fully functional            |
| macOS    | ✅        | Fully functional            |
| Linux    | ✅        | Fully functional            |





---

## 📃 License

This project is licensed under the MIT License.

---

## 🙌 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Flame Engine](https://flame-engine.org/)
- [GetX Package](https://pub.dev/packages/get)
- [audioplayers Package](https://pub.dev/packages/audioplayers)

---

_Ready to play? Clone, build, and blast away!_
