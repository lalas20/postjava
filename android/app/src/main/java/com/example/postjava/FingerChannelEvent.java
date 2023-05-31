package com.example.postjava;
import static com.zcs.sdk.util.PowerHelper.getSystemProperty;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
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

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


import io.flutter.embedding.engine.systemchannels.KeyEventChannel;
import io.flutter.plugin.common.EventChannel;

public class FingerChannelEvent implements  EventChannel.StreamHandler, FingerprintListener {

    DriverManager mDriverManager = DriverManager.getInstance();

    private Handler mHandler = new Handler(Looper.getMainLooper());

    private FingerprintManager mFingerprintManager = mDriverManager.getFingerprintManager();
    ;
    private int mFingerId = 0;
    private int mTimeout = 3;
    private int count = 1;
    private int maxcount = 1;
    private byte[] isoFeatureTmp;
    private String isoFeatureTmptxt;
    private String files = "/sdcard/";
    private EventChannel.EventSink fingerEventSink;

    private final Runnable runnable = new Runnable() {
        @Override
        public void run() {
            Log.d("runable", "run: 56");
            if (count > maxcount) {
                Log.d("runable", "run: 58");
                if (fingerEventSink != null) {
                    fingerEventSink.endOfStream();
                }
                onCancel(null);
            }
            else {
                Log.d("runable", "run: 71");
                if(isoFeatureTmptxt!=null)
                {
                    Log.d("runable", "isoFeatureTmptxt no es vacio");
                    count=maxcount+1;
                    fingerEventSink.success(isoFeatureTmptxt);
                }
                /*
                // initCapturaIso();
                if (fingerEventSink == null) {
                    Log.d("es null", "run: fingerEventSink null");
                } else {
                    Log.d("tiene data", "run: fingerEventSink");
                    if (isoFeatureTmptxt == null) {
                        Log.d("es null", "run: isoFeatureTmp es null");
                    } else {
                        Log.d("tiene data", "run: isoFeatureTmp");
                        //fingerEventSink.success(isoFeatureTmp);
                        fingerEventSink.success(isoFeatureTmptxt);
                    }
                }
*/
                Log.d("runable", "run: 62");
            }
            count++;
            Log.d("runable", "run: count" + count);
            mHandler.postDelayed(this, 2000);
        }


    };


    String initFinger() {
        String zcs_model_code = getSystemProperty("ro.zcs.platform.tag");
        Log.d("pengzhan", "zcs_model_code = " + zcs_model_code);
        if (zcs_model_code.equals("zcspt003") || zcs_model_code.equals("zcspt012")) {
            return "01:El dispositivo no admite lectura de huella";
        }
        mFingerprintManager = mDriverManager.getFingerprintManager();
        mFingerprintManager.addFignerprintListener(this);
        mFingerprintManager.init();

        return "00:La lectura fue correcta";
    }

    void initCapturaIso() {
        Log.d("initCapturaIso ", "ingreso 108");
        mFingerprintManager.captureAndGetISOFeature();
        Log.d("initCapturaIso ", "ingreso 110");
    }


    @Override
    public void onEnrollmentProgress(int i, int i1, int i2) {
        Log.d("event", "onEnrollmentProgress ");
    }

    @Override
    public void onAuthenticationFailed(int i) {
        Log.d("event", "onAuthenticationFailed ");
    }

    @Override
    public void onAuthenticationSucceeded(int i, Object o) {
        Log.d("event", "onAuthenticationSucceeded ");

    }

    @Override
    public void onGetImageComplete(int i, byte[] bytes) {
        Log.d("onGetImageComplete", " i:" + i);
        //Log.d("onGetImageComplete", " conver: " + StringUtils.convertBytesToHex(bytes));
        if (i == SdkResult.SDK_OK) {
            Log.d("onGetImageComplete", "127 :");
            //isoFeatureTmp = bytes;

            save2File("/sdcard/raw.data", bytes);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String name = sdf.format(new Date()) + ".bmp";
            // convert raw format image to bmp
            final Bitmap bitmap = mFingerprintManager.generateBmp(bytes, files + name);
            Log.d("onGetImageComplete", "files + name :"+files + name);
            isoFeatureTmptxt=files + name;
            Log.d("onGetImageComplete", "name :" +name);
           /*
            if (fingerEventSink != null) {
                fingerEventSink.success(isoFeatureTmp);
                Log.d("onGetImageComplete", "132 :");
            }*/
        } else {
            //isoFeatureTmp = null;
            isoFeatureTmptxt=null;
            //fingerEventSink.error("00", "revisar error", i);
            Log.d("onGetImageComplete", "136 :");
        }
        Log.d("onGetImageComplete", "138 :");
    }


    @Override
    public void onGetImageFeature(int result, byte[] feature) {

    }

    @Override
    public void onGetImageISOFeature(int i, byte[] bytes) {
        Log.d("event", "onGetImageISOFeature desde java");

        if (i == SdkResult.SDK_OK) {
            isoFeatureTmp = bytes;
        } else
            isoFeatureTmp = null;
    }

    public void sendEvent() {
        Log.d("event", "sendEvent");
        count = 1;
        maxcount = 2;
        isoFeatureTmp = null;
        isoFeatureTmptxt=null;
        initFinger();
        //mFingerprintManager.captureAndGetISOFeature();
        mFingerprintManager.capture();
    }

    public void closeFinger() {
        Log.d("closeFinger", "close 201");
        fingerEventSink = null;
        Log.d("closeFinger", "close 203");
        mFingerprintManager.removeFignerprintListener(this);
        Log.d("closeFinger", "close 205");
        mHandler.removeCallbacks(runnable);
        Log.d("closeFinger", "close 207");
        // mFingerprintManager.close();
        Log.d("closeFinger", "destroy 209");
        //mFingerprintManager.destroy();
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("onListen", "onListen 213");
        if (events == null) return;
        Log.d("onListen", "onListen add");
        fingerEventSink = events;
        runnable.run();
    }


    @Override
    public void onCancel(Object arguments) {
        Log.d("event", "onCancel 216");
        fingerEventSink = null;
        mFingerprintManager.removeFignerprintListener(this);
        mHandler.removeCallbacks(runnable);

    }

    private void save2File(String path, byte[] data) {
        FileOutputStream fos = null;
        try {
            File f = new File(path);
            if (!f.exists()) {
                if (!f.getParentFile().exists()) {
                    f.getParentFile().mkdirs();
                }
                f.createNewFile();
            }
            fos = new FileOutputStream(f);
            fos.write(data);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    /*public static String convertBitmapToString(Bitmap bitmap) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        //return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
    }*/
}