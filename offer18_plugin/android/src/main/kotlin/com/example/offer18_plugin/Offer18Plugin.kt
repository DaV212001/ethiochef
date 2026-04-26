package com.example.offer18_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.offer18.sdk.Offer18

class Offer18Plugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private var context: Context? = null  // Use nullable context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "offer18_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initSDK" -> {
        val domain = call.argument<String>("domain")
        val accountId = call.argument<String>("accountId")
        val tidKey = call.argument<String>("tidKey")
        if (domain != null && accountId != null && tidKey != null && context != null) {
          Offer18.init(context!!, domain, accountId, tidKey)
          Log.d("Offer18Plugin", "Initialized SDK with domain: $domain, accountId: $accountId, tidKey: $tidKey")
          result.success(null)
        } else {
          result.error("ARGUMENT_ERROR", "Missing domain, accountId, or tidKey argument", null)
        }
      }
      "getReferrerInstallUrl" -> {
          var url = Offer18.getAppInstallReferrerURL()
        Log.d("Offer18Plugin", "Got referrer url: $url")
        if(url == null){
          result.error("ARGUMENT_ERROR", "Missing referrer url", null)
        } else {
          result.success(url)
        }
      }
      "trackConversion" -> {
        val args = call.argument<Map<String, String>>("args")
        if (args != null && context != null) {
          try{
          Offer18.trackConversion(args)
          } catch (e: Exception){
            result.error("Offer18Plugin", "Something Went Wrong", null)
          }
          Log.d("Offer18Plugin", "Tracked conversion with args: $args")
          result.success(null)
        } else {
          result.error("ARGUMENT_ERROR", "Missing args argument", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null  // Clear context when detached
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    context = binding.activity
  }

  override fun onDetachedFromActivity() {
    context = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    context = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    context = null
  }
}
