package com.mayrlabs.mayr_local_notifications

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicInteger

/** MayrLocalNotificationsPlugin */
class MayrLocalNotificationsPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {
    
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var notificationManager: NotificationManagerCompat
    private var channelId: String = "mayr_default_channel"
    private var channelName: String = "MayR Notifications"
    private var channelDescription: String = "Default notification channel"
    private var debugLogs: Boolean = false
    private val notificationIdCounter = AtomicInteger(0)
    private var activity: Activity? = null
    private var permissionResult: Result? = null

    companion object {
        private const val TAG = "MayrLocalNotifications"
        private const val PERMISSION_REQUEST_CODE = 8472
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mayr_local_notifications")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        notificationManager = NotificationManagerCompat.from(context)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "init" -> {
                handleInit(call, result)
            }
            "send" -> {
                handleSend(call, result)
            }
            "schedule" -> {
                handleSchedule(call, result)
            }
            "cancelAll" -> {
                handleCancelAll(result)
            }
            "requestPermission" -> {
                handleRequestPermission(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleInit(call: MethodCall, result: Result) {
        try {
            channelId = call.argument<String>("channelId") ?: "mayr_default_channel"
            channelName = call.argument<String>("channelName") ?: "MayR Notifications"
            channelDescription = call.argument<String>("channelDescription") ?: "Default notification channel"
            debugLogs = call.argument<Boolean>("enableDebugLogs") ?: false
            val requestPermissions = call.argument<Boolean>("requestPermissions") ?: true

            log("Initializing with channelId: $channelId, channelName: $channelName")

            // Create notification channel for Android 8.0+
            createNotificationChannel()

            // Check and request permissions for Android 13+
            if (requestPermissions && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (ContextCompat.checkSelfPermission(
                        context,
                        android.Manifest.permission.POST_NOTIFICATIONS
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    log("POST_NOTIFICATIONS permission not granted. App should request it.")
                }
            }

            result.success(null)
        } catch (e: Exception) {
            log("Error during init: ${e.message}")
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = channelDescription
            }
            
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
            log("Notification channel created: $channelId")
        }
    }

    private fun handleSend(call: MethodCall, result: Result) {
        try {
            val title = call.argument<String>("title") ?: ""
            val body = call.argument<String>("body") ?: ""
            
            log("Sending notification - Title: $title, Body: $body")

            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val notification = NotificationCompat.Builder(context, channelId)
                .setSmallIcon(getSmallIconResourceId())
                .setContentTitle(title)
                .setContentText(body)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .build()

            val notificationId = notificationIdCounter.incrementAndGet()
            notificationManager.notify(notificationId, notification)
            
            log("Notification sent with ID: $notificationId")
            result.success(null)
        } catch (e: Exception) {
            log("Error sending notification: ${e.message}")
            result.error("SEND_ERROR", e.message, null)
        }
    }

    private fun handleSchedule(call: MethodCall, result: Result) {
        try {
            val title = call.argument<String>("title") ?: ""
            val body = call.argument<String>("body") ?: ""
            val timestamp = call.argument<Long>("timestamp") ?: 0L
            
            log("Scheduling notification - Title: $title, Time: $timestamp")

            // For now, we'll use a simple AlarmManager approach
            // In a production app, you might want to use WorkManager for better reliability
            val intent = Intent(context, NotificationReceiver::class.java).apply {
                putExtra("title", title)
                putExtra("body", body)
                putExtra("channelId", channelId)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                notificationIdCounter.incrementAndGet(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    android.app.AlarmManager.RTC_WAKEUP,
                    timestamp,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    android.app.AlarmManager.RTC_WAKEUP,
                    timestamp,
                    pendingIntent
                )
            }

            log("Notification scheduled successfully")
            result.success(null)
        } catch (e: Exception) {
            log("Error scheduling notification: ${e.message}")
            result.error("SCHEDULE_ERROR", e.message, null)
        }
    }

    private fun handleCancelAll(result: Result) {
        try {
            log("Canceling all notifications")
            notificationManager.cancelAll()
            result.success(null)
        } catch (e: Exception) {
            log("Error canceling notifications: ${e.message}")
            result.error("CANCEL_ERROR", e.message, null)
        }
    }

    private fun handleRequestPermission(result: Result) {
        try {
            log("Requesting notification permission")

            // For Android 13+ (API 33+), we need to request POST_NOTIFICATIONS permission
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val permission = android.Manifest.permission.POST_NOTIFICATIONS
                
                // Check if permission is already granted
                if (ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED) {
                    log("Permission already granted")
                    result.success(true)
                    return
                }

                // Request permission if activity is available
                if (activity != null) {
                    permissionResult = result
                    ActivityCompat.requestPermissions(
                        activity!!,
                        arrayOf(permission),
                        PERMISSION_REQUEST_CODE
                    )
                } else {
                    log("No activity available to request permission")
                    result.success(false)
                }
            } else {
                // For older Android versions, permissions are granted at install time
                log("Android version < 13, permission granted by default")
                result.success(true)
            }
        } catch (e: Exception) {
            log("Error requesting permission: ${e.message}")
            result.error("PERMISSION_ERROR", e.message, null)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            log("Permission result: $granted")
            permissionResult?.success(granted)
            permissionResult = null
            return true
        }
        return false
    }

    private fun getSmallIconResourceId(): Int {
        // Try to get the app icon, fallback to a default system icon
        var resourceId = context.resources.getIdentifier("ic_notification", "drawable", context.packageName)
        if (resourceId == 0) {
            resourceId = context.resources.getIdentifier("ic_launcher", "mipmap", context.packageName)
        }
        if (resourceId == 0) {
            resourceId = android.R.drawable.ic_dialog_info
        }
        return resourceId
    }

    private fun log(message: String) {
        if (debugLogs) {
            Log.d(TAG, message)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ActivityAware implementation
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
        log("Attached to activity")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
