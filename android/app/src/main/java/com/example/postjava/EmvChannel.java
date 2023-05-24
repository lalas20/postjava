package com.example.postjava;

import android.os.FileUtils;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.card.CardInfoEntity;
import com.zcs.sdk.card.CardReaderManager;
import com.zcs.sdk.card.CardReaderTypeEnum;
import com.zcs.sdk.card.CardSlotNoEnum;
import com.zcs.sdk.card.ICCard;
import com.zcs.sdk.emv.EmvData;
import com.zcs.sdk.emv.EmvHandler;
import com.zcs.sdk.emv.EmvTermParam;
import com.zcs.sdk.emv.EmvTransParam;
import com.zcs.sdk.emv.OnEmvListener;
import com.zcs.sdk.listener.OnSearchCardListener;
import com.zcs.sdk.util.StringUtils;

import java.io.File;
import java.io.IOException;

import io.flutter.plugin.common.EventChannel;

public class EmvChannel implements EventChannel.StreamHandler {
    private EmvHandler emvHandler;
    private int iRet;
    CardReaderTypeEnum realCardType;
    private DriverManager mDriverManager = DriverManager.getInstance();
    private CardReaderManager mCardReadManager;
    private ICCard mICCard;
    private String txtPanExp= "";
    private static final int READ_TIMEOUT = 1 * 1000;
    private int count = 1;
    private int maxcount = 2;
    private EventChannel.EventSink EmvEventSink;
    private Handler mHandler = new Handler(Looper.getMainLooper());
    private Runnable runnable = new Runnable() {
    public void run() {
        Log.i("runnable", "run: 42");
        if (count > maxcount) {
            Log.i("runnable", "count > maxcount");
            if (EmvEventSink != null) {
                Log.i("runnable", "EmvEventSink.endOfStream()");
                EmvEventSink.endOfStream();
            }
            Log.i("runnable", "onCancel");
            onCancel(null);
        } else {
            if (EmvEventSink == null) {
                Log.i("runnable", "EmvEventSink == null");

            } else {
                if (txtPanExp.isEmpty()) {
                    Log.i("runnable", "txtPanExp.isEmpty()");
                } else {
                    Log.i("runnable", "txtPanEx: " + txtPanExp);
                    EmvEventSink.success(txtPanExp);
                }
            }
        }
        count++;
        Log.i("runnable", "count: " + count);
        if (count < maxcount) {
            Log.i("runnable", "count < maxcount");
            mCardReadManager.searchCard(CardReaderTypeEnum.IC_CARD, READ_TIMEOUT, mListener);

        } else {
            if (EmvEventSink != null) {
                Log.i("runnable", "EmvEventSink != null" + count);
                EmvEventSink.endOfStream();
            }
            onCancel(null);
        }
        Log.i("runnable", "postDelayed");
        mHandler.postDelayed(this, 2000);
    }
};


    void initSdk() {
        // Config the SDK base info
        mCardReadManager = mDriverManager.getCardReadManager();
        mICCard = mCardReadManager.getICCard();
        emvHandler = EmvHandler.getInstance();
        searchCard( CardReaderTypeEnum.IC_CARD);
    }

     void searchCard(final CardReaderTypeEnum cardType) {
         count = 1;
         maxcount = 3;
         txtPanExp = "";
        mCardReadManager.cancelSearchCard();
        mHandler.removeCallbacks(runnable);
        runnable.run();
        //mCardReadManager.searchCard(cardType, 0, mListener);

        Log.i("searchCard","Name: " + cardType.name() + "....");
    }
    OnSearchCardListener mListener = new OnSearchCardListener() {
        @Override
        public void onError(int resultCode) {
            mCardReadManager.closeCard();
        }

        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            realCardType = cardInfoEntity.getCardExistslot();

            Log.i("onCardInfo", " Deleted card + realCardType.name()");
            switch (realCardType) {
                case IC_CARD:
                    readIc();
                    break;
                default:
                    break;
            }
        }

