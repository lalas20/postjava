package com.example.postjava;



import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;

import android.content.Intent;
import android.content.res.Configuration;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.util.Base64;
import android.util.Log;

import com.digitalpersona.uareu.Quality;
import com.digitalpersona.uareu.Reader;
import com.digitalpersona.uareu.Engine;
import com.digitalpersona.uareu.Fid;
import com.digitalpersona.uareu.Fmd;
import com.digitalpersona.uareu.Reader;
import com.digitalpersona.uareu.ReaderCollection;
import com.digitalpersona.uareu.UareUException;
import com.digitalpersona.uareu.UareUGlobal;
import com.digitalpersona.uareu.Reader.Priority;
import com.digitalpersona.uareu.dpfpddusbhost.DPFPDDUsbException;
import com.digitalpersona.uareu.dpfpddusbhost.DPFPDDUsbHost;
import com.digitalpersona.uareu.jni.DpfjQuality;
import com.example.postjava.utils.Globals;
import com.example.postjava.utils.Utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


public class FingerChannelDP {
    private static final String TAG = "FingerChannelDP";
    private static final String ACTION_USB_PERMISSION = "com.digitalpersona.uareu.dpfpddusbhost.USB_PERMISSION";

    private Reader m_reader = null;
    private ReaderCollection readers = null;
    private String m_deviceName = "";
    private Reader.Capabilities cap=null;
    private Reader.Description des=null;
    private Engine m_engine = null;
    private Fmd m_fmd = null;
    private Reader.CaptureResult cap_result = null;
    private Bitmap m_bitmap = null;
    private int m_DPI = 0;

    private String files="/sdcard/";
    private HashMap<String, String> map = new HashMap<>();

    private Reader.Status status=null;


   private void displayReaderNotFound(String msg)
    {
        Log.i("displayReaderNotFound", msg );
        //m_deviceName="displayReaderNotFound";
    }


