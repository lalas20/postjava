package com.example.postjava;

import android.app.Dialog;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceFragment;
import android.util.Log;

import androidx.annotation.StringRes;
import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.card.CardInfoEntity;
import com.zcs.sdk.card.CardReaderManager;
import com.zcs.sdk.card.CardReaderTypeEnum;
import com.zcs.sdk.card.CardSlotNoEnum;
import com.zcs.sdk.card.ICCard;
import com.zcs.sdk.listener.OnSearchCardListener;
import com.zcs.sdk.util.StringUtils;

import java.lang.ref.WeakReference;

public class CardChannel extends PreferenceFragment  {

    private static final String TAG = "CardFragment";

    private DriverManager mDriverManager = DriverManager.getInstance();
    private CardReaderManager mCardReadManager = mDriverManager.getCardReadManager();
    private ICCard mICCard;
    private static final int READ_TIMEOUT = 60 * 1000;

    private ProgressDialog mProgressDialog;
    private Dialog mCardInfoDialog;
    boolean ifSearch = true;
    CardReaderTypeEnum mCardType = CardReaderTypeEnum.MAG_IC_RF_CARD;
    private static final byte SLOT_USERCARD = 0x00;
    private static final byte SLOT_PSAM1 = 0x01;
    private static final byte SLOT_PSAM2 = 0x02;
    private static final byte SLOT_PSAM3 = 0x03;
    public static final byte[] APDU_SEND_IC = {0x00, (byte) 0xA4, 0x04, 0x00, 0x0E, 0x31, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0X00};
    public static final byte[] APDU_SEND_RF = {0x00, (byte) 0xA4, 0x04, 0x00, 0x0E, 0x32, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0x00};
    public static final byte[] APDU_SEND_RANDOM = {0x00, (byte) 0x84, 0x00, 0x00, 0x08};
    // 10 06 01 2E 45 76 BA C5 45 2B 01 09 00 01 80 00
    public static final byte[] APDU_SEND_FELICA = {0x10, 0x06, 0x01, 0x2E, 0x45, 0x76, (byte) 0xBA, (byte) 0xC5, 0x45, 0x2B, 0x01, 0x09, 0x00, 0x01, (byte) 0x80, 0x00};
    private static final int MSG_CARD_OK = 2001;
    private static final int MSG_CARD_ERROR = 2002;
    private static final int MSG_CARD_APDU = 2003;
    private static final int MSG_RF_CARD_APDU = 2007;
    private static final int MSG_CARD_M1 = 2004;
    private static final int MSG_CARD_MF_PLUS = 2005;
    private static final int MSG_CARD_FELICA = 2006;
    private static final String KEY_APDU = "APDU";
    private static final String KEY_RF_CARD_TYPE = "RF_CARD_TYPE";
    private Handler mHandler;
    boolean isM1 = false;
    boolean isMfPlus = false;
    boolean isNtag = false;

   void init(){
       //mHandler = new CardHandler(this);
       mCardReadManager = mDriverManager.getCardReadManager();
       mICCard= mCardReadManager.getICCard();
   }

