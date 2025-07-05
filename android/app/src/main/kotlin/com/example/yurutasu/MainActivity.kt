package com.example.yurutasu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Note: Native ad factories are temporarily disabled for development
        // Uncomment when ready to implement native ads:
        
        // GoogleMobileAdsPlugin.registerNativeAdFactory(
        //     flutterEngine, 
        //     "listTile", 
        //     com.example.yurutasu.NativeAdFactoryExample(this)
        // )
        
        // GoogleMobileAdsPlugin.registerNativeAdFactory(
        //     flutterEngine, 
        //     "medium", 
        //     com.example.yurutasu.MediumNativeAdFactory(this)
        // )
    }
    
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // Corresponding cleanup for native ads (currently disabled)
        // GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        // GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "medium")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