    protected void CheckDevice()
    {
        try
        {
            Log.i("CheckDevice","ini"  );
            m_reader.Open(Priority.EXCLUSIVE);
            m_reader.Close();
            Log.i("CheckDevice","fin"  );
        }
        catch (UareUException e1)
        {
            Log.i("CheckDevice",e1.toString()  );
            displayReaderNotFound(e1.toString());
        }
    }
    private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver()
    {
        public void onReceive(Context context, Intent intent)
        {
            String action = intent.getAction();
            if (ACTION_USB_PERMISSION.equals(action))
            {
                synchronized (this)
                {
                    UsbDevice device = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                    if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false))
                    {
                        if(device != null)
                        {
                            //call method to set up device communication
                            CheckDevice();
                        }
                    }
                }
            }
        }
    };
    public HashMap<String, String> captureFinger (Context applContext){
        map.clear();
        Log.i("captureFinger", "ini:" );
        String vResul="";
        m_fmd=null;

        try {
            Log.i("captureFinger", "m_deviceName: "+  m_deviceName);
            readers = UareUGlobal.GetReaderCollection(applContext);Log.i("captureFinger", "readers: " );
            readers.GetReaders();Log.i("captureFinger", "GetReaders: " );
            m_reader= readers.get(0);Log.i("captureFinger", "m_reader: " );
            m_deviceName=readers.get(0).GetDescription().name;Log.i("captureFinger", "m_deviceName: "+m_deviceName );
            //m_reader = Globals.getInstance().getReader(m_deviceName, applContext);
           // Log.i("captureFinger", "m_reader: "+m_reader.GetStatus().status.name() );
            m_reader.Open(Priority.EXCLUSIVE);Log.i("captureFinger", "open: ");
            m_DPI = Globals.GetFirstDPI(m_reader);Log.i("captureFinger", "m_dpi: "+m_DPI);
            m_engine = UareUGlobal.GetEngine();Log.i("captureFinger", "m_engine: ");
            try
            {
                Log.i("captureFinger","init Capture");
                cap_result = m_reader.Capture(Fid.Format.ISO_19794_4_2005, Globals.DefaultImageProcessing, m_DPI, -1);
                Log.i("captureFinger","fin Capture 123");
            }
            catch (Exception e)
            {
                Log.i("captureFinger","ex:113 "+e.getMessage());
                m_deviceName = "";
                onBackPressed();
            }

            // an error occurred
            if (cap_result == null || cap_result.image == null) {
                Log.i("captureFinger","cap_result es nullo o la imagen es null");
                onBackPressed();
                map.put("state","01");
                map.put("message","intente nuevamente la captura");

                return map;
            };
            try
            {
                Log.i("captureFinger","143 ");
                vResul="";
                if (m_fmd == null)
                {
                    Log.i("captureFinger","147 ");
                    m_fmd = m_engine.CreateFmd(cap_result.image, Fmd.Format.ISO_19794_2_2005);
                    Log.i("captureFinger", "ConverBase64byte getData:" +Globals.ConverBase64byte(m_fmd.getData()) );
/*                  Globals.save2File("/sdcard/raw.data",m_fmd.getData());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                    String name = sdf.format(new Date()) + "_finger.bmp";
                    Globals.generateBmp_NEW(m_bitmap,name,applContext);
                    Log.i("generateBmp", " se genero la imagen:" +name );
 */
                    map.put("state","00");
                    //map.put("message","registro recuperado satisfactoriamente");
                    map.put("message",Globals.ConverBase64byte(m_fmd.getData()));

                    //vResul="se creo el obj m_fmd";
                }
                else {
                    Log.i("captureFinger","m_fmd no es null ");
                }
            }
            catch (Exception e)
            {
                Log.i("captureFinger","ex:147 "+e.getMessage());
                map.put("state","02");
                map.put("message","excepcion CreateFmd: "+e.getMessage());
                //vResul = e.toString();
                //Log.w("UareUSampleJava", "Engine error: " + e.toString());
            }

        }
        catch (Exception e)
        {
            Log.i("captureFinger","ex:157 "+e.getMessage());
            map.put("state","02");
            map.put("message","excepcion caturefinger: "+e.getMessage());
            //vResul="error reader";
            //onBackPressed();
        }
        onBackPressed();
        return  map;
    }

    public void onBackPressed()
    {
        try
        {
            try {
                if(m_reader!=null)
                {
                    m_reader.CancelCapture();
                }
            } catch (Exception e) {
                Log.w("UareUSampleJava", "error during reader CancelCapture: " + e.getMessage());
            }
           if(m_reader!=null) {
               m_reader.Close();
           }
        }
        catch (Exception e)
        {
            Log.w("UareUSampleJava", "error during reader shutdown: " + e.getMessage());
        }
    }

    public HashMap<String, String>   initFingerDP(Context applContext){
        Log.i(TAG, "initFingerDP: 31 ini" );Utils.writeToLogFile("initFingerDP: 31 ini");
        m_deviceName="";
        map.clear();Utils.writeToLogFile("despues de borrar map");
        try {
            Utils.writeToLogFile("antes de GetReaderCollection");
            try {
                Utils.writeToLogFile("antes de getReaders");
                //readers = UareUGlobal.GetReaderCollection(applContext);
                readers =Globals.getInstance().getReaders(applContext);
                Utils.writeToLogFile("despues de getReaders");
            }catch(Exception e){
                Utils.writeToLogFile("ex"+e.getMessage());
                map.put("state","03");
                map.put("message","excepcion: " + e.getMessage());
                onBackPressed();
                return  map;
            }
            Log.i(TAG, "initFingerDP: 36" );
            Utils.writeToLogFile("initFingerDP: 36");
            readers.GetReaders();
            if (readers.size()==0)
            {
                m_deviceName="";
                map.put("state","01");
                map.put("message","Dispositivo no reconocido ");
                return map;
            }
            Log.i(TAG, "cantidad reader:" + readers.size() );
           Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().name);
            Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().id.product_name);

            m_reader= readers.get(0);
            m_deviceName=readers.get(0).GetDescription().name;
            Utils.writeToLogFile("m_deviceName: " +m_deviceName);
            //add permisos usb
            if((m_deviceName != null) && !m_deviceName.isEmpty())
            {
                Utils.writeToLogFile("m_deviceName: NO ES VACIO");
                try
                {
                    Log.i("initFingerDP","revisando permisos");Utils.writeToLogFile("revisando permisos");
                    PendingIntent mPermissionIntent;
                    Log.i("initFingerDP","mPermissionIntent"); Utils.writeToLogFile("mPermissionIntent 246");
                    mPermissionIntent = PendingIntent.getBroadcast(applContext, 0, new Intent(ACTION_USB_PERMISSION), 0);
                    Log.i("initFingerDP","mPermissionIntent");Utils.writeToLogFile("mPermissionIntent 248");
                    IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
                    Log.i("initFingerDP","filter"); Utils.writeToLogFile("filter 250");
                    applContext.registerReceiver(mUsbReceiver, filter);
                    Log.i("initFingerDP","registerReceiver"); Utils.writeToLogFile("registerReceiver 252");
                    if(DPFPDDUsbHost.DPFPDDUsbCheckAndRequestPermissions(applContext, mPermissionIntent, m_deviceName))
                    {
                        Log.i("initFingerDP","ini CheckDevice"); Utils.writeToLogFile("ini CheckDevice 255");
                        //CheckDevice();
                        m_reader.Open(Priority.EXCLUSIVE);
                        m_reader.Close();
                        Log.i("initFingerDP","fin CheckDevice");  Utils.writeToLogFile("fin CheckDevice 259");
                    }

                } catch (DPFPDDUsbException e)
                {
                    Log.i("initFingerDP","sin permisos" + e.getMessage()); Utils.writeToLogFile("sin permisos" + e.getMessage());
                    displayReaderNotFound(e.getMessage());
                    map.put("state","02");
                    map.put("message","excepcion: "+e.toString() );
                    return map;
                }

            } else
            {
                m_deviceName="";
                map.put("state","01");
                map.put("message","dispositivo no tiene nombre ");Utils.writeToLogFile("dispositivo no tiene nombre");
            }
            m_reader.Open(Priority.EXCLUSIVE);
            map.put("state","00");
            map.put("message",m_deviceName);
        }
        catch (Exception e)
        {
            Log.i("initFingerDP","ex"+e.getMessage()); Utils.writeToLogFile("ex"+e.getMessage());
            map.put("state","03");
            map.put("message","excepcion: " + e.getMessage());
        }
        onBackPressed();
        return  map;
    }
}
