# SDG MoneyMate Flutter (scaffold)

This repo is a minimal Flutter scaffold for the SDG MoneyMate frontend. It uses:

- Riverpod for state management
- Dio for network

<!-- # SDG MoneyMate — Flutter scaffold -->

A lightweight Flutter frontend scaffold for the SDG MoneyMate backend. It demonstrates
a Clean Architecture layout with Riverpod state management and a small network layer
(Dio) wired to the backend's JWT-based auth and AI endpoints.

## Features

- Riverpod for state management
- Dio for HTTP client and an interceptor to refresh tokens
- flutter_secure_storage for storing tokens securely

## Quick start

1. Install the Flutter SDK: [Flutter install docs](https://flutter.dev/docs/get-started/install)

1. Fetch dependencies:

```bash
flutter pub get
```

1. Run static analysis:

```bash
flutter analyze
```

1. Launch the app (connect a device or emulator):

```bash
flutter run
```

## Run tests

```bash
flutter test
```

## Configuration

### Backend base URL

The ApiClient default base URL is `http://localhost:8000`. To change it, edit
`lib/core/network/api_client.dart` or provide a different `baseUrl` where the
`ApiClient` provider is created.

### Authentication

This scaffold expects the backend to expose JWT endpoints:

- `POST /api/token/` (returns `access` and optionally `refresh`)
- `POST /api/token/refresh/` (body `{ "refresh": "..." }`)

The app stores tokens with `flutter_secure_storage` and uses an interceptor to
refresh the access token on 401 responses.

## Project layout (important files)

- `lib/main.dart` — app entry, routes, ProviderScope
- `lib/core/network/api_client.dart` — Dio wrapper and interceptor
- `lib/core/token_storage.dart` — secure token storage
- `lib/core/auth_gate.dart` — route guard based on auth state
- `lib/features/auth/` — auth notifier, data source, repository and login UI
- `lib/features/budget/` — budget data source, repository and UI
- `lib/features/chat/` — chat data source, repository and UI

## Development notes

- Auth flow: `AuthNotifier` is a Riverpod StateNotifier that handles login,
 logout, and token refresh. After login, the access token is attached to the
 ApiClient Authorization header.

- Repositories: budget and chat features are wired through repository
 interfaces and Riverpod providers for easier testing and separation of
 concerns.

- Tests: the `test/` folder contains basic tests for the auth notifier and the
 budgets provider. Tests override providers to avoid touching real storage or
 network.

## Contributing

Fork and submit PRs to expand features (onboarding, expenses, advisor). When
adding API usage, add a data source + repository + provider and corresponding
unit tests.

## Troubleshooting

- If you see network errors, ensure the backend is running and reachable from
 your device (Android emulators may need `10.0.2.2` to reach host `localhost`).
- If secure storage calls cause issues during testing, use provider overrides as
 shown in the tests.

## License & notes

This is a scaffold to support frontend development against the SDG-MoneyMate
backend; adapt and extend as needed.

- If secure storage calls cause issues in tests, use provider overrides as the

## Run on a phone or emulator

1. List devices recognized by Flutter:

```bash
flutter devices
```

1. Example output on this machine (your output may differ):

```text
Found 3 connected devices:
CPH2473 (mobile) • 79124759 • android-arm64  • Android 14 (API 34)
Linux (desktop)  • linux    • linux-x64      • Pop!_OS 22.04 LTS
6.12.10-76061203-generic
Chrome (web)     • chrome   • web-javascript • Google Chrome 140.0.7339.127

Run "flutter emulators" to list and start any available device emulators.
```

1. Run the app on a specific device (replace `<deviceId>` with id from `flutter devices`):

```bash
flutter run -d <deviceId>
```

1. Build and install an APK instead:

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

Notes:

- For Android emulators use `10.0.2.2` to reach a backend running on your host `localhost`.
- On Linux, if a physical device is not detected, you may need udev rules for your vendor id.

### Linux: udev rules & adb tips

If your Android device is not detected on Linux, add a udev rule for the vendor id and restart udev:

1. Find your device vendor id from `lsusb` (example output shows vendor:product):

```bash
lsusb
# Bus 001 Device 005: ID 18d1:4ee7 Google Inc.
```

1. Create a udev rule file `/etc/udev/rules.d/51-android.rules` with contents (replace `0x18d1` with your vendor id):

```text
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
```

1. Reload rules and replug the device:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

1. Restart adb server and check devices:

```bash
adb kill-server
adb start-server
adb devices
```

If `adb devices` shows `unauthorized`, accept the prompt on your phone.
