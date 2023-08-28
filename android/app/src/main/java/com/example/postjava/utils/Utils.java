package com.example.postjava.utils;


import android.os.Environment;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {
    public static String obtenerFechaHoraActual() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        String currentDateandTime = simpleDateFormat.format( new Date());
        return currentDateandTime;
    }

   public static void writeToLogFile(String logMessage) {
        File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        File logFile = new File(downloadDir, "log.txt");
        try {
            // Crea el archivo si no existe, y abre el BufferedWriter en modo append
            BufferedWriter writer = new BufferedWriter(new FileWriter(logFile, true));
            writer.write(logMessage);
            writer.newLine();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
