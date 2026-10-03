# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# Keep all generated code
-keep class io.flutter.plugins.** { *; }

# Keep annotations
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# Dio / Network
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }

# Freezed / JSON serialization
-keep class *$$Freezed { *; }
-keep class *$$FreezedBuilder { *; }
-keep class *$$FreezedCopyWith { *; }
-keep class *$$FreezedEqual { *; }
-keep class *$$FreezedHashCode { *; }
-keep class *$$FreezedToString { *; }
-keep class *$$FreezedImpl { *; }

# Riverpod
-keep class io.flutter.plugins.riverpod.** { *; }
-keep class com.riverpod.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Dio
-keep class dio.** { *; }

# PointyCastle (crypto)
-keep class org.bouncycastle.** { *; }

# Keep our models
-keep class com.pesaloan.app.** { *; }
-keep class com.pesaloan.** { *; }

# Prevent obfuscation of JSON field names
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName *;
}

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Reactive forms
-keep class io.flutter.plugins.reactive_forms.** { *; }

# Local auth
-keep class io.flutter.plugins.local_auth.** { *; }

# Secure storage
-keep class io.flutter.plugins.flutter_secure_storage.** { *; }

# Hive
-keep class com.pesaloan.app.data.** { *; }
-keep class com.pesaloan.app.domain.** { *; }

# Permissions
-keep class io.flutter.plugins.permission_handler.** { *; }

# Device info
-keep class io.flutter.plugins.device_info.** { *; }

# Package info
-keep class io.flutter.plugins.package_info.** { *; }

# Connectivity
-keep class io.flutter.plugins.connectivity.** { *; }

# URL launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Pin code fields
-keep class com.pin_code_fields.** { *; }

# Shimmer
-keep class io.flutter.plugins.shimmer.** { *; }

# Cached network image
-keep class io.flutter.plugins.cached_network_image.** { *; }

# Flutter SVG
-keep class io.flutter.plugins.flutter_svg.** { *; }

# Logger
-keep class logger.** { *; }