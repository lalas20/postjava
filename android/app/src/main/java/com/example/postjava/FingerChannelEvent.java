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
    private  int count=1;
    private  int maxcount=1;

    private byte[] featureTmp;
    private byte[] isoFeatureTmp;

    private String isoFeatureTmpTxt;



    private EventChannel.EventSink fingerEventSink;

    private final Runnable runnable = new Runnable() {
        @Override
        public void run() {
            Log.d("runable", "run: 56");
            if (count > maxcount) {
                Log.d("runable", "run: 58");

                fingerEventSink.endOfStream();
               onCancel(null);
            } else {
               // initCapturaIso();
                if(fingerEventSink==null)
                {
                    Log.d("es null", "run: fingerEventSink null");
                }
                else {
                    Log.d("tiene data", "run: fingerEventSink");
                    if(isoFeatureTmp==null){
                        Log.d("es null", "run: isoFeatureTmp es null");
                    }
                    else {
                        Log.d("tiene data", "run: isoFeatureTmp");
                        fingerEventSink.success(isoFeatureTmp);
                    }
                }

                Log.d("runable", "run: 62");
            }
            count++;
            Log.d("runable", "run: count" +count);
            mHandler.postDelayed(this, 2000);
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

        return  "00:La lectura fue correcta";
    }

    void initCapturaIso()
    {
        Log.d("initCapturaIso ","ingreso 108");
       mFingerprintManager.captureAndGetISOFeature();
        Log.d("initCapturaIso ","ingreso 110");
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
        count=1;
        maxcount=2;
        initFinger();
        mFingerprintManager.captureAndGetISOFeature();
    }
    public void closeFinger()
    {
        Log.d("closeFinger","close 201");
        fingerEventSink=null;
        Log.d("closeFinger","close 203");
        mFingerprintManager.removeFignerprintListener(this);
        Log.d("closeFinger","close 205");
        mHandler.removeCallbacks(runnable);
        Log.d("closeFinger","close 207");
       // mFingerprintManager.close();
        Log.d("closeFinger","destroy 209");
        //mFingerprintManager.destroy();
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("onListen","onListen 213");
        if(events==null) return;
        Log.d("onListen","onListen add");
        fingerEventSink=events;
        runnable.run();
    }




    @Override
    public void onCancel(Object arguments) {
        Log.d("event","onCancel 216");
        fingerEventSink=null;
        mFingerprintManager.removeFignerprintListener(this);
        mHandler.removeCallbacks(runnable);

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
