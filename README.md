# Receipt OCR – Real-Time Receipt Scanner (Flutter + ML Kit)

A privacy-first Flutter application that **scans supermarket / restaurant receipts** using **on-device OCR**, instantly extracts **structured data** (store name, purchase date, total amount, items) and lets you **share or copy** the JSON result.  
Everything runs **offline** – no third-party OCR APIs, no data leaves the phone.

--------------------------------------------------------
🔍  FEATURES
--------------------------------------------------------
- **Dual capture modes**
  - Live **camera preview** with adjustable guide overlay  
  - **Gallery picker** for already saved receipt photos  
- **Accurate Latin-script OCR** powered by **Google ML Kit** (Latin-only model → small, fast, private)  
- **Smart field parser** (regex + heuristics)
  - Store name (first non-numeric line)  
  - Purchase date (multiple formats → ISO-8601)  
  - Total amount (last “TOTAL / Grand Total / ብር” line)  
  - Items list (when present)  
- **Confidence score** per field (0-1) with colour-coded chips  
- **Editable JSON preview** – tap to copy or share via any app  
- **Embedded HTTP server** (Shelf) – mocks a backend for demo POST /receipts  
- **Dark Material 3** UI with haptic feedback & Lottie success animation  
- **ProGuard / R8** rules strip unused Asian script models → **12-15 MB APK**  
- **ARM64, ARMv7, x86_64** support (fat APK ≈ 45 MB)  

--------------------------------------------------------
📸  SCREEN FLOW
--------------------------------------------------------
1. **ScannerScreen** – live camera or gallery button inside overlay  
2. **DetailScreen** – parsed fields + raw JSON + share/copy actions  
3. **SendScreen** – POST to local server (127.0.0.1:8080) with success animation  

--------------------------------------------------------
🛠  TECH STACK
--------------------------------------------------------
| Layer | Package / Tool |
|-------|----------------|
| Language | Dart 3 |
| Framework | Flutter 3.19 |
| State | Riverpod 2.5 |
| OCR | google_mlkit_text_recognition (Latin) |
| Camera | camera 0.10.5+9 |
| Gallery | image_picker + permission_handler |
| Mock Backend | shelf + shelf_router |
| JSON | freezed + json_serialisable |
| UI | Material 3 dark theme, Lottie, haptic feedback |
| Build | ProGuard, R8, shrinkResources |

--------------------------------------------------------
📦  PROJECT STRUCTURE
--------------------------------------------------------
```
lib/
├── src/
│   ├── core/                 (constants, models, theme)
│   ├── features/
│   │   ├── scanner/          (camera, gallery, OCR service, parser)
│   │   ├── detail/           (JSON preview, share, copy)
│   │   ├── submit/           (POST to embedded server)
│   │   └── backend/          (Shelf mock server)
├── main.dart                 (routes, Riverpod scope)
android/
├── app/
│   ├── proguard-rules.pro    (keeps Latin model only)
│   └── build.gradle.kts      (compileSdk 36, NDK 27, R8 enabled)
```
--------------------------------------------------------
⚙️  BUILD & RUN
--------------------------------------------------------
### Debug (hot-reload)
```bash
flutter pub get
flutter run --release
```

### Release APK (ARM64 only – smallest)
```bash
flutter build apk --release --target-platform android-arm64
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Fat APK (all ABIs)
```bash
flutter build apk --release
```

--------------------------------------------------------
🔐  PRIVACY & SECURITY
--------------------------------------------------------
- **Zero network calls** for OCR – model runs on-device  
- **Optional** HTTPS POST only sends data you explicitly tap “Send” on  
- **Bearer token** auth header ready (configurable in `constants.dart`)  
- **Images ≤ 1 MB, 1600 px longest edge** – no full-res upload  

--------------------------------------------------------
🧪  TESTING
--------------------------------------------------------
- **Sample receipt images** in `test/golden/` with expected JSON  
- **Unit tests** for parser (store, date, total) – run:
```bash
flutter test
```

--------------------------------------------------------
📝  ROADMAP / IDEAS
--------------------------------------------------------
- Bounding-box overlay per field  
- Template learning per store chain  
- CSV / Excel export  
- Cloud backend with user accounts  
- iOS support (already compiles, just needs App Store signing)

--------------------------------------------------------
LICENSE
--------------------------------------------------------
MIT – feel free to fork, improve, or use in your own portfolio.

