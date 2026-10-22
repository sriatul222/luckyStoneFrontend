# Lucky Stone

Flutter app for an online jewellery store (Malabar Gold / BlueStone / CaratLane style):
gold, diamond, silver and platinum jewellery with live metal-rate pricing.

Backend: `~/PythonProject/LuckyStoneBackend` (FastAPI + PostgreSQL). See its README for all APIs.

## Architecture

Copied from the Parivesh app (everything except `screens/`), with **bloc / cubit** for state.

```text
lib
├── api            # ApiHandler (dio) + urls.dart (all backend endpoints)
├── appTheme       # ThemeCubit, light / dark theme (plum + gold)
├── checkNetwork   # NetworkBloc (internet on/off)
├── extra          # colors, constants, validators, shared preferences, toast
├── routes         # fluro router: routes_name / routes_handlers / router
├── widgets        # shared widgets (app bar, loading, text fields, ...)
└── screens        # one folder per screen
    └── homeScreen
        ├── homeCubit   # home_cubit.dart + home_state.dart
        ├── homeModel   # home_model.dart (fromJson models)
        └── homeUi      # home_screen.dart (BlocProvider) + home_form.dart (UI)
```

Adding a new screen:

1. Create `screens/xyzScreen/{xyzCubit,xyzModel,xyzUi}`. Copy `homeScreen` as a template.
2. Call the API from the cubit with `ApiHandler.handler.getApi/postApi/putApi/deleteApi(AppURLs.xxx)`.
3. Add the route in `routes_name.dart`, `routes_handlers.dart` and `router.dart`.

After login, save the token with `AppPreferences.shared.saveLogin(token)`. ApiHandler then sends
`Authorization: Bearer <token>` automatically. A 401 response logs the user out.

## Run

The app talks only to the backend deployed on Render (https). The address is in
`lib/api/urls.dart`:

```dart
static const String appBaseURL = 'https://luckystonebackend.onrender.com/';
```

1. Deploy the backend to Render (see the backend README) and put its URL from the Render
   dashboard in `appBaseURL`.
2. `flutter pub get`
3. `flutter run` (or `flutter build apk --release`)

Works on the emulator, simulator and real phones on any network. A free Render service sleeps
after 15 minutes idle, so the first request afterwards can take up to a minute.

## Notes

- Firebase / push notifications from Parivesh were **not** copied: they were linked to the Parivesh
  Firebase project. Create a Lucky Stone Firebase project and run `flutterfire configure` when needed.
- Android package id is still `com.example.luckystone`. Change it before publishing.
- iOS minimum version is 15.0 (needed by Xcode 27).
