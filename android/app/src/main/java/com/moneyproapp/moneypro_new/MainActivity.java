package com.moneyproapp.moneypro_new;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.aeps.cyrus_aeps_lib.DeshboradActivity;
import com.moneyproapp.moneypro_new.finger.FingerPrintAuth;
import com.moneyproapp.moneypro_new.model.Opts;
import com.moneyproapp.moneypro_new.model.PidData;
import com.moneyproapp.moneypro_new.model.PidOptions;
import com.paysprint.onboardinglib.activities.HostActivity;

import org.json.JSONException;
import org.json.JSONObject;
import org.rbpfinivis.aeps.AePSRbpfinivis;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;


import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Random;

import io.flutter.embedding.android.FlutterActivity;

import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private MethodChannel.Result myresult;

    String TAG ="MainActivity";

    final int min = 8987989;
    final int max = 898098067;
    final int random = new Random().nextInt((max - min) + 9087) + min;


    private ArrayList<String> positions;
    private PidData pidData = null;
    private Serializer serializer = null;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        positions = new ArrayList<>();
        serializer = new Persister();

        try {
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "MICRO_ATM_CHANNEL").setMethodCallHandler(
                    (call, result) -> {
                        // Note: this method is invoked on the main thread.
                        if (call.method.equals("keyCrypt")) {
                            myresult = result;
                            String stateId = call.argument("stateId");
                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "1");
                            intent.putExtra("a1", stateId);
                            startActivityForResult(intent, 987);
                        }
                        else if (call.method.equals("regCrypt")) {
                            myresult = result;
                            String name = call.argument("name");
                            String email = call.argument("email");
                            String mobileNo = call.argument("mobileNo");
                            String shopName = call.argument("shopName");
                            String address1 = call.argument("address1");
                            String address2 = call.argument("address2");
                            String pincode = call.argument("pincode");
                            String aadhaarNo = call.argument("aadhaarNo");
                            String panNo = call.argument("panNo");
                            String stateId = call.argument("stateId");
                            String districtId = call.argument("districtId");

                            Intent intent = new Intent(this, AntMan.class);
                            intent.putExtra("name", name);
                            intent.putExtra("email", email);
                            intent.putExtra("mobileNo", mobileNo);
                            intent.putExtra("shopName", shopName);
                            intent.putExtra("address1", address1);
                            intent.putExtra("address2", address2);
                            intent.putExtra("pincode", pincode);
                            intent.putExtra("aadhaarNo", aadhaarNo);
                            intent.putExtra("panNo", panNo);
                            intent.putExtra("stateId", stateId);
                            intent.putExtra("districtId", districtId);
                            startActivityForResult(intent, 123);
                        }
                        else if (call.method.equals("moveATM")) {
                            myresult = result;

                            String merchantId = call.argument("merchantId");
                            String merchantEmailId = call.argument("merchantEmailId");
                            String merchantMobileNo = call.argument("merchantMobileNo");
                            String token = call.argument("token");
                            String enryptdecryptKey = call.argument("enryptdecryptKey");
                            String pipe = call.argument("pipe");
                            String partnerRefId = call.argument("partnerRefId");
                            
                            
                            /*Log.e(TAG,"merchantId : "+merchantId);
                            Log.e(TAG,"merchantEmailId : "+merchantEmailId);
                            Log.e(TAG,"merchantMobileNo : "+merchantMobileNo);
                            Log.e(TAG,"token : "+token);
                            Log.e(TAG,"enryptdecryptKey : "+enryptdecryptKey);
                            */

                            /*Intent intent = new Intent(MainActivity.this, MicroAtmMego.class);
                            intent.putExtra("merchantId", merchantId);
                            intent.putExtra("merchantEmailId", merchantEmailId);
                            intent.putExtra("merchantMobileNo", merchantMobileNo);
                            intent.putExtra("partnerRefId", partnerRefId);
                            intent.putExtra("token", token);
                            intent.putExtra("pipe", pipe);
                            intent.putExtra("enryptdecryptKey", enryptdecryptKey);

                            startActivityForResult(intent, 665);*/

                            PackageManager packageManager = MainActivity.this.getPackageManager();
                            if (isPackageInstalled("org.rbpfinivis.matm", packageManager)) {
                                Intent i = new Intent();
                                i.setComponent(new ComponentName("org.rbpfinivis.matm", "org.rbpfinivis.matm.MicroAtmMego"));
                                i.putExtra("merchantId",merchantId);
                                i.putExtra("merchantEmailId",merchantEmailId);
                                i.putExtra("merchantMobileNo",merchantMobileNo);
                                i.putExtra("partnerRefId", partnerRefId);
                                i.putExtra("token", token);
                                i.putExtra("pipe",pipe);
                                i.putExtra("enryptdecryptKey", enryptdecryptKey);
                                startActivityForResult(i, 665);
                            } else {

                                AlertDialog.Builder alertDialog = new AlertDialog.Builder(MainActivity.this, R.style.alertDialog);
                                alertDialog.setTitle("Get Micro ATM Service");
                                alertDialog.setMessage("Click OK to Download Now.");

                                alertDialog.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        try {
                                            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=org.rbpfinivis.matm")));
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                });
                                alertDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        dialog.dismiss();
                                    }
                                });
                                alertDialog.show();
                            }
                        }
                        else if (call.method.equals("aepsCall")) {
                            myresult =result;

                            String authKey = call.argument("authKey");
                            String message = call.argument("message");
                            String mobile = call.argument("mobile");
                            String email = call.argument("email");

                            Intent intent = new Intent(MainActivity.this, DeshboradActivity.class);
                            intent.putExtra("AuthoKey", authKey);
                            intent.putExtra("Hashmessage", message);
                            intent.putExtra("mobilenumber", mobile);
                            intent.putExtra("emailid", email);
                            intent.putExtra("logoimageurl", "");
                            startActivityForResult(intent, 1);
                        }
                        else if (call.method.equals("getMidEnc")) {
                            myresult = result;
                            String merchantId = call.argument("merchantId");

                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "2");
                            intent.putExtra("merId", merchantId);
                            startActivityForResult(intent, 444);

                        }
                        else if (call.method.equals("resendOtp")) {
                            myresult = result;
                            String ekycPrimaryKeyId = call.argument("ekycPrimaryKeyId");
                            String ekycTxnId = call.argument("ekycTxnId");
                            String merchant_Id = call.argument("merchant_Id");

                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "3");
                            intent.putExtra("ekycPrimaryKeyId", ekycPrimaryKeyId);
                            intent.putExtra("ekycTxnId", ekycTxnId);
                            intent.putExtra("merchant_Id", merchant_Id);
                            startActivityForResult(intent, 333);
                        }
                        else if (call.method.equals("submitOtp")) {
                            myresult = result;
                            String otp = call.argument("otp");
                            String ekycPrimaryKeyId = call.argument("ekycPrimaryKeyId");
                            String ekycTxnId = call.argument("ekycTxnId");
                            String merchant_Id = call.argument("merchant_Id");
                            String fingerprintData = call.argument("fingerprintData");

                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "4");
                            intent.putExtra("otp", otp);
                            intent.putExtra("ekycPrimaryKeyId", ekycPrimaryKeyId);
                            intent.putExtra("ekycTxnId", ekycTxnId);
                            intent.putExtra("merchant_Id", merchant_Id);
                            intent.putExtra("fingerprintData", fingerprintData);
                            startActivityForResult(intent, 898);
                        }
                        else if (call.method.equals("kycStatus")) {
                            myresult = result;
                            String merchant_id = call.argument("merchant_id");
                            String emailId = call.argument("emailId");
                            String mobileNo = call.argument("mobileNo");

                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "5");
                            intent.putExtra("merchant_id", merchant_id);
                            intent.putExtra("emailId", emailId);
                            intent.putExtra("mobileNo", mobileNo);
                            startActivityForResult(intent, 909);
                        }
                        else if (call.method.equals("getFinger")) {
                            myresult = result;
                            String deviceType = call.argument("deviceType");

                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("action", "6");
                            intent.putExtra("deviceType", deviceType);
                            startActivityForResult(intent, 234);
                        }
                        else if (call.method.equals("verifySign")) {
                            myresult = result;

                            String orderId = call.argument("orderId");
                            String orderAmount = call.argument("orderAmount");
                            String referenceId = call.argument("referenceId");
                            String txStatus = call.argument("txStatus");
                            String paymentMode = call.argument("paymentMode");
                            String txMsg = call.argument("txMsg");
                            String txTime = call.argument("txTime");

                            Intent intent = new Intent(this, VerfiySignature.class);
                            intent.putExtra("action", "7");
                            intent.putExtra("orderId", orderId);
                            intent.putExtra("orderAmount", orderAmount);
                            intent.putExtra("referenceId", referenceId);
                            intent.putExtra("txStatus", txStatus);
                            intent.putExtra("paymentMode", paymentMode);
                            intent.putExtra("txMsg", txMsg);
                            intent.putExtra("txTime", txTime);
                            startActivityForResult(intent, 345);
                        }
                        else if (call.method.equals("fingerprint")) {
                            myresult = result;
                            String pin = call.argument("pin");
                            Intent intent = new Intent(this, FingerPrintAuth.class);
                            intent.putExtra("action", "8");
                            intent.putExtra("pin", pin);
                            startActivityForResult(intent, 678);
                        }
                        else if (call.method.equals("panKyc")) {
                            myresult = result;

                            String pId = call.argument("pId");
                            String pApiKey = call.argument("pApiKey");
                            String mCode = call.argument("mCode");
                            String mobile = call.argument("mobile");
                            String lat = call.argument("lat");
                            String lng = call.argument("lng");
                            String firm = call.argument("firm");
                            String email = call.argument("email");

                            Intent intent = new Intent(this, HostActivity.class);
                            intent.putExtra("pId", pId);
                            intent.putExtra("pApiKey", pApiKey);
                            intent.putExtra("mCode", mCode);
                            intent.putExtra("mobile", mobile);
                            intent.putExtra("lat", lat);
                            intent.putExtra("lng", lng);
                            intent.putExtra("firm", firm);
                            intent.putExtra("email", email);

                            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
                            startActivityForResult(intent, 999);
                        } else if (call.method.equals("aepsSBMCall")) {
                            myresult = result;

                            String merchantId = call.argument("merchantId");
                            String merchantEmailId = call.argument("merchantEmailId");
                            String merchantMobileNo = call.argument("merchantMobileNo");
                            String partnerRefId = call.argument("partnerRefId");
                            String txnCode = call.argument("txnCode");
                            String pipe = call.argument("pipe");
                            String token = call.argument("token");
                            String enryptdecryptKey = call.argument("enryptdecryptKey");

                            //MicroAtmMego
                            Intent intent = new Intent(this, AePSRbpfinivis.class);
                            intent.putExtra("merchantId", merchantId);
                            intent.putExtra("merchantEmailId", merchantEmailId);
                            intent.putExtra("merchantMobileNo", merchantMobileNo);
                            intent.putExtra("partnerRefId", partnerRefId);
                            intent.putExtra("txnCode", txnCode);
                            intent.putExtra("pipe", pipe);
                            intent.putExtra("token", token);
                            intent.putExtra("enryptdecryptKey", enryptdecryptKey);

                            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
                            startActivityForResult(intent, 137);
                        } else if (call.method.equals("getIEMI")) {
                            myresult = result;
                            String imei = call.argument("imei");
                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("imei", imei);
                            intent.putExtra("action", "9");

                            startActivityForResult(intent, 232);
                        }else if (call.method.equals("aepsId")) {
                            myresult = result;
                            String refIdStan = call.argument("PartnerRefIdStan");
                            Intent intent = new Intent(this, MyClass.class);
                            intent.putExtra("refIdStan", refIdStan);
                            intent.putExtra("action", "10");

                            startActivityForResult(intent, 870);
                        }else if (call.method.equals("aepsfino")) {
                            myresult = result;

                            String pId = call.argument("pId");
                            String pApiKey = call.argument("pApiKey");
                            String mCode = call.argument("mCode");
                            String mobile = call.argument("mobile");
                            String lat = call.argument("lat");
                            String lng = call.argument("lng");
                            String firm = call.argument("firm");
                            String email = call.argument("email");

                            Intent intent = new Intent(this, HostActivity.class);
                            intent.putExtra("pId", pId);
                            intent.putExtra("pApiKey", pApiKey);
                            intent.putExtra("mCode", mCode);
                            intent.putExtra("mobile", mobile);
                            intent.putExtra("lat", lat);
                            intent.putExtra("lng", lng);
                            intent.putExtra("firm", firm);
                            intent.putExtra("email", email);


                            Log.e(TAG,"pId : "+pId);
                            Log.e(TAG,"pApiKey : "+pApiKey);
                            Log.e(TAG,"mCode : "+mCode);
                            Log.e(TAG,"mobile : "+mobile);
                            Log.e(TAG,"lat : "+lat);
                            Log.e(TAG,"lng : "+lng);
                            Log.e(TAG,"firm : "+firm);
                            Log.e(TAG,"email : "+email);

                            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
                            startActivityForResult(intent, 871);
                        }else if (call.method.equals("getAepsFinger")) {
                            myresult = result;
                            /*String deviceType = call.argument("deviceType");
                            Intent intent = new Intent(this, AePSPiData.class);
                            intent.putExtra("action", "1");
                            intent.putExtra("deviceType", deviceType);
                            startActivityForResult(intent, 872);*/

                            String pidOption = getPIDOptions();

                            if (pidOption != null) {
                                Log.e("PidOptions", pidOption);

                                Intent intent2 = new Intent();
                                intent2.setAction("in.gov.uidai.rdservice.fp.CAPTURE");
                                intent2.putExtra("PID_OPTIONS", pidOption);
                                startActivityForResult(intent2, 872);
                            }
                        }
                        else {
                            result.notImplemented();
                        }
                    });
        } catch (Exception e) {
            Log.e("Natvie COde", "*******Exception******* : " + e.toString());
        }
    }

    private String getPIDOptions() {
        try {
            String pidVer = "2.0";
            String timeOut = "10000";
            String posh = "UNKNOWN";
            if (positions.size() > 0) {
                posh = positions.toString().replace("[", "").replace("]", "").replaceAll("[\\s+]", "");
            }

            Opts opts = new Opts();
            opts.fCount = String.valueOf("1");
            opts.fType = String.valueOf("0");
            opts.iCount = "0";
            opts.iType = "0";
            opts.pCount = "0";
            opts.pType = "0";
            opts.format = String.valueOf("0");
            opts.pidVer = pidVer;
            opts.timeout = timeOut;
            opts.posh = posh;
            opts.env = "P";

            PidOptions pidOptions = new PidOptions();
            pidOptions.ver = "1.0";
            pidOptions.Opts = opts;

            Serializer serializer = new Persister();
            StringWriter writer = new StringWriter();
            serializer.write(pidOptions, writer);
            return writer.toString();
        } catch (Exception e) {
            Log.e("Error", e.toString());
        }
        return null;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        try {
            // Check which request we're responding to
            if (requestCode == 987) {
                String code = data.getStringExtra("a1");
                myresult.success(code);
            } else if (requestCode == 123) {
                String code = data.getStringExtra("reg");
                myresult.success(code);
            } else if (requestCode == 665) {
                if (resultCode == RESULT_OK) {
                    try {
                        JSONObject object = new JSONObject();
                        object.put("statusCode", data.getExtras().getString("statusCode"));
                        object.put("message", data.getExtras().getString("message"));
                        object.put("bankStatus", data.getExtras().getString("bankStatus"));
                        object.put("rrn", data.getExtras().getString("rrn"));
                        object.put("transactionAmount", data.getExtras().getString("transactionAmount"));
                        object.put("balanceAmount", data.getExtras().getString("balanceAmount"));
                        object.put("txnType", data.getExtras().getString("txnType"));
                        object.put("cardNo", data.getExtras().getString("cardNo"));
                        object.put("cardType", data.getExtras().getString("cardType"));
                        object.put("merchantId", data.getExtras().getString("merchantId"));
                        object.put("merchantName", data.getExtras().getString("merchantName"));
                        object.put("terminalId", data.getExtras().getString("terminalId"));
                        object.put("txnDate", data.getExtras().getString("txnDate"));
                        object.put("bankName", data.getExtras().getString("bankName"));
                        object.put("bankMessage", data.getExtras().getString("bankMessage"));
                        object.put("partnerRefId", data.getExtras().getString("partnerRefId"));
                        object.put("txnId", data.getExtras().getString("txnId"));
                        object.put("merchantMobileNo", data.getExtras().getString("merchantMobileNo"));
                        object.put("merchantEmailId", data.getExtras().getString("merchantEmailId"));
                        myresult.success(object.toString());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    if (data.getStringExtra("statusCode").equals("1009")){
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=org.rbpfinivis.matm")));
                    }else {
                        String res = ""+data.getStringExtra("message");
                        String sts = ""+data.getStringExtra("statusCode");
                        JSONObject object = new JSONObject();
                        object.put("message", res);
                        object.put("sts", sts);
                        myresult.success(object.toString());
                        //txtresponse.setText("statusCode : " + data.getStringExtra("statusCode") + "\n" + "message : " + data.getStringExtra("message") + "\n");
                    }
                }
            }else if(requestCode==1){
                if (resultCode == RESULT_OK) {
                    String m = data.getStringExtra("message");
                    Toast.makeText(MainActivity.this, "" + m, Toast.LENGTH_LONG).show();
                    myresult.success(m);
                }
            }else  if (requestCode == 444) {
                String code = data.getStringExtra("merchantId");
                myresult.success(code);
            }else  if (requestCode == 333) {
                String code = data.getStringExtra("result");
                myresult.success(code);
            }else  if (requestCode == 898) {
                String code = data.getStringExtra("result");
                myresult.success(code);
            }else  if (requestCode == 909) {
                String code = data.getStringExtra("kycStatus");
                myresult.success(code);
            }else  if (requestCode == 234) {
                String code = data.getStringExtra("base64");
                myresult.success(code);
            }else  if (requestCode == 345) {
                String code = data.getStringExtra("sign");
                myresult.success(code);
            }else  if (requestCode == 678) {
                String code = data.getStringExtra("isLogin");
                myresult.success(code);
            }else  if (requestCode == 999) {
                String message = data.getExtras().getString("message");
                myresult.success(message);
            }else  if (requestCode == 137) {
                if (resultCode == RESULT_OK) {
                    try {
                        String response = ""+data.getStringExtra("data");
                        myresult.success(response);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    String statusCode = ""+data.getStringExtra("statusCode");
                    String message = ""+data.getStringExtra("message");
                    myresult.success(message);
                }
            }else  if (requestCode == 232) {
                String message = data.getExtras().getString("iemi");
                myresult.success(message);
            }else  if (requestCode == 870) {
                String refIdStan = data.getExtras().getString("refIdStan");
                myresult.success(refIdStan);
            }else  if (requestCode == 871) {
                String message = data.getExtras().getString("message");
                myresult.success(message);
            }else  if (requestCode == 872) {
                Log.e(TAG,"result : "+data);
                if (resultCode == Activity.RESULT_OK) {
                    try {
                        if (data != null) {
                            String result = data.getStringExtra("PID_DATA");
                            if (result != null) {
                                pidData = serializer.read(PidData.class, result);
                                Log.e(TAG,"PIDATA : "+pidData);
                                Log.e(TAG,"result : "+result);
                                myresult.success(result);
                            }
                        }
                    } catch (Exception e) {
                        Log.e("Error", "Error while deserialze pid data", e);
                    }
                }



            }
        } catch (Exception e) {
            Log.e("Natvie COde", "#######Exception2####### : " + e.toString());
        }
    }

    public static boolean isPackageInstalled(String packagename, PackageManager packageManager) {
        try {
            packageManager.getPackageInfo(packagename, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
}
