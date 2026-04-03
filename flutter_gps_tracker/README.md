# Flutter GPS Tracker (Android + iOS)

This project provides a production-style starter for a cross-platform Flutter GPS tracker.

## Features

- Live GPS tracking with start/stop controls
- Real-time polyline route drawing
- Distance and elapsed-time stats
- OpenStreetMap tile rendering (no Google Maps key required)
- Android and iOS location permission configuration

## How to run

1. Install Flutter (stable channel).
2. From `flutter_gps_tracker`, run:
   ```bash
   flutter pub get
   flutter run
   ```

## Platform setup notes

### Android

- Permissions are included in `android/app/src/main/AndroidManifest.xml`.
- On Android 10+, background location permission requires a user prompt and Play Store policy compliance.

### iOS

- Usage descriptions are included in `ios/Runner/Info.plist`.
- For background updates, enable the **Location updates** capability in Xcode under Signing & Capabilities.

## Next improvements

- Persist tracks to local database (SQLite/Hive)
- Export GPX/CSV files
- Background service with notifications
- Battery optimization controls
