package com.pesaloan.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.pesaloan.app/deeplink"
    private val TAG = "PesaLoanMainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register platform channels
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLink" -> {
                    val link = intent?.data?.toString()
                    result.success(link)
                }
                "getAppVersion" -> {
                    result.success(BuildConfig.VERSION_NAME)
                }
                "getBuildNumber" -> {
                    result.success(BuildConfig.VERSION_CODE.toString())
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Handle deep link on cold start
        handleDeepLink(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleDeepLink(intent)
    }

    private fun handleDeepLink(intent: Intent?) {
        val uri = intent?.data
        if (uri != null) {
            Log.d(TAG, "Deep link received: $uri")
            // The Flutter engine will handle this via the platform channel
        }
    }

    companion object {
        const val DEEP_LINK_SCHEME = "pesaloan"
        const val DEEP_LINK_HOST_CALLBACK = "callback"
        const val DEEP_LINK_HOST_MPESA = "mpesa-callback"
    }
}