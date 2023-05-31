package com.example.postjava;



import android.os.Handler;
import android.os.Looper;

import android.util.Log;

import androidx.annotation.StringRes;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.card.CardInfoEntity;
import com.zcs.sdk.card.CardReaderManager;
import com.zcs.sdk.card.CardReaderTypeEnum;
import com.zcs.sdk.card.CardSlotNoEnum;
import com.zcs.sdk.card.ICCard;
import com.zcs.sdk.card.MagCard;
import com.zcs.sdk.emv.EmvHandler;
import com.zcs.sdk.emv.OnEmvListener;
import com.zcs.sdk.listener.OnSearchCardListener;
import com.zcs.sdk.util.StringUtils;

import io.flutter.plugin.common.EventChannel;

public class CardIcChannel implements EventChannel.StreamHandler {

    private static final String TAG = "CardFragment";
    private static final String KEY_IC_CARD = "IC_card_key";
    private static final int READ_TIMEOUT = 1 * 1000;
    private DriverManager mDriverManager;
    private CardReaderManager mCardReadManager;
    private ICCard icCard;
    private MagCard magCard;


    private String infoCardTxt = "";
    private EventChannel.EventSink cardEventSink;
    private int count = 1;
    private int maxcount = 2;
    private Handler mHandler = new Handler(Looper.getMainLooper());
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {

            if (count > maxcount) {

                if (cardEventSink != null) {

                    cardEventSink.endOfStream();
                }

                onCancel(null);
            } else {
                if (cardEventSink == null) {

                } else {
                    if (infoCardTxt.isEmpty()) {

                    } else {
                        cardEventSink.success(infoCardTxt);
                    }
                }
            }
            count++;
            if (count < maxcount) {
                mCardReadManager.searchCard(CardReaderTypeEnum.IC_CARD, READ_TIMEOUT, mICCardSearchCardListener);
            } else {
                if (cardEventSink != null) {
                    cardEventSink.endOfStream();
                }
                onCancel(null);
            }
            mHandler.postDelayed(this, 2000);
        }
    };

    public void initCardID() {

        mDriverManager = DriverManager.getInstance();
        mCardReadManager = mDriverManager.getCardReadManager();

    }

    public void initMagnetCard() {
        mDriverManager = DriverManager.getInstance();
        mCardReadManager = mDriverManager.getCardReadManager();
    }

    public void searchICCard() {
        count = 1;
        maxcount = 3;
        initCardID();
        infoCardTxt = "";
        mCardReadManager.cancelSearchCard();
        mHandler.removeCallbacks(runnable);
        runnable.run();
    }

    private OnSearchCardListener mICCardSearchCardListener = new OnSearchCardListener() {
        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            readICCard();
        }

        @Override
        public void onError(int i) {
            showReadICCardErrorDialog(i);
        }

        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
        }
    };

    public static final byte[] APDU_SEND_IC = {0x00, (byte) 0xA4, 0x04, 0x00, 0x0E, 0x31, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0X00};

    public void testByte() {
        String _TAG = "testByte";
        int[] trecvLen = new int[1];
        byte[] trecvData = new byte[300];
        //Command APDU : 00 B2 01 0C 00
        byte[] tAPDU_aid = {0x00, (byte) 0xB2, 0x01, 0x0C, 0x00};
        int result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU_aid, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "157 no tiene data");
            //return;
        }
        Log.d("testByte", StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));

        //Command APDU : 00 B2 02 0C 00
        byte[] tAPDU = {0x00, (byte) 0xB2, 0x02, 0x0C, 0x00};
        result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "167 no tiene data");
            //return;
        }
        Log.d("testByte", StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));

        //Command APDU : 00 A4 04 00 05 A0 00 00 00 00 00
        byte[] tAPDU1 = {0x00, (byte) 0xA4, 0x04, 0x00, 0x05, (byte) 0xA0, 0x00, 0x00, 0x00, 0x00, 0x00};
        result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU1, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "167 no tiene data");
            //return;
        }
        Log.d("testByte", StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));

        //Command APDU : 80 A8 00 00 02 83 00 00
        byte[] tAPDU2 = {(byte) 0x80, (byte) 0xA8, 0x00, 0x00, 0x02, (byte) 0x83, 0x00, 0x00};
        result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU2, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "167 no tiene data");
            //return;
        }
        Log.d("testByte", StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));

//Command APDU : 00 B2 01 0C 00
        byte[] tAPDU3 = {0x00, (byte) 0xB2, 0x01, 0x0C, 0x00};
        result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU3, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "167 no tiene data");
            //return;
        }
        Log.d("testByte", "tAPDU3: " + StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));

