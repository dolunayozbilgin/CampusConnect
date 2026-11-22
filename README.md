# CampusConnect

CampusConnect is a Flutter mobile application that helps university students discover campus events and connect with people who share their interests. Students can browse, create and join events, see who is attending, and discuss events with other attendees — all in one place instead of scattered club pages and group chats.

Developed for **CS310 – Mobile Application Development**, Sabancı University.

## Group Details

**Group number:** 40

| Name | Student ID |
| --- | --- |
| Dolunay Özbilgin | 32691 |
| Senih Kırmaç | 32426 |
| Emre Aksoy | 31977 |
| Alp Gül | 32452 |
| Karya Sert | 34317 |

## Tech Stack

- Flutter (Dart)
- Firebase Authentication, Cloud Firestore, Firebase Storage

## Running the App

**Flutter version:** 3.47.7 (stable channel, Dart 3.13.5)

1. Install Flutter 3.47.7 and check the setup with `flutter doctor`.
2. Clone the repository and open the project folder:
   ```bash
   git clone https://github.com/dolunayozbilgin/campusconnect.git
   cd campusconnect
   ```
3. Get the packages:
   ```bash
   flutter pub get
   ```
4. Start an Android emulator or iOS simulator, then run:
   ```bash
   flutter run
   ```

To run the widget tests:
```bash
flutter test
```

Login and sign up are UI-only in this step: any valid-looking input opens the event feed. All data is placeholder data until Firebase is added in Step 3.
