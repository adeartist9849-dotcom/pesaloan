# PesaLoan — Google Play Console Assets

Files in this folder are ready to upload to Play Console.

## Store listing assets

| File | Size | Where it goes |
|------|------|---------------|
| `icon-512.png` | 512×512, full-bleed | Play Console → Main store listing → App icon |
| `feature-graphic-1024x500.png` | 1024×500 | Play Console → Main store listing → Feature graphic |

Both are generated from `pesaloan-app-icon.svg` in the project root, so they match
the in-app launcher icon exactly.

## Build artifacts

- **App Bundle (required for new apps):** `apps/mobile/build/app/outputs/bundle/release/app-release.aab`
  Upload this to Play Console → Production → Create new release.
- **APK (for sideloading/testing):** `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`

Play Console requires an **AAB** for new app submissions; the APK is for direct installs
and internal testing outside Play.

## Build configuration

- `applicationId`: `com.pesaloan.app`
- `versionName` / `versionCode`: `1.0.0` / `1` (increment `versionCode` for every upload)
- `minSdk` 24 (Android 7.0), `targetSdk` 36 (meets current Play target API requirement)
- Release signing: `android/keystore.properties` + `android/app/pesaloan-release.keystore`
  — **back up the keystore and its password**. Losing them means you can never update
  the published app with the same key (you would have to contact Play support for a
  key reset).

Keystore details are in `android/keystore.properties`:
- store: `android/app/pesaloan-release.keystore`
- alias: `pesaloan-release-key`
- store/key password: `PesaLoan#2026!Upload`

Both `keystore.properties` and `*.keystore` are git-ignored.

## Before you submit — checklist

1. **Screenshots required:** Play needs at least 2 phone screenshots (1080×1920 or
   similar 16:9/portrait). Capture them from a running device or emulator
   (`flutter run`, then capture the screen) — they are not generated from source.
2. **Real backend URL:** `apps/mobile/.env` currently points `API_BASE_URL` at
   `http://10.0.2.2:3000/api/v1` (Android emulator loopback). Set it to your real
   HTTPS API before the release build or the published app will not reach a server.
   Rebuild after changing it.
3. **Firebase:** `android/app/google-services.json` is a placeholder with fake keys.
   Replace it with the real file from your Firebase project (and matching
   `lib/firebase_options.dart`) for push notifications and Crashlytics to work.
4. **Data safety form:** in Play Console, declare the data the app collects
   (identity, financial info, device identifiers, documents) to match the in-app
   Privacy Policy.
5. **Financial-app declarations:** Kenya digital-lending apps are subject to Play's
   financial-services policy — be prepared to supply your CBK licence/registration
   details and the lending/repayment terms during the app declaration questionnaire.
6. **Content rating:** complete the IARC questionnaire in Play Console.
7. **Privacy policy URL:** `https://pesaloan.co.ke/privacy` (already referenced in the
   app) — must be live before submission.
