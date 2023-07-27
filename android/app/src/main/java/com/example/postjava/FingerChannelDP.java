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

    private void displayReaderNotFound()
    {
        m_deviceName="displayReaderNotFound";
    }
    protected void CheckDevice()
    {
        try
        {
            m_reader.Open(Priority.EXCLUSIVE);
           // Reader.Capabilities cap = m_reader.GetCapabilities();
            m_reader.Close();
        }
        catch (UareUException e1)
        {
            displayReaderNotFound();
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
        try {
            m_reader = Globals.getInstance().getReader(m_deviceName, applContext);
            m_reader.Open(Priority.EXCLUSIVE);
            m_DPI = Globals.GetFirstDPI(m_reader);
            m_engine = UareUGlobal.GetEngine();
            try
            {
                cap_result = m_reader.Capture(Fid.Format.ISO_19794_4_2005, Globals.DefaultImageProcessing, m_DPI, -1);
            }
            catch (Exception e)
            {
                m_deviceName = "";
                onBackPressed();
            }
            // an error occurred
            if (cap_result == null || cap_result.image == null) {
                onBackPressed();
                map.put("state","01");
                map.put("message","intente nuevamente la captura");

                return map;
            };
            try
            {
                vResul="";
                if (m_fmd == null)
                {
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
            }
            catch (Exception e)
            {
                map.put("state","02");
                map.put("message","excepcion CreateFmd: "+e.getMessage());
                //vResul = e.toString();
                //Log.w("UareUSampleJava", "Engine error: " + e.toString());
            }

        }
        catch (Exception e)
        {
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
            try { m_reader.CancelCapture(); } catch (Exception e) {}
            m_reader.Close();
        }
        catch (Exception e)
        {
            Log.w("UareUSampleJava", "error during reader shutdown");
        }
    }

    public HashMap<String, String>   initFingerDP(Context applContext){
        Log.i(TAG, "initFingerDP: 31 ini" );
        m_deviceName="sin data";
        map.clear();
        try {

            readers = UareUGlobal.GetReaderCollection(applContext);
            Log.i(TAG, "initFingerDP: 36" );
            readers.GetReaders();
            if (readers.size()==0)
            {
                m_deviceName="Dispositivo no reconocido";
                map.put("state","01");
                map.put("message","Dispositivo no reconocido ");
                return map;
            }
/*            Log.i(TAG, "cantidad reader:" + readers.size() );
            Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().name);
            Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().id.product_name);
 */
            m_reader= readers.get(0);
            m_deviceName=readers.get(0).GetDescription().name;
            //add permisos usb
            if((m_deviceName != null) && !m_deviceName.isEmpty())
            {
                try
                {
                    PendingIntent mPermissionIntent;
                    mPermissionIntent = PendingIntent.getBroadcast(applContext, 0, new Intent(ACTION_USB_PERMISSION), 0);
                    IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
                    applContext.registerReceiver(mUsbReceiver, filter);
                    if(DPFPDDUsbHost.DPFPDDUsbCheckAndRequestPermissions(applContext, mPermissionIntent, m_deviceName))
                    {
                        CheckDevice();
                    }

                } catch (DPFPDDUsbException e)
                {
                    displayReaderNotFound();
                }

            } else
            {
                displayReaderNotFound();
            }
            m_reader.Open(Priority.COOPERATIVE);
        }
        catch (Exception e)
        {
            map.put("state","03");
            map.put("message","excepcion: " + e.getMessage());
        }
        onBackPressed();
        return  map;
    }
}
