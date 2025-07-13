package com.konju.yurutasu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // ネイティブ広告ファクトリーを登録
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, 
            "listTile", 
            com.konju.yurutasu.NativeAdFactoryExample(this)
        )
        
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, 
            "medium", 
            com.konju.yurutasu.MediumNativeAdFactory(this)
        )
    }
    
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // ネイティブ広告ファクトリーの登録を解除
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "medium")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
