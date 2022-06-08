package com.moneyproapp.moneypro_new;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;


import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

public class AntMan extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        String name = getIntent().getExtras().getString("name");
        String email = getIntent().getExtras().getString("email");
        String mobileNo = getIntent().getExtras().getString("mobileNo");
        String shopName = getIntent().getExtras().getString("shopName");
        String address1 = getIntent().getExtras().getString("address1");
        String address2 = getIntent().getExtras().getString("address2");
        String pincode = getIntent().getExtras().getString("pincode");
        String aadhaarNo = getIntent().getExtras().getString("aadhaarNo");
        String panNo = getIntent().getExtras().getString("panNo");
        String stateId = getIntent().getExtras().getString("stateId");
        String districtId = getIntent().getExtras().getString("districtId");
        

        RegisterBody ss = new RegisterBody();
        ss.setName(name);
        ss.setEmail(email);
        ss.setMobileNo(mobileNo);
        ss.setShopName(shopName);
        ss.setAddress1(address1);
        ss.setAddress2(address2);
        ss.setPincode(pincode);
        ss.setAadhaarNo(aadhaarNo);
        ss.setPanNo(panNo);
        ss.setStateId(stateId);
        ss.setDistrictId(districtId);

        Gson gson = new Gson();
        String a = gson.toJson(ss);

       // Log.e("Ant Man ->", "Converted Data : "+a);

        DataBody dataBody = new DataBody();
        dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
        //dataBody.setTextToDecrypt(new RijndaelCrypt("kXNL3UGFLxH").encrypt(a.getBytes()));
        Gson gson1 = new Gson();
        String a1 = gson1.toJson(dataBody);


        Intent returnIntent = new Intent();
        returnIntent.putExtra("reg", a1);
        setResult(Activity.RESULT_OK, returnIntent);
        finish();

    }
}
