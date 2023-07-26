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
            Reader.Capabilities cap = m_reader.GetCapabilities();
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
    public String captureFinger (Context applContext){
        Log.i("captureFinger", "ini:" );
        String vResul="";
        try {

           // Context applContext = getApplicationContext();
            m_reader = Globals.getInstance().getReader(m_deviceName, applContext);
            Log.i("captureFinger", "getReader:" );

            m_reader.Open(Priority.EXCLUSIVE);
            Log.i("captureFinger", "Open:" );

            m_DPI = Globals.GetFirstDPI(m_reader);
            Log.i("captureFinger", "GetFirstDPI:" );

            m_engine = UareUGlobal.GetEngine();
            Log.i("captureFinger", "GetEngine:" );

            try
            {
                cap_result = m_reader.Capture(Fid.Format.ISO_19794_4_2005, Globals.DefaultImageProcessing, m_DPI, -1);

                Log.i("captureFinger", "Capture:" );

            }
            catch (Exception e)
            {
                  Log.w("captureFinger", "Exception: " + e.toString());
                    m_deviceName = "";
                    onBackPressed();

            }
            // an error occurred
            if (cap_result == null || cap_result.image == null) {onBackPressed(); return vResul="cap_resul null";};

            try
            {
                vResul="";

                // save bitmap image locally
                /*
                m_bitmap = Globals.GetBitmapFromRaw(cap_result.image.getViews()[0].getImageData(), cap_result.image.getViews()[0].getWidth(), cap_result.image.getViews()[0].getHeight());
                Log.i("captureFinger", "GetBitmapFromRaw:" );*/

                if (m_fmd == null)
                {
                    m_fmd = m_engine.CreateFmd(cap_result.image, Fmd.Format.ISO_19794_2_2005);
                    Log.i("captureFinger", "ConverBase64byte getData:" +Globals.ConverBase64byte(m_fmd.getData()) );
                    Globals.save2File("/sdcard/raw.data",m_fmd.getData());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                    String name = sdf.format(new Date()) + "_finger.bmp";
                    Globals.generateBmp_NEW(m_bitmap,name,applContext);
                    Log.i("generateBmp", " se genero la imagen:" +name );
                    vResul="se creo el obj m_fmd";
                }
            }
            catch (Exception e)
            {
                vResul = e.toString();
                Log.w("UareUSampleJava", "Engine error: " + e.toString());
            }

        }
        catch (Exception e)
        {
            Log.i(TAG, "excepcion: "+e.getMessage() );
            vResul="error reader";
            onBackPressed();
        }
        onBackPressed();
        return  vResul;
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

    public String   initFingerDP(Context applContext){
        Log.i(TAG, "initFingerDP: 31 ini" );
        m_deviceName="sin data";
        try {

            readers = UareUGlobal.GetReaderCollection(applContext);
            Log.i(TAG, "initFingerDP: 36" );
            readers.GetReaders();
            if (readers.size()==0)
            {
                m_deviceName="Dispositivo no reconocido";
                return m_deviceName;
            }
            Log.i(TAG, "cantidad reader:" + readers.size() );
            Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().name);

            Log.i(TAG,"NAME READER:"+readers.get(0).GetDescription().id.product_name);
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
            onBackPressed();
        }
        catch (Exception e)
        {
            Log.i(TAG, "excepcion: "+e.getMessage() );
            m_deviceName="error reader:" +e.getMessage();
        }
        return  m_deviceName;
    }
}
