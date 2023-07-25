package com.example.postjava.utils;

import android.graphics.Bitmap;
import android.graphics.Matrix;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class BitmapUtils {
    public BitmapUtils() {
    }

    public void getBmpWith8(byte[] bufferSrc, String imgPath) {
        short var3 = 256;
        short var4 = 360;
        bufferSrc = this.a(bufferSrc);
        byte[] var5 = this.c(var3, var4);
        byte[] var6 = this.b(var3, var4);
        byte[] var7 = this.a(bufferSrc.length, var6.length + var5.length);
        byte[] var8 = new byte[var7.length + var6.length + var5.length + bufferSrc.length];
        System.arraycopy(var7, 0, var8, 0, var7.length);
        System.arraycopy(var6, 0, var8, var7.length, var6.length);
        System.arraycopy(var5, 0, var8, var7.length + var6.length, var5.length);
        System.arraycopy(bufferSrc, 0, var8, var7.length + var6.length + var5.length, bufferSrc.length);
        saveFile(imgPath, var8);
    }

    public static boolean saveFile(String path, byte[] buffer) {
        FileOutputStream var2 = null;
        if (path != null) {
            boolean var4;
            try {
                File var3 = new File(path);
                if (var3 != null && var3.exists()) {
                    var3.delete();
                }

                var2 = new FileOutputStream(path);
                var2.write(buffer);
                var4 = true;
            } catch (Exception var14) {
                var14.printStackTrace();
                return false;
            } finally {
                try {
                    var2.close();
                } catch (IOException var13) {
                    var13.printStackTrace();
                }

            }

            return var4;
        } else {
            return false;
        }
    }

    private byte[] a(byte[] var1) {
        if (var1 == null) {
            return null;
        } else {
            byte[] var2 = new byte[var1.length];
            short var3 = 256;
            short var4 = 360;

            for(int var5 = 0; var5 < var4; ++var5) {
                System.arraycopy(var1, (var4 - var5 - 1) * var3, var2, var5 * var3, var3);
            }

            return var2;
        }
    }

    private byte[] a(int var1, int var2) {
        byte[] var3 = new byte[14];
        int var4 = var2 + var3.length;
        var1 += var4;
        var3[0] = 66;
        var3[1] = 77;
        var3[2] = 0;
        var3[3] = 0;
        var3[4] = (byte)(var1 >> 16);
        var3[5] = (byte)(var1 >> 24);
        var3[6] = 0;
        var3[7] = 0;
        var3[8] = 0;
        var3[9] = 0;
        var3[10] = (byte)(var4 >> 0);
        var3[11] = (byte)(var4 >> 8);
        var3[12] = (byte)(var4 >> 16);
        var3[13] = (byte)(var4 >> 24);
        return var3;
    }

    private byte[] b(int var1, int var2) {
        byte[] var3 = new byte[40];
        int var4 = var3.length;
        var3[0] = (byte)(var4 >> 0);
        var3[1] = (byte)(var4 >> 8);
        var3[2] = (byte)(var4 >> 16);
        var3[3] = (byte)(var4 >> 24);
        var3[4] = (byte)(var1 >> 0);
        var3[5] = (byte)(var1 >> 8);
        var3[6] = (byte)(var1 >> 16);
        var3[7] = (byte)(var1 >> 24);
        var3[8] = (byte)(var2 >> 0);
        var3[9] = (byte)(var2 >> 8);
        var3[10] = (byte)(var2 >> 16);
        var3[11] = (byte)(var2 >> 24);
        var3[12] = 1;
        var3[13] = 0;
        var3[14] = 8;
        var3[15] = 0;
        var3[16] = 0;
        var3[17] = 0;
        var3[18] = 0;
        var3[19] = 0;
        var3[20] = 0;
        var3[21] = 0;
        var3[22] = 0;
        var3[23] = 0;
        var3[24] = -32;
        var3[25] = 76;
        var3[26] = 0;
        var3[27] = 0;
        var3[28] = -32;
        var3[29] = 76;
        var3[30] = 0;
        var3[31] = 0;
        var3[32] = 0;
        var3[33] = 0;
        var3[34] = 0;
        var3[35] = 0;
        var3[36] = 0;
        var3[37] = 0;
        var3[38] = 0;
        var3[39] = 0;
        return var3;
    }

    private byte[] c(int var1, int var2) {
        byte[] var3 = new byte[1024];

        for(int var4 = 0; var4 < 256; ++var4) {
            var3[0 + 4 * var4] = (byte)var4;
            var3[1 + 4 * var4] = (byte)var4;
            var3[2 + 4 * var4] = (byte)var4;
            var3[3 + 4 * var4] = 0;
        }

        return var3;
    }

    public static Bitmap scaleBitmap(Bitmap origin, int newWidth) {
        if (origin == null) {
            return null;
        } else {
            int var2 = origin.getHeight();
            int var3 = origin.getWidth();
            float var4 = (float)newWidth / (float)var3;
            Matrix var5 = new Matrix();
            var5.postScale(var4, var4);
            return Bitmap.createBitmap(origin, 0, 0, var3, var2, var5, false);
        }
    }

    public static Bitmap scaleBitmap(Bitmap origin, int newWidth, int newHeight) {
        if (origin == null) {
            return null;
        } else {
            int var3 = origin.getHeight();
            int var4 = origin.getWidth();
            Matrix var5 = new Matrix();
            if (var4 != newWidth || var3 != newHeight) {
                float var6 = Math.max((float)newWidth * 1.0F / (float)var4, (float)newHeight * 1.0F / (float)var3);
                var5.postScale(var6, var6);
            }

            return Bitmap.createBitmap(origin, 0, 0, var4, var3, var5, false);
        }
    }

    public static Bitmap rotateBitmap(Bitmap bitmap, float degree) {
        if (bitmap == null) {
            return null;
        } else {
            Matrix var2 = new Matrix();
            var2.postRotate(degree);
            return Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), var2, false);
        }
    }
}