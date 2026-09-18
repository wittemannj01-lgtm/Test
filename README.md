# ScaleSnap

Android app that reads a precision scale display through the phone camera and automatically records a 10-item weighing series.

## Workflow

1. Point the rear camera at the scale display and keep the digits inside the white guide.
2. Put package 1 on the scale.
3. ScaleSnap waits for five consistent OCR readings (default tolerance: 0.005 g), then stores the value.
4. Remove the package. The app waits until the scale is stably near zero (<= 0.100 g).
5. Put on the next package. Repeat until 10 measurements are stored.
6. The app shows every individual measurement and the running/final sum. The result can be shared as plain text/CSV-like rows.

A manual **Wert übernehmen** button is included as a fallback, but automatic capture is the default.

## Technical design

- **CameraX** for preview and frame analysis.
- **ML Kit Text Recognition v2 (bundled model)** for offline OCR.
- Center Region of Interest matching the on-screen guide.
- Grayscale/contrast preprocessing.
- Conservative weight parser with common OCR substitutions (`O -> 0`, `I/l -> 1`) and recovery when the decimal point is dropped.
- Five-sample stability filter.
- State machine prevents double counting: `WAITING_FOR_WEIGHT -> WAITING_FOR_CLEAR -> WAITING_FOR_WEIGHT`.
- Session is persisted locally with `SharedPreferences`, so accidental activity recreation does not wipe the current series.
- No network permission and no image upload. Camera frames are processed on-device and discarded.

## Requirements

- Android 6.0+ (API 23+)
- Rear camera
- Android Studio Quail 2026.1.4+ recommended
- JDK 17+
- Android SDK 36 / Build Tools 36.0.0
- Gradle 9.6.0 / Android Gradle Plugin 9.4.0

## Build

Open this folder in Android Studio, install SDK 36 if prompted, let Gradle sync, then choose **Run** on an Android device.

This archive contains `gradle-wrapper.properties`, but not the binary `gradle-wrapper.jar` because the build environment used to generate this project had no network-accessible Gradle distribution. Android Studio can use its configured Gradle installation or regenerate the wrapper with:

```bash
gradle wrapper --gradle-version 9.6.0
```

Then build:

```bash
./gradlew test
./gradlew assembleDebug
```

Debug APK output:

`app/build/outputs/apk/debug/app-debug.apk`

## Accuracy notes

This is a camera/OCR logger, not a calibrated metrology instrument. The accuracy of the recorded number cannot exceed the scale itself, and OCR can fail due to reflections, blur, low contrast, or unusual seven-segment fonts. Keep the display large in frame, clean, sharply focused, and evenly lit. Always validate the app against known readings before relying on it.

For a specific scale model, the two best reliability improvements are:

1. tighten the ROI to exactly the digit area; and
2. tune preprocessing/weight parsing to that display's exact format.

## Defaults to tune

- `ScaleOcrAnalyzer.OCR_INTERVAL_MS`: OCR cadence (currently 300 ms)
- `StabilityTracker(requiredSamples = 5, toleranceGrams = 0.005)` in `MainActivity`
- `MeasurementSession.minimumWeight`: 1.000 g
- `MeasurementSession.clearThreshold`: 0.100 g
- `WeightParser.maxGrams`: 300.000 g
- `GuideOverlayView`: ROI width 90%, height 30%

## Privacy

The app requests only camera access. It has no `INTERNET` permission. OCR runs locally with the bundled ML Kit model. Frames are not saved.

## APK ohne Android Studio bauen (GitHub Actions)

Das Repository enthält `.github/workflows/build-apk.yml`. Nach dem Hochladen zu GitHub startet der Build bei einem Push auf `main`/`master` automatisch; alternativ unter **Actions → Build Android APK → Run workflow**.

Nach erfolgreichem Lauf: **Actions → Build Android APK → letzter Lauf → Artifacts → ScaleSnap-debug-apk** herunterladen. Darin liegt `app-debug.apk`. Auf Android kann diese APK nach Freigabe von „Unbekannte Apps installieren“ installiert werden.

Der Cloud-Build führt zuerst die Unit-Tests aus und baut nur dann die APK.
