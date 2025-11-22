# SDG MoneyMate Flutter (scaffold)

This repo is a minimal Flutter scaffold for the SDG MoneyMate frontend. It uses:
- Riverpod for state management
- Dio for network
 # SDG MoneyMate — Flutter scaffold

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
