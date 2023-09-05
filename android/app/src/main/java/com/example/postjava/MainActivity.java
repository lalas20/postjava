package com.example.postjava;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
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

import java.util.HashMap;

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
        String eventChannelFingerName="com.prodem/emcF";
        String eventChannelCardName="com.prodem/emcC";
        String eventChannelEMVName="com.prodem/emcEmv";

        FingerChannelEvent fingerChannelEvent= new FingerChannelEvent();
        CardIcChannel cardChannel=new CardIcChannel();
        EmvChannel emvChannel=new EmvChannel();

        MethodChannel methodChannel= new MethodChannel(messenger,methodChannelName);
        PrintChannel printChannel=new PrintChannel();
        FingerChannelDP fingerChannelDP = new FingerChannelDP();


        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                String vResFinger="";
                switch (call.method){
                    case "disposeEMV":
                        emvChannel.disposeCardIc();
                        result.success("disposeEMV");
                        Log.i("onMethodCall", "disposeEMV: 55");
                        break;
                    case "searchEMV":
                        Log.i("searchEMV", "inicial verificaGetIcCard ");
                        emvChannel.initSdk();
                        Log.i("onMethodCall", "searchEMV: 55");
                        result.success("searchEMV");
                        break;
                    case "disposeCardIc":
                        cardChannel.disposeCardIc();
                        result.success("disposeCardIc");
                        break;
                    case "searchMagnetCard":
                        cardChannel.searchMagnetCard();
                        result.success("searchMagnetCard");
                        break;
                    case "researchICC":
                        cardChannel.searchICCard();
                        result.success("researchICC");
                        break;
                    case "getAndroidID":
                        result.success(getAndroidID ());
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
                    case "printVoucher":
                        Log.i("printVoucher", "inicio: ");
                        PrintVoucher printVoucher=new PrintVoucher();
                        printVoucher.cuentaDestino = call.argument("cuentaDestino");
                        printVoucher.fechaTransaccion=call.argument("fechaTransaccion");
                        printVoucher.glosa=call.argument("glosa");
                        printVoucher.cuentaOrigen=call.argument("cuentaOrigen");
                        printVoucher.bancoDestino=call.argument("bancoDestino");
                        printVoucher.titular=call.argument("titular");
                        printVoucher.montoPago=call.argument("montoPago");
                        printVoucher.nroTransaccion=call.argument("nroTransaccion");
                        printVoucher.tipoPago=call.argument("tipoPago");

                        Log.i("printVoucher", "fin: inicio de impresion ");
                        vResFinger= printChannel.printVoucher(printVoucher);
                        Log.i("printVoucher", "fin: de impresion ");
                        if(vResFinger=="Error"){
                            vmssPrin="error";
                            result.success(vResFinger);
                        }else {
                            vmssPrin="elsee ingreso";
                            result.success(vResFinger);
                        }

                        break;
                    case "printRptDetalleChannel":
                        PrintRptDetalleVoucher rptprintVoucher=new PrintRptDetalleVoucher();
                        rptprintVoucher.fechaTransaccion = call.argument("fechaTransaccion");
                        rptprintVoucher.nroTransaccion=call.argument("nroTransaccion");
                        rptprintVoucher.agencia=call.argument("agencia");
                        rptprintVoucher.referencia=call.argument("referencia");
                        rptprintVoucher.montoTxt=call.argument("montotxt");
                        rptprintVoucher.saldoTxt=call.argument("saldotxt");

/*
                        rptprintVoucher.fechaTransaccion ="fecha";
                        rptprintVoucher.nroTransaccion="nroTransaccion";
                        rptprintVoucher.agencia="agencia";
                        rptprintVoucher.referencia="referencia";
                        rptprintVoucher.montoTxt="montotxt";
                        rptprintVoucher.saldoTxt="saldotxt";
*/
                        Log.i("printVoucher", "fechaTransaccion: "+rptprintVoucher.fechaTransaccion);
                        Log.i("printVoucher", "nroTransaccion: "+rptprintVoucher.nroTransaccion);
                        Log.i("printVoucher", "agencia: "+rptprintVoucher.agencia);
                        Log.i("printVoucher", "referencia: "+rptprintVoucher.referencia);
                        Log.i("printVoucher", "montoTxt: "+rptprintVoucher.montoTxt);
                        Log.i("printVoucher", "saldoTxt: "+rptprintVoucher.saldoTxt);
                        vResFinger= printChannel.printRptDetalleChannel(rptprintVoucher);
                        Log.i("printVoucher", "fin: de impresion ");
                        if(vResFinger=="Error"){
                            vmssPrin="error";
                            result.success(vResFinger);
                        }else {
                            vmssPrin="elsee ingreso";
                            result.success(vResFinger);
                        }

                        break;
                    case "starFinger":
                        vResFinger=   fingerChannelEvent.initFinger();
                        result.success(vResFinger);
                        break;
                    case "captureFingerISO":
                        Log.i("captureFingerISO", "sendEvent ");

                        fingerChannelEvent.sendEvent();
                        result.success("initCapturaIso");
                        break;
                    case "disposeFinger":
                        fingerChannelDP.onBackPressed();
                        result.success("disposeFinger");
                        break;
                    case "captureNameDevice":
                        Log.i("onMethodCall", "captureNameDevice: 43");
                        HashMap<String, String> vNameDevice= fingerChannelDP.initFingerDP (getApplicationContext());
                        result.success(vNameDevice);
                        Log.i("onMethodCall", "vNameDevice: 55");
                        break;
                    case "captureFingerDP":
                        Log.i("onMethodCall", "disposeEMV: 55");
                        HashMap<String, String> resul= fingerChannelDP.captureFinger (getApplicationContext());
                        result.success(resul);

                        break;

                    default:
                        result.notImplemented();

                }
            }
        });

        //capturando los eventos del finger
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),eventChannelFingerName).setStreamHandler(fingerChannelEvent);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),eventChannelCardName).setStreamHandler(cardChannel);
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),eventChannelEMVName).setStreamHandler(emvChannel);

    }

    String getAndroidID(){
        String myID;
        int myversion = Integer.parseInt(android.os.Build.VERSION.SDK);
        if (myversion < 23) {
            TelephonyManager mngr = (TelephonyManager)getSystemService(getApplicationContext().TELEPHONY_SERVICE);
            myID= mngr.getDeviceId();
        }
        else
        {
            myID = Settings.Secure.getString(getApplicationContext().getContentResolver(),Settings.Secure.ANDROID_ID);
        }
        return "Prd-"+myversion +"-" +myID;
    }
}
