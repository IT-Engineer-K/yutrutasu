package com.example.yurutasu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // ネイティブ広告のファクトリーを登録（一時的にコメントアウト）
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
        // GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        // GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "medium")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
