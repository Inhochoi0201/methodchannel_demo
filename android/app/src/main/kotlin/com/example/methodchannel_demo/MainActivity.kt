package com.example.methodchannel_demo

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "example.com/value" //안드로이드 큰따옴표 사용, 세미콜론없음

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if(batteryLevel != -1) result.success(batteryLevel) //성공
                    else result.error("UNAVAILABLE", "Battery Level can't available",null)
                }
                "getValue" -> {
                    result.success("Success") //잘들어오는경우
                }
                "getAndroidModelName" ->{
                    val version =  getAndroidModelName()
                    if(version != null) result.success(version)
                    else result.error("UNAVAILABLE", "Android Version not available", null)
                }
                else -> {
                    result.notImplemented() //이상한 메소드가 들어오는경우
                }
            }
        }
    }

    private fun getBatteryLevel() : Int {
        val batteryLevel: Int = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }else{
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100
        }
        return batteryLevel
    }

    private fun getAndroidModelName(): String{
        return Build.MODEL
    }

}


