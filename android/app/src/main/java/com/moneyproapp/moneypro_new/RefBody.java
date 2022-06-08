package com.moneyproapp.moneypro_new;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class RefBody {

    @SerializedName("data")
    @Expose
    private String refIdToDecrypt;
    public String getrefIdDecrypt() {
        return refIdToDecrypt;
    }
    public void setrefIdDecrypt(String refIdToDecrypt) {
        this.refIdToDecrypt = refIdToDecrypt;
    }
}
