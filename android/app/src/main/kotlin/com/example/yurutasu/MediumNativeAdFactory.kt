package com.example.yurutasu

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MediumNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.medium_native_ad_layout, null) as NativeAdView

        // 必須アセット（ヘッドライン）を設定
        val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        headlineView.text = nativeAd.headline
        nativeAdView.headlineView = headlineView

        // オプションアセットを設定
        nativeAd.body?.let { bodyText ->
            val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
            bodyView.text = bodyText
            bodyView.visibility = View.VISIBLE
            nativeAdView.bodyView = bodyView
        } ?: run {
            nativeAdView.findViewById<TextView>(R.id.ad_body)?.visibility = View.GONE
        }

        nativeAd.callToAction?.let { ctaText ->
            val callToActionView = nativeAdView.findViewById<TextView>(R.id.ad_call_to_action)
            callToActionView.text = ctaText
            callToActionView.visibility = View.VISIBLE
            nativeAdView.callToActionView = callToActionView
        } ?: run {
            nativeAdView.findViewById<TextView>(R.id.ad_call_to_action)?.visibility = View.GONE
        }

        nativeAd.icon?.let { iconImage ->
            val iconView = nativeAdView.findViewById<ImageView>(R.id.ad_icon)
            iconView.setImageDrawable(iconImage.drawable)
            iconView.visibility = View.VISIBLE
            nativeAdView.iconView = iconView
        } ?: run {
            nativeAdView.findViewById<ImageView>(R.id.ad_icon)?.visibility = View.GONE
        }

        // 最後にネイティブ広告オブジェクトを設定
        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}
