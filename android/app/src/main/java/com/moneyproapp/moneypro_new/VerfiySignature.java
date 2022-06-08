package com.moneyproapp.moneypro_new;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;


import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;


import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Set;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VerfiySignature extends AppCompatActivity {

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        Bundle bundle = getIntent().getExtras();

        String action = getIntent().getExtras().getString("action");
     
        if (action.equalsIgnoreCase("7")) {

            try {
                String orderId = getIntent().getExtras().getString("orderId");
                String orderAmount = getIntent().getExtras().getString("orderAmount");
                String referenceId = getIntent().getExtras().getString("referenceId");
                String txStatus = getIntent().getExtras().getString("txStatus");
                String paymentMode = getIntent().getExtras().getString("paymentMode");
                String txMsg = getIntent().getExtras().getString("txMsg");
                String txTime = getIntent().getExtras().getString("txTime");


                LinkedHashMap<String, String> postData = new LinkedHashMap<String, String>();

                postData.put("orderId", orderId);
                postData.put("orderAmount", orderAmount);
                postData.put("referenceId", referenceId);
                postData.put("txStatus", txStatus);
                postData.put("paymentMode", paymentMode);
                postData.put("txMsg", txMsg);
                postData.put("txTime", txTime);

                String data = "";
                Set<String> keys = postData.keySet();

                for (String key : keys) {
                    data = data + postData.get(key);
                }
                String secretKey = "0695637a909be8a7b7716afeceaae89469ca573f"; // Get secret key from config;
                Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
                SecretKeySpec secret_key_spec = new
                        SecretKeySpec(secretKey.getBytes(),"HmacSHA256");
                sha256_HMAC.init(secret_key_spec);

                String signature = Base64.getEncoder().encodeToString(sha256_HMAC.doFinal(data.getBytes()));


                Intent returnIntent = new Intent();
                returnIntent.putExtra("sign", signature);
                setResult(Activity.RESULT_OK, returnIntent);
               finish();

            }catch (Exception e){
                e.printStackTrace();
            }


        }
    }
}
