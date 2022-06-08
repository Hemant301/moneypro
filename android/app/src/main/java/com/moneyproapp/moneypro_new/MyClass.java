package com.moneyproapp.moneypro_new;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Base64;

import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.gson.Gson;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.io.ByteArrayInputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.LinkedHashMap;
import java.util.Set;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import android.telephony.TelephonyManager;


public class MyClass extends AppCompatActivity {


    String TAG = "My Class";

    String pidMantraData = "<PidOptions ver=\"1.0\"><Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"15000\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" /></PidOptions>";

    String pidMorphoData = "<PidOptions ver=\"1.0\"><Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"15000\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" /></PidOptions>";

    
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle bundle = getIntent().getExtras();
        
        String action = getIntent().getExtras().getString("action");


        if (action.equalsIgnoreCase("1")) {

            String a1 = getIntent().getExtras().getString("a1");

            StateBody ss = new StateBody();
            ss.setStateId(a1);
            Gson gson = new Gson();
            String a = gson.toJson(ss);

            //  Log.e("NATIVE My Class ---> ", "stateId : " + a);

            DataBody dataBody = new DataBody();
            dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            Gson gson1 = new Gson();
            a1 = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("a1", a1);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();
        }

        if (action.equalsIgnoreCase("2")) {

            String merchantId = getIntent().getExtras().getString("merId");

            StateBody ss = new StateBody();
            ss.setMerchantId(merchantId);
            Gson gson = new Gson();
            String a = gson.toJson(ss);

            DataBody dataBody = new DataBody();

            dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            Gson gson1 = new Gson();
            String merId = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("merchantId", merId);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();
        }

        if (action.equalsIgnoreCase("3")) {

            String ekycPrimaryKeyId = getIntent().getExtras().getString("ekycPrimaryKeyId");
            String ekycTxnId = getIntent().getExtras().getString("ekycTxnId");
            String merchant_Id = getIntent().getExtras().getString("merchant_Id");

            StateBody ss = new StateBody();
            ss.seteKycPrimaryKeyId(ekycPrimaryKeyId);
            ss.seteekycTxnId(ekycTxnId);
            ss.setMerchantId(merchant_Id);
            Gson gson = new Gson();
            String a = gson.toJson(ss);

            DataBody dataBody = new DataBody();

            dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            Gson gson1 = new Gson();
            String result = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("result", result);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();

        }

        if (action.equalsIgnoreCase("4")) {

            String otp = getIntent().getExtras().getString("otp");
            String ekycPrimaryKeyId = getIntent().getExtras().getString("ekycPrimaryKeyId");
            String ekycTxnId = getIntent().getExtras().getString("ekycTxnId");
            String merchant_Id = getIntent().getExtras().getString("merchant_Id");
            String fingerprintData = getIntent().getExtras().getString("fingerprintData");

            OTPBody ss = new OTPBody();
            ss.seteKycPrimaryKeyId(ekycPrimaryKeyId);
            ss.setOtp(otp);
            ss.seteekycTxnId(ekycTxnId);
            ss.setMerchantIdd(merchant_Id);
            ss.setFingerPrintData(fingerprintData);
            Gson gson = new Gson();
            String a = gson.toJson(ss);

            //    Log.e("My Class", "Get OTP : " + ss.getOtp());

            //   Log.e("My Class data", "result otp : " + a);

            DataBody dataBody = new DataBody();
            try {
                dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            } catch (Exception e) {
                e.printStackTrace();
                //     Log.e("exc", "" + e);
            }


            Gson gson1 = new Gson();
            String result = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("result", result);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();

        }

        if (action.equalsIgnoreCase("5")) {
            String merchant_id = getIntent().getExtras().getString("merchant_id");
            String emailId = getIntent().getExtras().getString("emailId");
            String mobileNo = getIntent().getExtras().getString("mobileNo");


            StateBody ss = new StateBody();
            ss.setMerchantId(merchant_id);
            ss.setEmail(emailId);
            ss.setMobileNo(mobileNo);

            Gson gson = new Gson();
            String a = gson.toJson(ss);

            DataBody dataBody = new DataBody();

            dataBody.setTextToDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            Gson gson1 = new Gson();
            String result = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("kycStatus", result);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();
        }

        if (action.equalsIgnoreCase("6")) {

            String deviceType = getIntent().getExtras().getString("deviceType");

            if (deviceType.equalsIgnoreCase("Mantra")) {
                MantraFinger();
            }

            if (deviceType.equalsIgnoreCase("Morpho")) {
                MorphoDevice();
            }

        }

        if (action.equalsIgnoreCase("9")) {
            String iemi = getDeviceImei(MyClass.this);
            Intent returnIntent = new Intent();
            returnIntent.putExtra("iemi", iemi);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();

        }

