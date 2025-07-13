package com.konju.yurutasu

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MediumNativeAdFactory(private val context: Context) : NativeAdFactory {
    companion object {
        private const val TAG = "MediumNativeAdFactory"
    }
    
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        Log.d(TAG, "Creating native ad with Medium layout")
        
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.medium_native_ad_layout, null) as NativeAdView

        try {
            // 必須アセット（ヘッドライン）を設定
            val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
            headlineView.text = nativeAd.headline
            nativeAdView.headlineView = headlineView
            Log.d(TAG, "Headline set: ${nativeAd.headline}")

            // オプションアセットを設定
            nativeAd.body?.let { bodyText ->
                val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
                bodyView.text = bodyText
                bodyView.visibility = View.VISIBLE
                nativeAdView.bodyView = bodyView
                Log.d(TAG, "Body set: $bodyText")
            } ?: run {
                nativeAdView.findViewById<TextView>(R.id.ad_body)?.visibility = View.GONE
                Log.d(TAG, "Body not available")
            }

            nativeAd.callToAction?.let { ctaText ->
                val callToActionView = nativeAdView.findViewById<TextView>(R.id.ad_call_to_action)
                callToActionView.text = ctaText
                callToActionView.visibility = View.VISIBLE
                nativeAdView.callToActionView = callToActionView
                Log.d(TAG, "CTA set: $ctaText")
            } ?: run {
                nativeAdView.findViewById<TextView>(R.id.ad_call_to_action)?.visibility = View.GONE
                Log.d(TAG, "CTA not available")
            }

            nativeAd.icon?.let { iconImage ->
                val iconView = nativeAdView.findViewById<ImageView>(R.id.ad_icon)
                iconView.setImageDrawable(iconImage.drawable)
                iconView.visibility = View.VISIBLE
                nativeAdView.iconView = iconView
                Log.d(TAG, "Icon set")
            } ?: run {
                nativeAdView.findViewById<ImageView>(R.id.ad_icon)?.visibility = View.GONE
                Log.d(TAG, "Icon not available")
            }

            nativeAd.advertiser?.let { advertiserText ->
                val advertiserView = nativeAdView.findViewById<TextView>(R.id.ad_advertiser)
                advertiserView?.let { view ->
                    view.text = advertiserText
                    view.visibility = View.VISIBLE
                    nativeAdView.advertiserView = view
                    Log.d(TAG, "Advertiser set: $advertiserText")
                }
            } ?: run {
                nativeAdView.findViewById<TextView>(R.id.ad_advertiser)?.visibility = View.GONE
                Log.d(TAG, "Advertiser not available")
            }

            nativeAd.starRating?.let { rating ->
                val ratingBar = nativeAdView.findViewById<RatingBar>(R.id.ad_stars)
                ratingBar?.let { bar ->
                    bar.rating = rating.toFloat()
                    bar.visibility = View.VISIBLE
                    nativeAdView.starRatingView = bar
                    Log.d(TAG, "Star rating set: $rating")
                }
            } ?: run {
                nativeAdView.findViewById<RatingBar>(R.id.ad_stars)?.visibility = View.GONE
                Log.d(TAG, "Star rating not available")
            }

            // 最後にネイティブ広告オブジェクトを設定
            nativeAdView.setNativeAd(nativeAd)
            Log.d(TAG, "Medium native ad successfully created")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error creating medium native ad", e)
        }

        return nativeAdView
    }
}
