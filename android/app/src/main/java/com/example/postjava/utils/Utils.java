package com.example.postjava.utils;


import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {
    public static String obtenerFechaHoraActual() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        String currentDateandTime = simpleDateFormat.format( new Date());
        return currentDateandTime;
    }

}
