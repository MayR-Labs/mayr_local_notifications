package com.mayrlabs.mayr_local_notifications

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title") ?: ""
        val body = intent.getStringExtra("body") ?: ""
        val channelId = intent.getStringExtra("channelId") ?: "mayr_default_channel"

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(getSmallIconResourceId(context))
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        val notificationManager = NotificationManagerCompat.from(context)
        notificationManager.notify(System.currentTimeMillis().toInt(), notification)
    }

    private fun getSmallIconResourceId(context: Context): Int {
        var resourceId = context.resources.getIdentifier("ic_notification", "drawable", context.packageName)
        if (resourceId == 0) {
            resourceId = context.resources.getIdentifier("ic_launcher", "mipmap", context.packageName)
        }
        if (resourceId == 0) {
            resourceId = android.R.drawable.ic_dialog_info
        }
        return resourceId
    }
}