//Command APDU : 00 B2 01 14 00
        byte[] tAPDU4 = {0x00, (byte) 0xB2, 0x01, 0x14, 0x00};
        result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU4, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK) {
            Log.d(_TAG, "167 no tiene data");
            //return;
        }
        Log.d("testByte", "tAPDU4: " + StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));
    }

    public void testByte2() {
        String _TAG = "testByte";
        try {
            int[] trecvLen = new int[1];
            byte[] trecvData = new byte[300];


//  obtiene codigo paso 1
            byte[] tAPDU = {0x00, (byte) 0xA4, 0x04, 0x00};
            byte[] res1 = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU);
            Log.d(_TAG, "tAPDU: " + StringUtils.convertBytesToHex(res1));
            //6f418408a000000003000000a535732f06072a864886fc6b01600c060a2a864886fc6b02020101630906072a864886fc6b03640b06092a864886fc6b0402159f6501ff9000

            // obtiene codigo 2
            byte[] tAPDU2 = {0x00, (byte) 0xC0, 0x00, 0x00};
            byte[] res2 = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU2);
            Log.d(_TAG, "tAPDU2: " + StringUtils.convertBytesToHex(res2));

            // obtiene codigo 3
            byte[] tAPDU3 = {(byte) 0x80, (byte) 0xA8, 0x00, 0x00, (byte) 0x83, 0x00, 0x0};
            byte[] res3 = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU3);
            Log.d(_TAG, "tAPDU3: " + StringUtils.convertBytesToHex(res3));

            // obtiene codigo 4
            byte[] tAPDU4 = {0x00, (byte) 0xC0, 0x00, 0x00};
            byte[] res4 = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU4);
            Log.d(_TAG, "tAPDU4: " + StringUtils.convertBytesToHex(res4));


            //PASO1 Command APDU : 00 A4 00 00 00
            //byte[] tAPDU_aid = {0x00, (byte)0xA4, 0x04, 0x00, (byte)0xA0,0x00,0x00,0x00,0x04,0x10,0x10,0x00};
 /*       byte[] tAPDU_aid = {0x00, (byte)0xA4, 0x04, 0x00};
        int result= icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, tAPDU_aid, trecvData, trecvLen);
        if (result != SdkResult.SDK_OK)
        {
            Log.d(_TAG,"157 no tiene data");
            //return;
        }
        Log.d(_TAG,"tAPDU_aid: "+ StringUtils.convertBytesToHex(trecvData).substring(0, trecvData[0] * 2));
*/


        } catch (Exception e) {
            Log.d(_TAG, "Exception: " + e.getMessage());
        }
    }

    private void readICCard() {
        //Log.d("readICCard", "readICCard: 106");
        icCard = mCardReadManager.getICCard();
        //Log.d("readICCard", "readICCard: 115");
        int result = icCard.icCardReset(CardSlotNoEnum.SDK_ICC_USERCARD);
        //Log.d("readICCard", "117");
        if (result == SdkResult.SDK_OK) {
            //  Log.d("readICCard", "119");
            int[] recvLen = new int[1];
            byte[] recvData = new byte[300];
            //result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, APDU_SEND_IC, recvData, recvLen);
            result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, APDU_SEND_IC, recvData, recvLen);
            //Log.d("readICCard", "123");
            if (result == SdkResult.SDK_OK) {
                //Log.d("readICCard recvData", recvData.toString());
                //Log.d("readICCard", StringUtils.convertBytesToHex(recvData));
                final String apduRecv = StringUtils.convertBytesToHex(recvData).substring(0, recvLen[0] * 2);
                //  Log.d("readICCard", "apduRecv===>: "+apduRecv);
                infoCardTxt = apduRecv;
                testByte2();
                //cardEventSink.success(apduRecv);
            } else {
                showReadICCardErrorDialog(result);
                //Log.d("readICCard", "130");
            }
        } else {
            showReadICCardErrorDialog(result);
            //Log.d("readICCard", "134");
        }
        icCard.icCardPowerDown(CardSlotNoEnum.SDK_ICC_USERCARD);
       /* Log.d("readICCard", "137");
        if(cardEventSink!=null) {
            Log.d("readICCard", "cardEventSink");
            cardEventSink.endOfStream();
        }*/
    }

    private void showReadICCardErrorDialog(final int errorCode) {
        //Log.d(TAG, "showReadICCardErrorDialog: " + errorCode);
        //cardEventSink.success("error: "+errorCode);
        if (cardEventSink != null) {
            //  Log.d("readICCard", "cardEventSink");
            //cardEventSink.endOfStream();
        }
        mCardReadManager.cancelSearchCard();
    }

    private void showSearchCardDialog(@StringRes int title, @StringRes int msg) {
        //Log.d(TAG, "showSearchCardDialog: 90" + title);
        mCardReadManager.cancelSearchCard();
        //Log.d(TAG, "showSearchCardDialog: 90" + title);
    }

    private static String cardInfoToString(CardInfoEntity cardInfoEntity) {
        if (cardInfoEntity == null) {
            //  Log.d("cardInfoToString", "es null ");
            return null;
        }
        //Log.d("cardInfoToString", "StringBuilder inicial ");
        StringBuilder sb = new StringBuilder();
        sb.append("Resultcode:\t" + cardInfoEntity.getResultcode() + "\n")
                .append(cardInfoEntity.getCardExistslot() == null ? "" : "Card type:\t" + cardInfoEntity.getCardExistslot().name() + "\n")
                .append(cardInfoEntity.getCardNo() == null ? "" : "Card no:\t" + cardInfoEntity.getCardNo() + "\n")
                .append(cardInfoEntity.getRfCardType() == 0 ? "" : "Rf card type:\t" + cardInfoEntity.getRfCardType() + "\n")
                .append(cardInfoEntity.getRFuid() == null ? "" : "RFUid:\t" + new String(cardInfoEntity.getRFuid()) + "\n")
                .append(cardInfoEntity.getAtr() == null ? "" : "Atr:\t" + cardInfoEntity.getAtr() + "\n")
                .append(cardInfoEntity.getTk1() == null ? "" : "Track1:\t" + cardInfoEntity.getTk1() + "\n")
                .append(cardInfoEntity.getTk2() == null ? "" : "Track2:\t" + cardInfoEntity.getTk2() + "\n")
                .append(cardInfoEntity.getTk3() == null ? "" : "Track3:\t" + cardInfoEntity.getTk3() + "\n")
                .append(cardInfoEntity.getExpiredDate() == null ? "" : "expiredDate:\t" + cardInfoEntity.getExpiredDate() + "\n")
                .append(cardInfoEntity.getServiceCode() == null ? "" : "serviceCode:\t" + cardInfoEntity.getServiceCode());
        //Log.d("cardInfoToString", "StringBuilder sb: ==> "+sb);
        return sb.toString();
    }


    /* tarjeta magnetica*/
    public void searchMagnetCard() {
        //Log.d("MagnetCard", "searchMagnetCard: INICIAL");
        initCardID();
        mCardReadManager.cancelSearchCard();
        mCardReadManager.searchCard(CardReaderTypeEnum.MAG_CARD, READ_TIMEOUT, mMagnetCardSearchCardListener);
        //Log.d("MagnetCard", "searchMagnetCard: 64");
    }

    private OnSearchCardListener mMagnetCardSearchCardListener = new OnSearchCardListener() {
        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            //Log.d("MagnetCard", "onCardInfo: mMagnetCardSearchCardListener");
            readMagnetCard();


            //  Log.d("MagnetCard", cardInfoToString(cardInfoEntity));
            //Log.d("MagnetCard", "onCardInfo: mMagnetCardSearchCardListener");
        }

        @Override
        public void onError(int i) {
            //Log.d("MagnetCard", "onError: mMagnetCardSearchCardListener");
            showReadICCardErrorDialog(i);
        }

        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
            //Log.d("MagnetCard", "onNoCard: cardReaderTypeEnum: "+cardReaderTypeEnum );
            //Log.d("MagnetCard", "onNoCard: b: "+ Utils.obtenerFechaHoraActual());

        }
    };

    private void readMagnetCard() {
        Log.d("MagnetCard", "readMagnetCard: 182");
        magCard = mCardReadManager.getMAGCard();
        final CardInfoEntity cardInfoEntity = magCard.getMagReadData();
        if (cardInfoEntity.getResultcode() == SdkResult.SDK_OK) {
            cardInfoToString(cardInfoEntity);
        } else {
            showReadICCardErrorDialog(cardInfoEntity.getResultcode());
        }
        magCard.magCardClose();
        Log.d("MagnetCard", "readMagnetCard: 191");
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Log.i("event", "onListen: ");
        cardEventSink = eventSink;
        //mCardReadManager.searchCard(CardReaderTypeEnum.IC_CARD, READ_TIMEOUT, mICCardSearchCardListener);
        //runnable.run();
    }

    @Override
    public void onCancel(Object o) {
        Log.d("event", "onCancel 216");
        cardEventSink = null;
        mCardReadManager.cancelSearchCard();
        mHandler.removeCallbacks(runnable);
        mHandler.removeCallbacksAndMessages(null);
    }

    public void disposeCardIc() {
        Log.d("disposeCardIc", "close 223");
        cardEventSink = null;
        Log.d("disposeCardIc", "close 225");
        if(mCardReadManager!=null)
        mCardReadManager.closeCard();
        runnable = null;
        mHandler.removeCallbacks(runnable);
        mHandler.removeCallbacksAndMessages(null);
    }
}
