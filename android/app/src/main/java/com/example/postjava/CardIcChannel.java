package com.example.postjava;



import android.app.ProgressDialog;
import android.preference.PreferenceFragment;

import androidx.annotation.StringRes;

import com.example.postjava.utils.DialogUtils;
import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkData;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.card.CardInfoEntity;
import com.zcs.sdk.card.CardReaderManager;
import com.zcs.sdk.card.CardReaderTypeEnum;
import com.zcs.sdk.card.CardSlotNoEnum;
import com.zcs.sdk.card.ICCard;
import com.zcs.sdk.listener.OnSearchCardListener;
import com.zcs.sdk.util.StringUtils;

public class CardIcChannel extends PreferenceFragment {
    private DriverManager mDriverManager = DriverManager.getInstance();
    private CardReaderManager mCardReadManager = mDriverManager.getCardReadManager();
    private ICCard mICCard;
    private static final String TAG = "CardIcChannel";
    boolean isM1 = false;
    boolean isMfPlus = false;

    private static final int READ_TIMEOUT = 60 * 1000;
    private ProgressDialog mProgressDialog;

    private void searchICCard() {
        showSearchCardDialog(R.string.waiting, R.string.msg_ic_card);
        mCardReadManager.cancelSearchCard();
        mCardReadManager.searchCard(CardReaderTypeEnum.IC_CARD, READ_TIMEOUT, mICCardSearchCardListener);
    }

    private OnSearchCardListener mICCardSearchCardListener = new OnSearchCardListener() {
        @Override
        public void onCardInfo(CardInfoEntity cardInfoEntity) {
            mProgressDialog.dismiss();
            readICCard();
        }
        @Override
        public void onError(int i) {
            mProgressDialog.dismiss();
            showReadICCardErrorDialog(i);
        }
        @Override
        public void onNoCard(CardReaderTypeEnum cardReaderTypeEnum, boolean b) {
        }
    };
    public static final byte[] APDU_SEND_IC = {0x00, (byte) 0xA4, 0x04, 0x00, 0x0E, 0x31, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0X00};
    private void readICCard() {
        ICCard icCard = mCardReadManager.getICCard();
        int result = icCard.icCardReset(CardSlotNoEnum.SDK_ICC_USERCARD);
        if (result == SdkResult.SDK_OK) {
            int[] recvLen = new int[1];
            byte[] recvData = new byte[300];
            result = icCard.icExchangeAPDU(CardSlotNoEnum.SDK_ICC_USERCARD, APDU_SEND_IC, recvData, recvLen);
            if (result == SdkResult.SDK_OK) {
                final String apduRecv = StringUtils.convertBytesToHex(recvData).substring(0,
                        recvLen[0] * 2);
                CardFragment.this.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        DialogUtils.show(mProgressDialog.getOwnerActivity(), "Read IC card result", apduRecv);
                    }
                });
            } else {
                showReadICCardErrorDialog(result);
            }
        } else {
            showReadICCardErrorDialog(result);
        }
        icCard.icCardPowerDown(CardSlotNoEnum.SDK_ICC_USERCARD);
    }
    private void showReadICCardErrorDialog(final int errorCode) {
        CardFragment.this.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                DialogUtils.show(getActivity(), "Read IC card failed", "Error code = " + errorCode);
            }
        });
    }
        }


