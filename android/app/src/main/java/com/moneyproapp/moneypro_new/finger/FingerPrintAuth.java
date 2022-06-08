package com.moneyproapp.moneypro_new.finger;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
import androidx.fragment.app.FragmentActivity;


import com.moneyproapp.moneypro_new.R;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;


public class FingerPrintAuth extends AppCompatActivity implements BiometricCallback {

    
    String TAG = "Finger Print Auth";

    EditText ed1,ed2,ed3,ed4;

    String newPin ;
    String pin;
    StringBuilder sb = new StringBuilder();

    BiometricManager mBiometricManager;
    FragmentActivity fragmentActivity = this;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fingerauth);

        String action = getIntent().getExtras().getString("action");
         pin  = getIntent().getExtras().getString("pin");

        enableFP();

        Log.e(TAG ,"Action : "+action);
        Log.e(TAG ,"PIN : "+pin);

        ed1  = findViewById(R.id.ed1);
        ed2  = findViewById(R.id.ed2);
        ed3  = findViewById(R.id.ed3);
        ed4  = findViewById(R.id.ed4);


        ed1.addTextChangedListener(new GenericTextWatcher(ed1));
        ed2.addTextChangedListener(new GenericTextWatcher(ed2));
        ed3.addTextChangedListener(new GenericTextWatcher(ed3));
        ed4.addTextChangedListener(new GenericTextWatcher(ed4));

        if (!BiometricUtils.isSdkVersionSupported()) {
            Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_sdk_not_supported), Toast.LENGTH_LONG).show();
        } else if (!BiometricUtils.isHardwareSupported(FingerPrintAuth.this)) {
            Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_hardware_not_supported), Toast.LENGTH_LONG).show();
        } else if (!BiometricUtils.isPermissionGranted(FingerPrintAuth.this)) {
            Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_permission_not_granted), Toast.LENGTH_LONG).show();
        } else if (!BiometricUtils.isFingerprintAvailable(FingerPrintAuth.this)) {
            Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_fingerprint_not_available), Toast.LENGTH_LONG).show();
        } else {
            Executor executor = Executors.newSingleThreadExecutor();

            final BiometricPrompt biometricPrompt = new BiometricPrompt(fragmentActivity, executor,
                    new BiometricPrompt.AuthenticationCallback() {
                        @Override
                        public void onAuthenticationError(int errorCode, @NonNull CharSequence errString) {
                            super.onAuthenticationError(errorCode, errString);
                            if (errorCode == BiometricPrompt.ERROR_NEGATIVE_BUTTON) {
                                // user clicked negative button
                            } else {
                                //TODO: Called when an unrecoverable error has been encountered and the operation is complete.
                            }
                        }

                        @Override
                        public void onAuthenticationSucceeded(@NonNull BiometricPrompt.AuthenticationResult result) {
                            super.onAuthenticationSucceeded(result);
                            //TODO: Called when a biometric is recognized.
                            Intent returnIntent = new Intent();
                            returnIntent.putExtra("isLogin", "true");
                            setResult(Activity.RESULT_OK, returnIntent);
                            finish();
                        }

                        @Override
                        public void onAuthenticationFailed() {
                            super.onAuthenticationFailed();
                            //TODO: Called when a biometric is valid but not recognized.
                        }
                    });

            final BiometricPrompt.PromptInfo promptInfo = new BiometricPrompt.PromptInfo.Builder()
                    .setTitle(getString(R.string.biometric_title))
                    .setSubtitle(getString(R.string.biometric_subtitle))
                    .setDescription(getString(R.string.biometric_description))
                    .setNegativeButtonText(getString(R.string.biometric_negative_button_text))
                    .build();
            biometricPrompt.authenticate(promptInfo);
        }


    }

    @Override
    public void onSdkVersionNotSupported() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_sdk_not_supported), Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationNotSupported() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_hardware_not_supported), Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationNotAvailable() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_fingerprint_not_available), Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationPermissionNotGranted() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_error_permission_not_granted), Toast.LENGTH_LONG).show();
    }


    @Override
    public void onAuthenticationFailed() {
//        Toast.makeText(getApplicationContext(), getString(R.string.biometric_failure), Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAuthenticationCancelled() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_cancelled), Toast.LENGTH_LONG).show();
        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            mBiometricManager.cancelAuthentication();
        }*/
    }

    @Override
    public void onAuthenticationSuccessful() {
        Toast.makeText(getApplicationContext(), getString(R.string.biometric_success), Toast.LENGTH_LONG).show();
        Intent returnIntent = new Intent();
        returnIntent.putExtra("isLogin", "true");
        setResult(Activity.RESULT_OK, returnIntent);
        finish();
    }

    @Override
    public void onAuthenticationHelp(int helpCode, CharSequence helpString) {
//        Toast.makeText(getApplicationContext(), helpString, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAuthenticationError(int errorCode, CharSequence errString) {
//        Toast.makeText(getApplicationContext(), errString, Toast.LENGTH_LONG).show();
    }


    public class GenericTextWatcher implements TextWatcher {
        private View view;
        private GenericTextWatcher(View view)
        {
            this.view = view;
        }

        @Override
        public void afterTextChanged(Editable editable) {
            // TODO Auto-generated method stub
            String text = editable.toString();
            switch(view.getId())
            {
                case R.id.ed1:
                    if(text.length()==1)
                        ed2.requestFocus();
                    break;
                case R.id.ed2:
                    if(text.length()==1)
                        ed3.requestFocus();
//                    else if(text.length()==0)
//                        editText1.requestFocus();
                    break;
                case R.id.ed3:
                    if(text.length()==1)
                        ed4.requestFocus();
//                    else if(text.length()==0)
//                        editText2.requestFocus();
                    break;
                case R.id.ed4:
                    if(text.length()==1)
                        verifyOtp();
//                    else if(text.length()==0)
//                        editText3.requestFocus();
                    break;
            }
        }

        @Override
        public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
        }
    }

    private void  verifyOtp(){

        String isLogin = "false";

        StringBuilder otp = new StringBuilder();
        otp.append(ed1.getText().toString());
        otp.append(ed2.getText().toString());
        otp.append(ed3.getText().toString());
        otp.append(ed4.getText().toString());

        newPin = otp.toString();

        if(newPin.equalsIgnoreCase(pin)){
            isLogin = "true";
        }else{
            isLogin = "false";
        }

        Log.e(TAG ,"PIN value : "+isLogin);

        Intent returnIntent = new Intent();
        returnIntent.putExtra("isLogin", isLogin);
        setResult(Activity.RESULT_OK, returnIntent);
        finish();
    }

    private  void enableFP(){
       /* Toast.makeText(getApplicationContext(), getString(R.string.biometric_success), Toast.LENGTH_LONG).show();
        Intent returnIntent = new Intent();
        returnIntent.putExtra("isLogin", "true");
        setResult(Activity.RESULT_OK, returnIntent);
        finish();*/
    }

}
