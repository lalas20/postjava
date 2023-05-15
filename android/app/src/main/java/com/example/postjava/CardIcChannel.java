package com.example.postjava;



import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.preference.Preference;
import android.preference.PreferenceFragment;

import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import com.example.postjava.utils.DialogUtils;
import com.example.postjava.utils.Utils;
import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkData;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.card.CardInfoEntity;
import com.zcs.sdk.card.CardReaderManager;
import com.zcs.sdk.card.CardReaderTypeEnum;
import com.zcs.sdk.card.CardSlotNoEnum;
import com.zcs.sdk.card.ICCard;
import com.zcs.sdk.card.MagCard;
import com.zcs.sdk.card.RfCard;
import com.zcs.sdk.listener.OnSearchCardListener;
import com.zcs.sdk.util.StringUtils;

public class CardIcChannel {

    private static final String TAG = "CardFragment";
    private static final String KEY_IC_CARD = "IC_card_key";
    private static final int READ_TIMEOUT = 10 * 1000;
    private DriverManager mDriverManager;
    private CardReaderManager mCardReadManager;

    public void initCardID(){
        Log.d(TAG, "initCardID: 42");
        mDriverManager = DriverManager.getInstance();
        mCardReadManager = mDriverManager.getCardReadManager();
        Log.d(TAG, "initCardID: 45");
    }
    public void initMagnetCard(){
        Log.d(TAG, "initMagnetCard: 42");
        mDriverManager = DriverManager.getInstance();
        mCardReadManager = mDriverManager.getCardReadManager();
        Log.d(TAG, "initCardID: 45");
    }
    public void searchICCard() {
        Log.d(TAG, "searchICCard: INICIAL");
        initCardID();
        mCardReadManager.cancelSearchCard();
        mCardReadManager.searchCard(CardReaderTypeEnum.IC_CARD, READ_TIMEOUT, mICCardSearchCardListener);
        Log.d(TAG, "searchICCard: 64");
    }

    private OnSearchCardListener mICCardSearchCardListener = new OnSearchCardListener() {
        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            Log.d("IC CARD", "onCardInfo: 70");
            readICCard();


            Log.d("IC CARD", cardInfoToString(cardInfoEntity));
            Log.d("IC CARD", "onCardInfo: 92");
        }

        @Override
        public void onError(int i) {
            Log.d("IC CARD", "onError: 77");
            showReadICCardErrorDialog(i);
        }

        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
            Log.d("IC CARD", "onNoCard: cardReaderTypeEnum: "+cardReaderTypeEnum );
            Log.d("IC CARD", "onNoCard: b: "+ Utils.obtenerFechaHoraActual());
           // mCardReadManager.cancelSearchCard();
        }
    };

    public static final byte[] APDU_SEND_IC = {0x00, (byte) 0xA4, 0x04, 0x00, 0x0E, 0x31, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0X00};
    private void readICCard() {
        Log.d("readICCard", "readICCard: 106");
        ICCard icCard = mCardReadManager.getICCard();
        Log.d("readICCard", "readICCard: 115");
        int result = icCard.icCardReset(CardSlotNoEnum.SDK_ICC_USERCARD);
        Log.d("readICCard", "117");
        if (result == SdkResult.SDK_OK) {
            Log.d("readICCard", "119");
            int[] recvLen = new int[1];
            byte[] recvData = new byte[300];
            result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, APDU_SEND_IC, recvData, recvLen);
            Log.d("readICCard", "123");
            if (result == SdkResult.SDK_OK) {
                Log.d("readICCard", "125");
                Log.d("readICCard", StringUtils.convertBytesToHex(recvData));
                final String apduRecv = StringUtils.convertBytesToHex(recvData).substring(0, recvLen[0] * 2);
                Log.d("readICCard", "apduRecv===>: "+apduRecv);
            } else {
                showReadICCardErrorDialog(result);
                Log.d("readICCard", "130");
            }
        } else {
            showReadICCardErrorDialog(result);
            Log.d("readICCard", "134");
        }
        icCard.icCardPowerDown(CardSlotNoEnum.SDK_ICC_USERCARD);
        Log.d("readICCard", "137");
    }
    private void showReadICCardErrorDialog(final int errorCode) {
        Log.d(TAG, "showReadICCardErrorDialog: " + errorCode);
    }
    private void showSearchCardDialog(@StringRes int title, @StringRes int msg) {
        Log.d(TAG, "showSearchCardDialog: 90" + title);
                mCardReadManager.cancelSearchCard();
        Log.d(TAG, "showSearchCardDialog: 90" + title);
    }
    private static String cardInfoToString(CardInfoEntity cardInfoEntity) {
        if (cardInfoEntity == null){
            Log.d("cardInfoToString", "es null ");
            return null;
        }
        Log.d("cardInfoToString", "StringBuilder inicial ");
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
        Log.d("cardInfoToString", "StringBuilder sb: ==> "+sb);
        return sb.toString();
    }


    /* tarjeta magnetica*/
    public void searchMagnetCard() {
        Log.d("MagnetCard", "searchMagnetCard: INICIAL");
        initCardID();
        mCardReadManager.cancelSearchCard();
        mCardReadManager.searchCard(CardReaderTypeEnum.MAG_CARD, READ_TIMEOUT, mMagnetCardSearchCardListener);
        Log.d("MagnetCard", "searchMagnetCard: 64");
    }

    private OnSearchCardListener mMagnetCardSearchCardListener = new OnSearchCardListener() {
        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            Log.d("MagnetCard", "onCardInfo: mMagnetCardSearchCardListener");
            readMagnetCard();


            Log.d("MagnetCard", cardInfoToString(cardInfoEntity));
            Log.d("MagnetCard", "onCardInfo: mMagnetCardSearchCardListener");
        }

        @Override
        public void onError(int i) {
            Log.d("MagnetCard", "onError: mMagnetCardSearchCardListener");
            showReadICCardErrorDialog(i);
        }

        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
            Log.d("MagnetCard", "onNoCard: cardReaderTypeEnum: "+cardReaderTypeEnum );
            Log.d("MagnetCard", "onNoCard: b: "+ Utils.obtenerFechaHoraActual());

        }
    };

    private void readMagnetCard() {
        Log.d("MagnetCard", "readMagnetCard: 182");
        MagCard magCard = mCardReadManager.getMAGCard();
        final CardInfoEntity cardInfoEntity = magCard.getMagReadData();
        if (cardInfoEntity.getResultcode() == SdkResult.SDK_OK) {
            cardInfoToString(cardInfoEntity);
        } else {
            showReadICCardErrorDialog(cardInfoEntity.getResultcode());
        }
        magCard.magCardClose();
        Log.d("MagnetCard", "readMagnetCard: 191");
    }

}



