##############################################
# Flutter + ML Kit ProGuard Rules
##############################################

# --- ML Kit: Keep Latin only, ignore others ---
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep core ML Kit recognizer and Latin model
-keep class com.google.mlkit.vision.text.TextRecognizer { *; }
-keep class com.google.mlkit.vision.text.latin.** { *; }

# --- General ML Kit keep rules ---
-keep class com.google.mlkit.common.** { *; }
-dontwarn com.google.mlkit.common.**

# --- Flutter & Dart generated code ---
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# --- AndroidX Lifecycle (used by plugins like camera) ---
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**

# --- Gson/JSON (used by some plugins) ---
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
