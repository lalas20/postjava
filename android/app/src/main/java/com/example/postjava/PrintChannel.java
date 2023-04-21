package com.example.postjava;

import android.text.Layout;
import android.widget.Toast;

import io.flutter.plugin.common.MethodChannel;
import kotlin.text.UStringsKt;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.Printer;
import com.zcs.sdk.print.PrnStrFormat;
import com.zcs.sdk.print.PrnTextFont;
import com.zcs.sdk.print.PrnTextStyle;


public class PrintChannel {
    private DriverManager mDriverManager;
    private Printer mPrinter;
    MethodChannel.Result result;

    PrintChannel(MethodChannel.Result pResult )
    {

        this.result=pResult;
    }


    public String  printText() {
        String vRespuesta;
        mDriverManager = DriverManager.getInstance();
        if(mDriverManager==null){ vRespuesta="drive"; return vRespuesta;}
        mPrinter = mDriverManager.getPrinter();
        if(mPrinter==null){ vRespuesta="mPrinter"; return vRespuesta;}
        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            //out of paper
            //Toast.makeText(getActivity(), "Out of paper", Toast.LENGTH_SHORT).show();
            //this.result.error("pr1","no tiene papel","detalle de error no tiene papel");
            vRespuesta="Error";
        } else {
            PrnStrFormat format = new PrnStrFormat();
            format.setTextSize(30);
            format.setAli(Layout.Alignment.ALIGN_CENTER);
            format.setStyle(PrnTextStyle.BOLD);
            //format.setFont(PrnTextFont.CUSTOM);
            //format.setPath(Environment.getExternalStorageDirectory() + "/fonts/simsun.ttf");
            format.setFont(PrnTextFont.SANS_SERIF);
            mPrinter.setPrintAppendString("POS SALES SLIP", format);
            format.setTextSize(25);
            format.setStyle(PrnTextStyle.NORMAL);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString("MERCHANGT NAME:" + " Test ", format);
            mPrinter.setPrintAppendString("MERCHANT NO:" + " 123456789012345 ", format);
            mPrinter.setPrintAppendString("TERMINAL NAME:" + " 12345678 ", format);
            mPrinter.setPrintAppendString("OPERATOR NO:" + " 01 ", format);
            mPrinter.setPrintAppendString("CARD NO: ", format);
            format.setAli(Layout.Alignment.ALIGN_CENTER);
            format.setTextSize(30);
            format.setStyle(PrnTextStyle.BOLD);
            mPrinter.setPrintAppendString("6214 44** **** **** 7816", format);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);
            format.setStyle(PrnTextStyle.NORMAL);
            format.setTextSize(25);
            mPrinter.setPrintAppendString(" -----------------------------", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            printStatus = mPrinter.setPrintStart();
            vRespuesta="ejecucion del print " + printStatus;
        }
        return  vRespuesta;
    }
}
