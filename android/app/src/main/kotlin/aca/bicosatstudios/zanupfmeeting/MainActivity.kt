package aca.bicosatstudios.zanupfmeeting

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.content.ComponentName

class MainActivity : FlutterActivity() {
    private val CHANNEL = "aca.bicosatstudios/foreground"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val serviceIntent = Intent()
            // We use ComponentName to point to the library service by its string name
            serviceIntent.component = ComponentName(
                "aca.bicosatstudios.zanupfmeeting", 
                "com.cloudwebrtc.foregroundservice.ForegroundService"
            )

            if (call.method == "startService") {
                serviceIntent.action = "com.cloudwebrtc.foregroundservice.ACTION_START"
                serviceIntent.putExtra("notification_title", "Screen Sharing")
                serviceIntent.putExtra("notification_text", "ZANU PF Meeting is sharing your screen")
                
                try {
                    startForegroundService(serviceIntent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("SERVICE_ERROR", e.message, null)
                }
            } else if (call.method == "stopService") {
                serviceIntent.action = "com.cloudwebrtc.foregroundservice.ACTION_STOP"
                stopService(serviceIntent)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}