        @Override
        public void onNoCard(CardReaderTypeEnum arg0, boolean arg1) {
        }
    };
    void readIc() {
        iRet = mICCard.icCardReset(CardSlotNoEnum.SDK_ICC_USERCARD);
        if (iRet != 0) {
            Log.i("readIc", "ic reset error ");
            return;
        }
        emv(realCardType);
    }


    private void emv(CardReaderTypeEnum cardType) {
        // 1. copy aid and capk to '/sdcard/emv/' as the default aid and capk
        if (!new File(EmvTermParam.emvParamFilePath).exists()) {
            Object obj=new File(EmvTermParam.emvParamFilePath).canRead();

            //FileUtils.doCopy(EmvActivity.this, "emv", EmvTermParam.emvParamFilePath);
            Log.d("met EMV", "emv: no existe archivo");
        }

        // 2. set params
        final EmvTransParam emvTransParam = new EmvTransParam();
        if (cardType == CardReaderTypeEnum.IC_CARD) {
            emvTransParam.setTransKernalType(EmvData.KERNAL_EMV_PBOC);
        } else if (cardType == CardReaderTypeEnum.RF_CARD) {
            emvTransParam.setTransKernalType(EmvData.KERNAL_CONTACTLESS_ENTRY_POINT);
        }
        emvHandler.transParamInit(emvTransParam);
        final EmvTermParam emvTermParam = new EmvTermParam();
        emvHandler.kernelInit(emvTermParam);

        // 3. add aid or capk
        //emvHandler.delAllApp();
        //emvHandler.delAllCapk();
        //loadVisaAIDs(emvHandler);
        //loadMasterCardCapks(emvHandler);

        // 4. transaction
        byte[] pucIsEcTrans = new byte[1];
        byte[] pucBalance = new byte[6];
        byte[] pucTransResult = new byte[1];

        OnEmvListener onEmvListener = new OnEmvListener() {
            @Override
            public int onSelApp(String[] appLabelList) {
                Log.d("Debug", "onSelApp");
                return iRet;
            }

            @Override
            public int onConfirmCardNo(String cardNo) {
                Log.d("OnEmvListener", "onConfirmCardNo");
                String[] track2 = new String[1];
                final String[] pan = new String[1];
                emvHandler.getTrack2AndPAN(track2, pan);
                int index = 0;
                if (track2[0].contains("D")) {
                    index = track2[0].indexOf("D") + 1;
                } else if (track2[0].contains("=")) {
                    index = track2[0].indexOf("=") + 1;
                }
                final String exp = track2[0].substring(index, index + 4);
                Log.d("onConfirmCardNo", "pan: "+ pan[0]);
                Log.d("onConfirmCardNo", "exp: "+ exp);
                txtPanExp=pan[0] +" :: "+exp;
                return 0;
            }

            @Override
            public int onInputPIN(byte pinType) {
                // 1. open the secret pin pad to get pin block
                // 2. send the pinBlock to emv kernel
                if (emvTransParam.getTransKernalType() == EmvData.KERNAL_CONTACTLESS_ENTRY_POINT) {
                    String[] track2 = new String[1];
                    final String[] pan = new String[1];
                    emvHandler.getTrack2AndPAN(track2, pan);
                    int index = 0;
                    if (track2[0].contains("D")) {
                        index = track2[0].indexOf("D") + 1;
                    } else if (track2[0].contains("=")) {
                        index = track2[0].indexOf("=") + 1;
                    }
                    final String exp = track2[0].substring(index, index + 4);
                    Log.d("onInputPIN", "pan: "+ pan[0]);
                    Log.d("onInputPIN", "exp: "+ exp);
                    txtPanExp=pan[0] +" :: "+exp;
                }
                Log.d("Debug", "onInputPIN");
                int iRet = 0;
                /*iRet = inputPIN(pinType);
                Log.d("Debug", "iRet=" + iRet);
                if (iRet == EmvResult.EMV_OK) {
                    emvHandler.setPinBlock(mPinBlock);
                }*/
                return iRet;
            }

            @Override
            public int onCertVerify(int certType, String certNo) {
                Log.d("OnEmvListener", "onCertVerify");
                return 0;
            }

            @Override
            public byte[] onExchangeApdu(byte[] send) {
                Log.d("OnEmvListener", "onExchangeApdu");
                if (realCardType == CardReaderTypeEnum.IC_CARD) {
                    return mICCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, send);
                }
                //else if (realCardType == CardReaderTypeEnum.RF_CARD) {return mRFCard.rfExchangeAPDU(send);}
                return null;
            }

            @Override
            public int onlineProc() {
                // 1. assemble the authorisation request data and send to bank by using get 'emvHandler.getTlvData()'
                // 2. separateOnlineResp to emv kernel
                // 3. return the callback ret
                Log.d("Debug", "onOnlineProc");
                byte[] authRespCode = new byte[3];
                byte[] issuerResp = new byte[512];
                int[] issuerRespLen = new int[1];
                int iSendRet = emvHandler.separateOnlineResp(authRespCode, issuerResp, issuerRespLen[0]);
                Log.d("OnEmvListener", "onlineProc separateOnlineResp iSendRet=" + iSendRet);
                return 0;
            }

        };
        Log.d("met EMV", "emv: Emv Trans start...");
        // for the emv result, plz refer to emv doc.
        int ret = emvHandler.emvTrans(emvTransParam, onEmvListener, pucIsEcTrans, pucBalance, pucTransResult);
        Log.d("met EMV", "emv: Emv trans end, ret = " + ret);

        String str = "Decline";
        if (pucTransResult[0] == EmvData.APPROVE_M) {
            str = "Approve";
        } else if (pucTransResult[0] == EmvData.ONLINE_M) {
            str = "Online";
        } else if (pucTransResult[0] == EmvData.DECLINE_M) {
            str = "Decline";
        }
        Log.d("met EMV", "Emv trans result = " + pucTransResult[0] + ", " + str);
        if (ret == 0) {
            getEmvData();
        }
        mCardReadManager.closeCard();
    }

    private void getEmvData() {
        byte[] field55 = emvHandler.packageTlvList(tags);
        Log.d("getEmvData", "Filed55: " + StringUtils.convertBytesToHex(field55));
    }
    int[] tags = {0x9F26,0x9F27,0x9F10,0x9F37,0x9F36,0x95,0x9A,0x9C,0x9F02,0x5F2A,0x82,0x9F1A,0x9F03,0x9F33,0x9F34,0x9F35,0x9F1E,0x84,0x9F09,0x9F41,0x9F63,0x5F24};
    public void disposeCardIc() {
        Log.d("disposeCardIc", "close 223");
        EmvEventSink = null;
        Log.d("disposeCardIc", "close 225");
        mCardReadManager.closeCard();
        runnable = null;
        mHandler.removeCallbacks(runnable);
        mHandler.removeCallbacksAndMessages(null);
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Log.i("even", "onListen: ");
        EmvEventSink=eventSink;

    }

    @Override
    public void onCancel(Object o) {
        Log.d("event", "onCancel 216");
        EmvEventSink = null;
        mCardReadManager.cancelSearchCard();
        mHandler.removeCallbacks(runnable);
        mHandler.removeCallbacksAndMessages(null);
    }
}