        if (action.equalsIgnoreCase("10")) {
            String merchantId = getIntent().getExtras().getString("refIdStan");

            StateBody ss = new StateBody();
            ss.setRefId(merchantId);
            Gson gson = new Gson();
            String a = gson.toJson(ss);

            RefBody dataBody = new RefBody();

            dataBody.setrefIdDecrypt(new RijndaelCrypt(getString(R.string.encData)).encrypt(a.getBytes()));
            Gson gson1 = new Gson();
            String merId = gson1.toJson(dataBody);

            Intent returnIntent = new Intent();
            returnIntent.putExtra("refIdStan", merId);
            setResult(Activity.RESULT_OK, returnIntent);
            finish();
        }
        
    }


    private void MantraFinger() {
        PackageManager packageManager = getPackageManager();
        if (isPackageInstalled("com.mantra.rdservice", packageManager)) {
            Intent intent = new Intent();
            intent.setComponent(new ComponentName("com.mantra.rdservice", "com.mantra.rdservice.RDServiceActivity"));
            intent.setAction("in.gov.uidai.rdservice.fp.CAPTURE");
            intent.putExtra("PID_OPTIONS", pidMantraData);
            startActivityForResult(intent, 1);
        } else {
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(this, R.style.Theme_AppCompat_Light_Dialog_Alert);
            alertDialog.setTitle("Get Service");
            alertDialog.setMessage("Mantra RD Services Not Found.Click OK to Download Now.");

            alertDialog.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    try {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.mantra.rdservice")));
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

    public static boolean isPackageInstalled(String packagename, PackageManager packageManager) {
        try {
            packageManager.getPackageInfo(packagename, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            if (resultCode == RESULT_OK) {
                try {
                    if (data.getStringExtra("PID_DATA") != null) {

                        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                        Document doc = dBuilder.parse(new ByteArrayInputStream(data.getStringExtra("PID_DATA").getBytes("UTF-8")));

                        Log.e(TAG, "PID *** DATA : "+doc.getDocumentElement());

                        NodeList nodeList1 = doc.getElementsByTagName("Resp");


                        Element element1 = (Element) nodeList1.item(0);

                        String errorCode = "" + element1.getAttribute("errCode");
                        String errInfo = "" + element1.getAttribute("errInfo");
                        if (errorCode.equals("0")) {
                            String pidData = "" + data.getStringExtra("PID_DATA");

                            Log.e(TAG, "PID DATA : "+pidData);

                            byte[] data1 = pidData.getBytes("UTF-8");
                            String base64 = Base64.encodeToString(data1, Base64.DEFAULT);

                            Intent returnIntent = new Intent();
                            returnIntent.putExtra("base64", pidData);
                            setResult(Activity.RESULT_OK, returnIntent);
                            finish();

                        } else {
                            if (getPreferredPackage(this, "com.mantra.rdservice").equalsIgnoreCase(""))
                                Toast.makeText(this, "" + errorCode + " : Mantra " + errInfo + getPreferredPackage(this, "com.mantra.rdservice"), Toast.LENGTH_SHORT).show();
                            else
                                clearDefaultSetting(this, "com.mantra.rdservice");
                        }
                    } else {
                        Toast.makeText(this, "", Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        if (requestCode == 2) {
            if (resultCode == RESULT_OK) {
                try {
                    if (data.getStringExtra("DEVICE_INFO") != null) {
                        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                        Document doc = dBuilder.parse(new ByteArrayInputStream(data.getStringExtra("DEVICE_INFO").getBytes("UTF-8")));
                        NodeList nodeList = doc.getElementsByTagName("DeviceInfo");
                        NodeList n2 = ((Element) nodeList.item(0)).getElementsByTagName("additional_info");
                        if (n2.item(0) == null) {
                            Log.e("check", "Connect Morpho Device");
                        } else {
                            Element serialNo = (Element) n2.item(0).getChildNodes().item(1);
                            if (!(serialNo.getAttribute("value").equalsIgnoreCase("") && serialNo.getAttribute("value").equalsIgnoreCase("")))
                                MorphoFinger();
                        }
                    }
                } catch (Exception e) {
                    Toast.makeText(this, "Please check your Morpho device or contact customer support!", Toast.LENGTH_LONG).show();
                    e.printStackTrace();
                }
            }
        }
        if (requestCode == 3) {
            if (resultCode == RESULT_OK) {
                try {
                    if (data.getStringExtra("PID_DATA") != null) {
                        String serialNumber = "";
                        Log.e("qwert", "" + data.getStringExtra("PID_DATA"));
                        String xx = "" + data.getStringExtra("PID_DATA");
                        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                        Document doc = dBuilder.parse(new ByteArrayInputStream(data.getStringExtra("PID_DATA").getBytes("UTF-8")));
                        NodeList nodeList = doc.getElementsByTagName("DeviceInfo");
                        NodeList nodeList1 = doc.getElementsByTagName("Resp");
                        Element element1 = (Element) nodeList1.item(0);
                        NodeList n2 = ((Element) nodeList.item(0)).getElementsByTagName("additional_info");
                        if (n2.item(0) == null) {

                        } else {
                            Element serialNo = (Element) n2.item(0).getChildNodes().item(1);
                            serialNumber = "" + serialNo.getAttribute("value");
                        }

                        String errorCode = "" + element1.getAttribute("errCode");
                        String errInfo = "" + element1.getAttribute("errInfo");
                        if (errorCode.equals("0")) {
                            String xx1[] = xx.split("\\?>");
                            String xx2 = xx1[1].replace("<Param name=\"serial_number\" value=\"" + serialNumber + "\"/>", "");
                            // byte[] bytesEncoded = Base64.encodeBase64(xx2.getBytes());
                            String base64 = Base64.encodeToString(xx2.getBytes(), Base64.DEFAULT);

                            Intent returnIntent = new Intent();
                            returnIntent.putExtra("base64", base64);
                            setResult(Activity.RESULT_OK, returnIntent);
                            finish();

                        } else {
                            if (getPreferredPackage(this, "com.scl.rdservice").equalsIgnoreCase(""))
                                Toast.makeText(this, "" + errorCode + " : Morpho " + errInfo + "com.scl.rdservice", Toast.LENGTH_SHORT).show();
                            else
                                clearDefaultSetting(this, "com.scl.rdservice");
                        }
                    } else {

                    }
                } catch (Exception e) {
                    Toast.makeText(this, "Please check your Morpho device or contact customer support!", Toast.LENGTH_SHORT).show();
                    e.printStackTrace();
                }
            }
        }
        
    }
    
    public static String getPreferredPackage(Context context, String deviceId) {
        String data = "";
        try {
            Intent intent = new Intent();
            intent.setAction("in.gov.uidai.rdservice.fp.CAPTURE");
            PackageManager packageManager = context.getPackageManager();
            final ResolveInfo resolveInfo = packageManager.resolveActivity(intent, 0);
            String temp = resolveInfo.activityInfo.packageName;
            if (temp.equalsIgnoreCase("android") || temp.equalsIgnoreCase(deviceId))
                data = "";
            else
                data = temp;//packageManager.getApplicationLabel(resolveInfo.activityInfo.applicationInfo).toString();
            // data=" ("+packageManager.getApplicationLabel(resolveInfo.activityInfo.applicationInfo).toString()+")";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return data;
    }

    public void clearDefaultSetting(final Context context, final String PackageId) {
        final Dialog d = new Dialog(context, R.style.Base_Theme_AppCompat_Light_Dialog_Alert);
        d.setCancelable(false);
        d.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        d.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        d.setContentView(R.layout.deveice_dialog);
        d.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

        final TextView txtyes, txtcancle;


        txtyes = d.findViewById(R.id.txtyes);
        txtcancle = d.findViewById(R.id.txtcancle);


        txtyes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent showSettings = new Intent();
                showSettings.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                Uri uriAppSettings = Uri.fromParts("package", PackageId, null);
                showSettings.setData(uriAppSettings);
                context.startActivity(showSettings);
                d.dismiss();
            }
        });

        txtcancle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                d.dismiss();
            }
        });

        d.show();

    }


    private void MorphoDevice() {
        Log.e("qwerty", "1");
        PackageManager packageManager = getPackageManager();
        if (isPackageInstalled("com.scl.rdservice", packageManager)) {
            Intent intent = new Intent("in.gov.uidai.rdservice.fp.INFO");
            intent.setPackage("com.scl.rdservice");
            startActivityForResult(intent, 2);
        } else {
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(this, R.style.Theme_AppCompat_Light_Dialog_Alert);
            alertDialog.setTitle("Get Service");
            alertDialog.setMessage("Morpho RD Services Not Found.Click OK to Download Now.");
            alertDialog.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    try {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.scl.rdservice")));
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

    private void MorphoFinger() {
        Intent intent2 = new Intent();
        intent2.setComponent(new ComponentName("com.scl.rdservice", "com.scl.rdservice.FingerCaptureActivity"));
        intent2.setAction("in.gov.uidai.rdservice.fp.CAPTURE");
        intent2.putExtra("PID_OPTIONS", pidMorphoData);
        startActivityForResult(intent2, 3);
    }

    public String getDeviceImei(Context ctx) {

        @SuppressLint("HardwareIds") String id = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);

        //  TelephonyManager telephonyManager = (TelephonyManager) ctx.getSystemService(Context.TELEPHONY_SERVICE);
        return id;
    }
}
