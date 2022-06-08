package com.moneyproapp.moneypro_new;


import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class StateBody {

    @SerializedName("stateId")
    @Expose
    private String stateId;

    public String getStateId() {
        return stateId;
    }

    public void setStateId(String stateId) {
        this.stateId = stateId;
    }
    
    @SerializedName("merchant_id")
    @Expose
    private String merchantId;

    public String getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(String merchantId) {
        this.merchantId = merchantId;
    }
    
    @SerializedName("ekycPrimaryKeyId")
    @Expose
    private String ekycPrimaryKeyId;

    public String getEkycPrimaryKeyId() {
        return ekycPrimaryKeyId;
    }

    public void seteKycPrimaryKeyId(String ekycPrimaryKeyId) {
        this.ekycPrimaryKeyId = ekycPrimaryKeyId;
    }
    
    @SerializedName("ekycTxnId")
    @Expose
    private String ekycTxnId;

    public String getekycTxnId() {
        return ekycTxnId;
    }

    public void seteekycTxnId(String ekycTxnId) {
        this.ekycTxnId = ekycTxnId;
    }

    @SerializedName("merchant_Id")
    @Expose
    private String merchant_Id;

    public String getMerchantIdd() {
        return merchant_Id;
    }

    public void setMerchantIdd(String merchant_Id) {
        this.merchant_Id = merchant_Id;
    }

    
    @SerializedName("fingerprintData")
    @Expose
    private String fingerprintData;

    public String getFingerPrintData() {
        return fingerprintData;
    }

    public void setFingerPrintData(String fingerprintData) {
        this.fingerprintData = fingerprintData;
    }
    
    @SerializedName("emailId")
    @Expose
    private String emailId;

    public String getEmailId() {
        return emailId;
    }

    public void setEmail(String emailId) {
        this.emailId = emailId;
    }
            
    @SerializedName("mobileNo")
    @Expose
    private String mobileNo;

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }


    @SerializedName("otp")
    @Expose
    private String otp;
    public String getOtp() {
        return otp;
    }
    public void setOtp(String otp) {
        this.otp = otp;
    }

    @SerializedName("PartnerRefIdStan")
    @Expose
    private String refId;
    public String getRefId() {
        return refId;
    }
    public void setRefId(String refId) {
        this.refId = refId;
    }
}
