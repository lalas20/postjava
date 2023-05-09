package com.example.postjava;
import static com.zcs.sdk.util.PowerHelper.getSystemProperty;

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

import io.flutter.embedding.engine.systemchannels.KeyEventChannel;
import io.flutter.plugin.common.EventChannel;

public class FingerChannelEvent implements  EventChannel.StreamHandler, FingerprintListener  {

    private Handler handler =new Handler(Looper.getMainLooper());
    private FingerprintManager mFingerprintManager;
    private int mFingerId = 0;
    private int mTimeout = 3;
    private byte[] featureTmp;
    private byte[] isoFeatureTmp;



    private EventChannel.EventSink fingerEventSink;



    String initFinger() {
        String zcs_model_code = getSystemProperty("ro.zcs.platform.tag");
        Log.d("pengzhan","zcs_model_code = " + zcs_model_code);
        if(zcs_model_code.equals("zcspt003") || zcs_model_code.equals("zcspt012")) {
            return "01:El dispositivo no admite lectura de huella";
        }
        mFingerprintManager = DriverManager.getInstance().getFingerprintManager();
        mFingerprintManager.addFignerprintListener(this);
        mFingerprintManager.init();
        //mFingerprintManager.captureAndGetFeature();
        return  "00:La lectura fue correcta";
    }

    void initCapturaIso()
    {
       mFingerprintManager.captureAndGetISOFeature(5);
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
            isoFeatureTmp = bytes;

            if(fingerEventSink!=null)
            {
                Log.d("event","captura");
                Log.d("event",StringUtils.convertBytesToHex(isoFeatureTmp));
                //Log.d("event", Base64.decode(bytes));
                //fingerEventSink.success(isoFeatureTmp);
            }
            else
            {
                isoFeatureTmp=null;  //fingerEventSink.error("00","fingerEventSink null",i);
            }

        }
        else
            isoFeatureTmp=null; //fingerEventSink.error("00","revisar error",i);

       /*
        Runnable r= new Runnable() {
            @Override
            public void run() {

                    if (i == SdkResult.SDK_OK) {
                        isoFeatureTmp = bytes;

                        if(fingerEventSink!=null)
                        {
                            Log.d("event","captura");
                            Log.d("event",StringUtils.convertBytesToHex(isoFeatureTmp));
                            fingerEventSink.success(isoFeatureTmp);
                        }
                        else
                        {
                            fingerEventSink.error("00","fingerEventSink null",i);
                        }

                    }
                    else
                        fingerEventSink.error("00","revisar error",i);
                }

        };
        */
    }

    public void sendEvent(){
        if(isoFeatureTmp!=null && fingerEventSink!=null){
            fingerEventSink.success(isoFeatureTmp);
        }
        else {
            fingerEventSink.error("00","fingerEventSink null",0);
        }

    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("event","onListen add");
        if(events==null) return;

        fingerEventSink=events;
    }




    @Override
    public void onCancel(Object arguments) {
        Log.d("event","onCancel");
        fingerEventSink=null;
        mFingerprintManager.removeFignerprintListener(this);

    }
}
