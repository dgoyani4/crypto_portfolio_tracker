
# Crypto Portfolio Tracker

This is a Flutter application for tracking your cryptocurrency portfolio.

---

## App Setup Steps

1. **Clone the repository:**
	```sh
	git clone https://github.com/dgoyani4/crypto_portfolio_tracker.git
	cd crypto_portfolio_tracker
	```
2. **Install dependencies:**
	```sh
	flutter pub get
	```
3. **(Optional) Set up your IDE:**
	- Open the project in VS Code, Android Studio, or your preferred editor.
4. **Run the app:**
	- For Android:
	  ```sh
	  flutter run
	  ```
	- For release build:
	  ```sh
	  flutter build apk --release
	  ```

---

## How to Run the Application

1. Make sure you have Flutter installed. See [Flutter installation guide](https://docs.flutter.dev/get-started/install).
2. Connect a device or start an emulator.
3. Run:
	```sh
	flutter run
	```

---

## Demo Video

Watch a recorded demo of the app here:

[Crypto Portfolio Tracker Demo (Google Drive)](https://drive.google.com/file/d/1SG_VoMjEcuBLOfRa6jqxAqIBr8nYNsW4/view?usp=sharing)

---

## Architectural Choices

- **State Management:** Uses the [BLoC pattern](https://bloclibrary.dev/#/) for predictable state management and separation of concerns.
- **Data Layer:** Repository pattern for API and database access.
- **Persistence:** Uses SQLite (via `sqflite`) for local portfolio storage.
- **UI:** Follows Flutter best practices with custom widgets and modular screens.

---

## Third-party Libraries Used

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
- [sqflite](https://pub.dev/packages/sqflite) - SQLite database
- [dio](https://pub.dev/packages/dio) - HTTP client
- [intl](https://pub.dev/packages/intl) - Internationalization and currency formatting

---
