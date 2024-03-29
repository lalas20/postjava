/*
 * File: 		Globals.java
 * Created:		2013/05/03
 *
 * copyright (c) 2013 DigitalPersona Inc.
 */

package com.example.postjava.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStreamWriter;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;


import android.graphics.Bitmap;

import com.digitalpersona.uareu.Reader;
import com.digitalpersona.uareu.ReaderCollection;
import com.digitalpersona.uareu.UareUException;
import com.digitalpersona.uareu.UareUGlobal;
import com.digitalpersona.uareu.Reader.Capabilities;
import com.google.gson.Gson;

import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;

public class Globals
{
    public static Reader.ImageProcessing DefaultImageProcessing = Reader.ImageProcessing.IMG_PROC_DEFAULT;
    //public static final Reader.ImageProcessing DefaultImageProcessing = Reader.ImageProcessing.IMG_PROC_PIV;

    public Reader getReader(String name, Context applContext) throws UareUException
    {
        getReaders(applContext);

        for (int nCount = 0; nCount < readers.size(); nCount++)
        {
            if (readers.get(nCount).GetDescription().name.equals(name))
            {
                return readers.get(nCount);
            }
        }
        return null;
    }

    public ReaderCollection getReaders(Context applContext) throws UareUException
    {
        readers = UareUGlobal.GetReaderCollection(applContext);
        readers.GetReaders();
        return readers;
    }

    private ReaderCollection readers = null;
    private static Globals instance;

    static
    {
        instance = new Globals();
    }

    public static Globals getInstance()
    {
        return Globals.instance;
    }

    private static Bitmap m_lastBitmap = null;

    public static void ClearLastBitmap()
    {
        m_lastBitmap = null;
    }

    public static Bitmap GetLastBitmap()
    {
        return m_lastBitmap;
    }

    private static int m_cacheIndex = 0;
    private static int m_cacheSize = 2;
    private static ArrayList<Bitmap> m_cachedBitmaps = new ArrayList<Bitmap>();

    public synchronized static Bitmap GetBitmapFromRaw(byte[] Src, int width, int height)
    {
        byte [] Bits = new byte[Src.length*4];
        int i = 0;
        for(i=0;i<Src.length;i++)
        {
            Bits[i*4] = Bits[i*4+1] = Bits[i*4+2] = (byte)Src[i];
            Bits[i*4+3] = -1;
        }

        Bitmap bitmap = null;
        if (m_cachedBitmaps.size() == m_cacheSize) {
            bitmap = m_cachedBitmaps.get(m_cacheIndex);
        }

        if (bitmap == null) {
            bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            m_cachedBitmaps.add(m_cacheIndex, bitmap);
        } else if (bitmap.getWidth() != width || bitmap.getHeight() != height) {
            bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            m_cachedBitmaps.set(m_cacheIndex, bitmap);
        }
        m_cacheIndex = (m_cacheIndex+1)%m_cacheSize;

        bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(Bits));

        // save bitmap to history to be restored when screen orientation changes
        m_lastBitmap = bitmap;
        return bitmap;
    }

    public static final String QualityToString(Reader.CaptureResult result)
    {
        if(result == null)
        {
            return "";
        }
        if(result.quality == null)
        {
            return "An error occurred";
        }
        switch(result.quality)
        {
            case FAKE_FINGER:         return "Fake finger";
            case NO_FINGER:           return "No finger";
            case CANCELED:            return "Capture cancelled";
            case TIMED_OUT:           return "Capture timed out";
            case FINGER_TOO_LEFT:     return "Finger too left";
            case FINGER_TOO_RIGHT:    return "Finger too right";
            case FINGER_TOO_HIGH:     return "Finger too high";
            case FINGER_TOO_LOW:      return "Finger too low";
            case FINGER_OFF_CENTER:   return "Finger off center";
            case SCAN_SKEWED:         return "Scan skewed";
            case SCAN_TOO_SHORT:      return "Scan too short";
            case SCAN_TOO_LONG:       return "Scan too long";
            case SCAN_TOO_SLOW:       return "Scan too slow";
            case SCAN_TOO_FAST:       return "Scan too fast";
            case SCAN_WRONG_DIRECTION:return "Wrong direction";
            case READER_DIRTY:        return "Reader dirty";
            case GOOD:                return "Image acquired";
            default:                  return "An error occurred";
        }
    }
    public static final int GetFirstDPI(Reader reader)
    {
        Capabilities caps = reader.GetCapabilities();
        return caps.resolutions[0];
    }
    public static final String ConverBase64byte( byte[] src)
    {
        String resul= Base64.encodeToString(src,Base64.DEFAULT);
        return resul;
    }
    public static final String ConverBase64Obj( Object obj) {
        String vresul="";
try {
    Gson gson = new Gson();
    vresul = gson.toJson(obj);
    vresul = Base64.encodeToString(vresul.getBytes(StandardCharsets.UTF_8), Base64.DEFAULT);
        /*Base64.encodeToString(baos.toByteArray(),Base64.DEFAULT);
        ByteArrayOutputStream baos=new ByteArrayOutputStream();
        ObjectOutputStream oos=new ObjectOutputStream(baos);
        oos.writeObject(obj);
        oos.close();
        String resul= Base64.encodeToString(baos.toByteArray(),Base64.DEFAULT);*/

}
catch (Exception e)
{
    vresul="excepcion";
}
return vresul;
    }

 public  static void save2File(String path, byte[] data) {
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
    public static void generateBmp_NEW(Bitmap bmp, String path, Context context) {
            try {
                File dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
                File file = new File(dir,path);
                Log.i("file", "getPath: " + file.getPath());
                //OutputStreamWriter archivo = null;
                FileOutputStream fileOutputStream = new FileOutputStream(file);
                bmp.compress(Bitmap.CompressFormat.PNG,100,fileOutputStream);
                Log.i("fileOutputStream", "fileOutputStream: " );
                fileOutputStream.flush();
                fileOutputStream.close();


                //archivo = new OutputStreamWriter(fileOutputStream);
                Log.i("OutputStreamWriter", "archivo: " );


            }catch (IOException io){
                io.printStackTrace();
            }
    }
    public static Bitmap generateBmp(byte[] buffer, String path) {
        Bitmap var3 = null;

        try {
            BitmapUtils var4 = new BitmapUtils();
            var4.getBmpWith8(buffer, path);
            FileInputStream var5 = new FileInputStream(path);
            var3 = BitmapFactory.decodeStream(var5);
        } catch (Exception var6) {
            var6.printStackTrace();
        }

        return var3;
    }
}
