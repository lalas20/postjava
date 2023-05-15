package com.example.postjava;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.Sys;
import com.zcs.sdk.fingerprint.FingerprintManager;

public class MainActivity extends FlutterActivity {


    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        BinaryMessenger messenger= flutterEngine.getDartExecutor().getBinaryMessenger();
        String methodChannelName = "com.prodem/mc";
        String eventChannelName="com.prodem/emc";

        FingerChannelEvent fingerChannelEvent= new FingerChannelEvent();

        CardIcChannel cardChannel=new CardIcChannel();


        MethodChannel methodChannel= new MethodChannel(messenger,methodChannelName);
        PrintChannel printChannel=new PrintChannel();

        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                String vResFinger="";
                switch (call.method){
                    case "searchMagnetCard":
                        cardChannel.searchMagnetCard();
                        result.success("searchMagnetCard");
                    case "researchICC":
                        cardChannel.searchICCard();
                        result.success("researchICC");
                        break;
                    case "starCard":
                        result.success("starCard iniciado");
                        Log.d("onMethodCall", "starCard: 63");
                        break;
                    case "horaversion":
                        String vHoraVersion=getHoraVersion ();
                        result.success(vHoraVersion);
                        break;
                    case "printtext":
                        String vRes= printChannel.printText();
                        String vmss="";
                        if(vRes=="Error"){
                            vmss="error";
                            result.success(vRes);
                        }else {
                            vmss="elsee ingreso";
                            result.success(vRes);
                        }
                        break;
                    case "printMessage":
                        String pTxt= (String) call.arguments;
                        vResFinger= printChannel.printTextMessage(pTxt);
                        String vmssPrin="";
                        if(vResFinger=="Error"){
                            vmssPrin="error";
                            result.success(vResFinger);
                        }else {
                            vmssPrin="elsee ingreso";
                            result.success(vResFinger);
                        }
                        break;
                    case "starFinger":
                        Log.d("starFinger", "onMethodCall: 87");
                        vResFinger=   fingerChannelEvent.initFinger();
                        result.success(vResFinger);
                        break;
                    case "captureFingerISO":
                        Log.d("Finger", "onMethodCall: 92");
                        fingerChannelEvent.sendEvent();
                        //fingerChannelEvent.initCapturaIso();
                        result.success("initCapturaIso");
                        break;
                    case "disposeFinger":
                        Log.d("Finger", "disposeFinger: 98");
                        fingerChannelEvent.closeFinger();
                        result.success("disposeFinger");
                        break;
                    default:
                        result.notImplemented();

                }
            }
        });

        //capturando los eventos del finger
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),eventChannelName).setStreamHandler(fingerChannelEvent);

    }

    String getHoraVersion(){
        int sdkversion=Build.VERSION.SDK_INT;
        String release=Build.VERSION.RELEASE;
        return "Android version: " +sdkversion+" (" + release+")";
    }

/*
    void test()
    {
        Sys sys = DriverManager.getInstance().getBaseSysDevice();
    }
    */

}
