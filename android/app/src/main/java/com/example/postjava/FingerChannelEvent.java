package com.example.postjava;
import static com.zcs.sdk.util.PowerHelper.getSystemProperty;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;


import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.fingerprint.FingerprintListener;
import com.zcs.sdk.fingerprint.FingerprintManager;
import com.zcs.sdk.fingerprint.Result;
import com.zcs.sdk.util.StringUtils;

import org.bouncycastle.util.encoders.Base64;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;


import io.flutter.embedding.engine.systemchannels.KeyEventChannel;
import io.flutter.plugin.common.EventChannel;

public class FingerChannelEvent implements  EventChannel.StreamHandler, FingerprintListener  {

    DriverManager mDriverManager= DriverManager.getInstance();

    private Handler mHandler =new Handler(Looper.getMainLooper());

    private FingerprintManager mFingerprintManager =mDriverManager.getFingerprintManager();           ;
    private int mFingerId = 0;
    private int mTimeout = 3;
    private  int count=0;
    private byte[] featureTmp;
    private byte[] isoFeatureTmp;

    private String isoFeatureTmpTxt;



    private EventChannel.EventSink fingerEventSink;


    private final Runnable runnable = new Runnable() {
        @Override
        public void run() {
            int TOTAL_COUNT = 10;
            boolean vEntre=false;
            if(fingerEventSink==null){
                Log.d("runable", "run: finger evenvacio");
            }
            else {
                if(isoFeatureTmp!=null)
                fingerEventSink.success(isoFeatureTmp);
            }
            if (count > TOTAL_COUNT) {
                vEntre=false;

                if(fingerEventSink==null)
                fingerEventSink.endOfStream(); // ends the stream
            } else {
                if(isoFeatureTmp!=null)
                fingerEventSink.success(isoFeatureTmp);
            }
            count++;
        }

    };


    String initFinger() {
        String zcs_model_code = getSystemProperty("ro.zcs.platform.tag");
        Log.d("pengzhan","zcs_model_code = " + zcs_model_code);
        if(zcs_model_code.equals("zcspt003") || zcs_model_code.equals("zcspt012")) {
            return "01:El dispositivo no admite lectura de huella";
        }
        mFingerprintManager = mDriverManager.getFingerprintManager();
        mFingerprintManager.addFignerprintListener(this);
        mFingerprintManager.init();

         new Handler(Looper.getMainLooper()).postDelayed(
                 runnable,2000
         );

        return  "00:La lectura fue correcta";
    }

    void initCapturaIso()
    {
       mFingerprintManager.captureAndGetISOFeature(2);
    }


    @Override
    public void onEnrollmentProgress(int i, int i1, int i2) {
        Log.d("event","onEnrollmentProgress ");
    }

    @Override
    public void onAuthenticationFailed(int i) {
        Log.d("event","onAuthenticationFailed ");
    }

    @Override
    public void onAuthenticationSucceeded(int i, Object o) {
        Log.d("event","onAuthenticationSucceeded ");

    }

    @Override
    public void onGetImageComplete(int i, byte[] bytes) {
        Log.d("event","onGetImageComplete ");

    }

    @SuppressLint("SuspiciousIndentation")
    @Override
    public void onGetImageFeature(int result, byte[] feature) {
        Log.d("event","onGetImageFeature ");
        if (result == SdkResult.SDK_OK) {
            featureTmp = feature;
            isoFeatureTmp = feature;
            if(fingerEventSink!=null)
            {
                fingerEventSink.success(isoFeatureTmp);
            }
        }
        else
        fingerEventSink.error("00","revisar error",result);
    }

    @Override
    public void onGetImageISOFeature(int i, byte[] bytes) {
        Log.d("event","onGetImageISOFeature desde java");

        if (i == SdkResult.SDK_OK) {
            //Log.d("event","captura cadena txt");
            isoFeatureTmp = bytes;
            isoFeatureTmpTxt=StringUtils.convertBytesToHex(bytes);
            //Log.d("event",isoFeatureTmpTxt.toString());
            if(fingerEventSink!=null)
            {
               // Log.d("event","captura");
                //Log.d("event",StringUtils.convertBytesToHex(isoFeatureTmp));
                //Log.d("event", Base64.decode(bytes));
                //fingerEventSink.success(isoFeatureTmpTxt);
            }
            else
            {
                isoFeatureTmp=null;  //fingerEventSink.error("00","fingerEventSink null",i);
            }

        }
        else
            isoFeatureTmp=null; //fingerEventSink.error("00","revisar error",i);
    }

    public void sendEvent(){
        Log.d("event","sendEvent");

        //if(isoFeatureTmpTxt!=null && fingerEventSink!=null){
        if(isoFeatureTmp!=null && fingerEventSink!=null){
            Log.d("event","sendEvent 127: " + isoFeatureTmp);
            fingerEventSink.success(isoFeatureTmp);
        }
        else {
            if(isoFeatureTmp==null){
                Log.d("sendEvent","isoFeatureTmp vacio");
            }
            if(fingerEventSink==null){
                Log.d("sendEvent","fingerEventSink vacio");
            }

            if(fingerEventSink!=null)
            fingerEventSink.error("00","fingerEventSink null",0);
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {

        if(events==null) return;
        Log.d("onListen","onListen add");
        fingerEventSink=events;
    }




    @Override
    public void onCancel(Object arguments) {
        //Log.d("event","onCancel");
        fingerEventSink=null;
        mFingerprintManager.removeFignerprintListener(this);

    }

    List<String> converBytelistString(byte[] bytess)
    {
        byte[] bytes = { 72, 101, 108, 108, 111 }; // arreglo de bytes de ejemplo
        List<String> stringList = new ArrayList<>();

        for (byte b : bytes) {
            String s = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
                s = new String(new byte[] { b }, StandardCharsets.UTF_8);
            }
            stringList.add(s);
        }
        return stringList;
    }
}
