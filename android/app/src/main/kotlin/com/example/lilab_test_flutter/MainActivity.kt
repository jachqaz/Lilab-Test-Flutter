package com.example.lilab_test_flutter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val CHANNEL_ID = "social_challenge_notifications"
    private val CHANNEL_NAME = "Social Challenge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        NativeService.setUp(flutterEngine.dartExecutor.binaryMessenger, NativeServiceImpl(this))
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    inner class NativeServiceImpl(private val context: Context) : NativeService {
        override fun sendLocalNotification(payload: NotificationPayload) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setContentTitle(payload.titulo)
                .setContentText(payload.mensaje)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true)
                .build()

            notificationManager.notify(payload.id.toIntOrNull() ?: 0, notification)
        }
    }
}
