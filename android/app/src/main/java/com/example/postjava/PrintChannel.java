package com.example.postjava;

import android.text.Layout;
import android.util.Log;
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

    PrintChannel()
    {

    }

    public String printVoucher(PrintVoucher printVoucher ){

        String vRespuesta;
        mDriverManager = DriverManager.getInstance();
        if(mDriverManager==null){ vRespuesta="drive"; return vRespuesta;}
        Log.d("pengzhan","zcs_model_code = ");
        mPrinter = mDriverManager.getPrinter();
        if(mPrinter==null){ vRespuesta="mPrinter"; return vRespuesta;}
        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            vRespuesta="Error";
        } else {
            PrnStrFormat format = new PrnStrFormat();
            format.setTextSize(30);
            format.setAli(Layout.Alignment.ALIGN_CENTER);
            format.setStyle(PrnTextStyle.BOLD);
            format.setFont(PrnTextFont.SANS_SERIF);
            mPrinter.setPrintAppendString("PRODEM - POS ", format);
            format.setTextSize(20);
            format.setStyle(PrnTextStyle.NORMAL);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(printVoucher.bancoDestino, format);
            mPrinter.setPrintAppendString("Nro. transacción: "+printVoucher.nroTransaccion, format);
            mPrinter.setPrintAppendString("Titular: " +printVoucher.titular, format);
            mPrinter.setPrintAppendString("Fecha: " +printVoucher.fechaTransaccion, format);
            mPrinter.setPrintAppendString("Monto: " +printVoucher.montoPago, format);
            format.setTextSize(20);
            mPrinter.setPrintAppendString("Cta. Origen: " +printVoucher.cuentaOrigen, format);
            mPrinter.setPrintAppendString("Cta. Destino: " +printVoucher.cuentaDestino, format);
            mPrinter.setPrintAppendString("Tipo Pago: " +printVoucher.tipoPago, format);
            format.setTextSize(20);
            format.setStyle(PrnTextStyle.NORMAL);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);
            mPrinter.setPrintAppendString("Glosa: " +printVoucher.glosa, format);

            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" -----------------------------", format);

            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            printStatus = mPrinter.setPrintStart();
            Log.i("printStatus", "printStatus: "+printStatus);
            vRespuesta="ejecucion del print " + printStatus;

        }
        return  vRespuesta;
    }

    public String printTextMessage(String pText){
        String vRespuesta;
        mDriverManager = DriverManager.getInstance();
        if(mDriverManager==null){ vRespuesta="drive"; return vRespuesta;}
        Log.d("pengzhan","zcs_model_code = ");
        mPrinter = mDriverManager.getPrinter();
        if(mPrinter==null){ vRespuesta="mPrinter"; return vRespuesta;}
        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            vRespuesta="Error";
        } else {
            PrnStrFormat format = new PrnStrFormat();
            format.setTextSize(30);
            format.setAli(Layout.Alignment.ALIGN_CENTER);
            format.setStyle(PrnTextStyle.BOLD);
            format.setFont(PrnTextFont.SANS_SERIF);
            mPrinter.setPrintAppendString("PRODEM - POS ", format);
            format.setTextSize(25);
            format.setStyle(PrnTextStyle.NORMAL);
            format.setAli(Layout.Alignment.ALIGN_NORMAL);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString("PRUEBA DE IMPRESION: .... ", format);
            format.setTextSize(25);
            mPrinter.setPrintAppendString(pText, format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" -----------------------------", format);

            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            printStatus = mPrinter.setPrintStart();
            vRespuesta="ejecucion del print " + printStatus;
        }
        return  vRespuesta;
    }


    public String  printText() {
        String vRespuesta;
        mDriverManager = DriverManager.getInstance();
        if(mDriverManager==null){ vRespuesta="drive"; return vRespuesta;}
        Log.d("pengzhan","zcs_model_code = ");
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

class PrintVoucher{
   public  int nroTransaccion;
    public String titular;
    public String fechaTransaccion;
    public double montoPago;

    //cuenta origen
    public    String cuentaOrigen;
    //cuenta destino
    public String cuentaDestino;
    public String bancoDestino;
    //concepto
    public String glosa;
    public String tipoPago;

}