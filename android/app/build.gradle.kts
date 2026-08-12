// File: android/app/build.gradle.kts
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties safely
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("Warning: key.properties file not found at ${keystorePropertiesFile.absolutePath}")
}

android {
    namespace = "com.cadyhakim.numynd"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.cadyhakim.numynd"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            // Safe null handling
            keyAlias = keystoreProperties["keyAlias"]?.toString() ?: ""
            keyPassword = keystoreProperties["keyPassword"]?.toString() ?: ""
            storePassword = keystoreProperties["storePassword"]?.toString() ?: ""

            val storeFileStr = keystoreProperties["storeFile"]?.toString()
            storeFile = if (!storeFileStr.isNullOrBlank()) {
                file(storeFileStr)
            } else {
                null
            }
        }

        getByName("debug") {
            // Default debug signing
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.android.material:material:1.4.0")
    implementation("androidx.appcompat:appcompat:1.3.0")
}