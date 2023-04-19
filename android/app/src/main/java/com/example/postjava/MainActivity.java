package com.example.postjava;

import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        BinaryMessenger messenger= flutterEngine.getDartExecutor().getBinaryMessenger();
        String methodChannelName = "com.prodem/mc";

        MethodChannel methodChannel= new MethodChannel(messenger,methodChannelName);

        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                switch (call.method){
                    case "horaversion":
                        String vHoraVersion=getHoraVersion ();
                        result.success(vHoraVersion);
                        break;
                    default:
                        result.notImplemented();

                }
            }
        });

    }

    String getHoraVersion(){
        int sdkversion=Build.VERSION.SDK_INT;
                String release=Build.VERSION.RELEASE;
       return "Android version: " +sdkversion+" (" + release+")";
    }
}
