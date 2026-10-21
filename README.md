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

1. Start the backend: `cd ~/PythonProject/LuckyStoneBackend && source .venv/bin/activate && python main.py`
2. `flutter pub get`
3. `flutter run`
   - Android emulator uses `http://10.0.2.2:8000/` automatically
   - iOS simulator uses `http://127.0.0.1:8000/`

### Real phone

On a phone `127.0.0.1` is the phone itself, so the app must call your Mac's Wi-Fi IP. The phone and
the Mac must be on the same Wi-Fi.

1. Find the Mac's IP: `ipconfig getifaddr en0`
2. Put it in `config/dev.json` (copy `config/dev.example.json`; the file is git-ignored):
   `{ "API_BASE_URL": "http://<mac-ip>:8000/" }`
3. Run with it: `flutter run --dart-define-from-file=config/dev.json`
   (Android Studio: pick the **main.dart (real phone)** run configuration)
4. **Release builds on Android** only allow http to the hosts in
   `android/app/src/main/res/xml/network_security_config.xml`. Put the same IP there.
   Debug builds allow http to any host.
5. **iPhone**: tap **Allow** when asked to connect to devices on your local network
   (or Settings → Privacy & Security → Local Network → Lucky Stone).

When the Mac's IP changes, update steps 2 and 4.

### Backend on Render (any network)

When the backend is deployed to Render (see the backend README), the app uses its https URL from
`config/prod.json` (update it if Render gives your service a different address):

- Run: `flutter run --dart-define-from-file=config/prod.json`
  (Android Studio: **main.dart (Render server)** run configuration)
- Release APK: `flutter build apk --release --dart-define-from-file=config/prod.json`
- No Mac IP, VPN or http exceptions needed. A free Render service sleeps after 15 minutes idle,
  so the first request afterwards can take up to a minute.

## Notes

- Firebase / push notifications from Parivesh were **not** copied: they were linked to the Parivesh
  Firebase project. Create a Lucky Stone Firebase project and run `flutterfire configure` when needed.
- Android package id is still `com.example.luckystone`. Change it before publishing.
- iOS minimum version is 15.0 (needed by Xcode 27).
