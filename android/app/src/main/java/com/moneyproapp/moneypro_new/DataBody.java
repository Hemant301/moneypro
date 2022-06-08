package com.moneyproapp.moneypro_new;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class DataBody {
    @SerializedName("data")
    @Expose
    private String textToDecrypt;
    public String getTextToDecrypt() {
        return textToDecrypt;
    }
    public void setTextToDecrypt(String textToDecrypt) {
        this.textToDecrypt = textToDecrypt;
    }
}