    /**
     * detect card has been removed
     * if it cant be detected, then research card
     */
    void researchICC() {
        try {
            Thread.sleep(150);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        ifSearch = true;
        while (ifSearch) {
            int i = mICCard.getIcCardStatus(CardSlotNoEnum.SDK_ICC_USERCARD);
            if (i == SdkResult.SDK_ICC_NO_CARD) {
                break;
            }
        }
        if (ifSearch) {
            mCardReadManager.searchCard(mCardType, READ_TIMEOUT, mListener);
        }
    }
    void readICCard(CardSlotNoEnum slotNo) {
        int icCardReset = mICCard.icCardReset(slotNo);

        int[] recvLen = new int[1];
        byte[] recvData = new byte[300];
        Log.d(TAG, "readICCard: 94");
        if (icCardReset == SdkResult.SDK_OK) {
            Log.d(TAG, "readICCard: 96");
            int icRes;
            byte[] apdu;
            if (slotNo.getType() == SLOT_PSAM1 || slotNo.getType() == SLOT_PSAM2 || slotNo.getType() == SLOT_PSAM3) {
                apdu = APDU_SEND_RANDOM;
            } else {
                apdu = APDU_SEND_IC;
            }
            Log.d(TAG, "readICCard: 104");
            icRes = mICCard.icExchangeAPDU(slotNo, apdu, recvData, recvLen);
            Log.d(TAG, "readICCard: 106");
            if (icRes == SdkResult.SDK_OK) {
                Log.d(TAG, "readICCard: 108");
                Message msg = Message.obtain();
                msg.what = MSG_CARD_APDU;
                msg.arg1 = icRes;
                msg.obj = StringUtils.convertBytesToHex(recvData).substring(0, recvLen[0] * 2);
                Bundle icBundle = new Bundle();
                icBundle.putString(KEY_APDU, StringUtils.convertBytesToHex(apdu));
                msg.setData(icBundle);

                Log.d(TAG, "readICCard: "+msg.what);
                Log.d(TAG, "readICCard: "+msg.arg1);
                Log.d(TAG, "readICCard: "+msg.obj);


               // mHandler.sendMessage(msg);
            } else {
               // mHandler.sendEmptyMessage(icRes);
                Log.d(TAG, "readICCard: 125");
            }
        } else {
            //mHandler.sendEmptyMessage(icCardReset);
            Log.d(TAG, "readICCard: 128");
        }
        int icCardPowerDown = mICCard.icCardPowerDown(CardSlotNoEnum.SDK_ICC_USERCARD);
        Log.d(TAG, "readICCard: 132");
        if (slotNo.getType() == SLOT_USERCARD) {
            Log.d(TAG, "readICCard: 134");
            researchICC();
        }
    }

    OnSearchCardListener mListener = new OnSearchCardListener() {

        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            Log.d(TAG, "readICCard: 143");
            CardReaderTypeEnum cardType = cardInfoEntity.getCardExistslot();
            Log.d(TAG, "readICCard: 145" + cardType);
            switch (cardType) {
                case RF_CARD:
                    // only can get SdkData.RF_TYPE_A / SdkData.RF_TYPE_B / SdkData.RF_TYPE_FELICA /
                    // SdkData.RF_TYPE_MEMORY_A / SdkData.RF_TYPE_MEMORY_B
                    /*byte rfCardType = cardInfoEntity.getRfCardType();
                    Log.e(TAG, "rfCardType: " + rfCardType);
                    if (isM1) {
                        readM1Card();
                    } else if (isMfPlus) {
                        readMFPlusCard();
                    } else if (isNtag) {
                        readNtag();
                    } else {
                        readRfCard(rfCardType);
                    }*/
                    break;
                case MAG_CARD:
                    //readMagCard();
                    break;
                case IC_CARD:
                    Log.d(TAG, "onCardInfo: ic_card");
                    readICCard(CardSlotNoEnum.SDK_ICC_USERCARD);
                    break;
                case PSIM1:
                    //readICCard(CardSlotNoEnum.SDK_ICC_SAM1);
                    break;
                case PSIM2:
                    //readICCard(CardSlotNoEnum.SDK_ICC_SAM2);
                    break;
                case PSIM3:
                    //readICCard(CardSlotNoEnum.SDK_ICC_SAM3);
                    break;
            }
        }

        @Override
        public void onError(int i) {
            isM1 = false;
            isMfPlus = false;
            isNtag = false;
            //mHandler.sendEmptyMessage(i);
        }

        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
            Log.d(TAG, "readICCard: 191");
        }
    };
    void closeSearch() {
        Log.i(TAG, "closeSearch");
        isNtag = false;
        isM1 = false;
        isMfPlus = false;
        // stop to detect card
        ifSearch = false;
        mCardReadManager.cancelSearchCard();
    }

    @Override
    public void onDestroy() {
        Log.i(TAG, "onDestroy");
        closeSearch();
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        mCardReadManager.closeCard();
        super.onDestroy();
    }




}