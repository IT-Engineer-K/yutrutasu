package com.example.yurutasu

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_layout, null) as NativeAdView

        // 必須アセットを設定（ヘッドラインは必須）
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
            val ctaView = nativeAdView.findViewById<TextView>(R.id.ad_call_to_action)
            ctaView.text = ctaText
            ctaView.visibility = View.VISIBLE
            nativeAdView.callToActionView = ctaView
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

        nativeAd.advertiser?.let { advertiserText ->
            val advertiserView = nativeAdView.findViewById<TextView>(R.id.ad_advertiser)
            advertiserView.text = advertiserText
            advertiserView.visibility = View.VISIBLE
            nativeAdView.advertiserView = advertiserView
        } ?: run {
            nativeAdView.findViewById<TextView>(R.id.ad_advertiser)?.visibility = View.GONE
        }

        nativeAd.starRating?.let { rating ->
            val ratingBar = nativeAdView.findViewById<RatingBar>(R.id.ad_stars)
            ratingBar.rating = rating.toFloat()
            ratingBar.visibility = View.VISIBLE
            nativeAdView.starRatingView = ratingBar
        } ?: run {
            nativeAdView.findViewById<RatingBar>(R.id.ad_stars)?.visibility = View.GONE
        }

        // 最後にネイティブ広告オブジェクトを設定
        nativeAdView.setNativeAd(nativeAd)

        return nativeAdView
    }
}
