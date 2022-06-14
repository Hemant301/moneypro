import 'package:shared_preferences/shared_preferences.dart';

saveUserLogin(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLogin", value);
}

getUserLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool("isLogin") ?? false);
}

removeUserLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("isLogin");
}

saveToken(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", value);
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("token") ?? "");
}

saveLoginId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("loginId", value);
}

getLoginId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("loginId") ?? "");
}

saveFirstName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("first_name", value);
}

getFirstName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("first_name") ?? "");
}

saveLastName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("last_name", value);
}

getLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("last_name") ?? "");
}

saveEmail(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email", value);
}

getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("email") ?? "");
}

saveMobile(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("mobile", value);
}

getMobile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("mobile") ?? "");
}

saveDOB(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("dob", value);
}

getDOB() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("dob") ?? "");
}

saveComapanyName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("company_name", value);
}

getComapanyName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("company_name") ?? "");
}

saveCompanyType(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("company_type", value);
}

getCompanyType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("company_type") ?? "");
}

saveBusinessSegment(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("business_segment", value);
}

getBusinessSegment() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("business_segment") ?? "");
}

saveCompanyAddress(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("company_address", value);
}

getCompanyAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("company_address") ?? "");
}

saveContactName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("contact_name", value);
}

getContactName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("contact_name") ?? "");
}

saveGSTNo(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("gst_no", value);
}

getGSTNo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("gst_no") ?? "");
}

savePANNo(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("pan_no", value);
}

getPANNo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("pan_no") ?? "");
}

saveKYCStatus(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("kyc_status", value);
}

getKYCStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("kyc_status") ?? "");
}

saveRole(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("role", value);
}

getRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("role") ?? "");
}

saveMerchantID(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("mherchant_id", value);
}

getMerchantID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("mherchant_id") ?? "");
}

saveWalletBalance(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("wallet_bal", value);
}

getWalletBalance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("wallet_bal") ?? "0");
}

savePIN(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("pin", value);
}

getPIN() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("pin") ?? "0");
}

saveRetailerUserCode(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("retailer_user_code", value);
}

getRetailerUserCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("retailer_user_code") ?? "0");
}

saveRetailerOnBoardUser(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("retailer_onboard_user", value);
}

getRetailerOnBoardUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("retailer_onboard_user") ?? "0");
}

saveQRtBalance(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("qr_wallet", value);
}

getQRBalance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("qr_wallet") ?? "0");
}

saveDmtStatus(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("dmt", value);
}

getDmtStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("dmt") ?? "0");
}

saveMatmStatus(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("matm", value);
}

getMatmStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("matm") ?? "0");
}

saveAepsStatus(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("aeps", value);
}

getAepsStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("aeps") ?? "0");
}

saveAccountNumber(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("account_no", value);
}

getAccountNumber() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("account_no") ?? "0");
}

saveBranchCity(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("branch", value);
}

getBranchCity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("branch") ?? "0");
}

saveIFSC(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("ifsc", value);
}

getIFSC() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("ifsc") ?? "0");
}

saveAPESToken(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("aeps_token", value);
}

getAPESToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("aeps_token") ?? "0");
}

saveMATMMerchantId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("mATMid", value);
}

getMATMMerchantId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("mATMid") ?? "");
}

saveVirtualAccId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("virtual_acc_id", value);
}

getVirtualAccId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("virtual_acc_id") ?? "");
}

saveVirtualAccNo(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("virtual_acc_number", value);
}

getVirtualAccNo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("virtual_acc_number") ?? "");
}

saveVirtualAccIFSC(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("virtual_acc_ifsc", value);
}

getVirtualAccIFSC() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("virtual_acc_ifsc") ?? "");
}

saveVPA(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("vpa", value);
}

getVPA() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("vpa") ?? "");
}

saveCity(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("city", value);
}

getCity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("city") ?? "");
}

saveAdhar(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("adhar", value);
}

getAdhar() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("adhar") ?? "");
}

savePinCode(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("pincode", value);
}

getPinCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("pincode") ?? "");
}

saveOutLetId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("outlet_id", value);
}

getOutLetId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("outlet_id") ?? "");
}

saveState(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("state", value);
}

getState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("state") ?? "");
}

saveQRMaxAmt(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("qr_withdrawl_amount", value);
}

getQRMaxAmt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("qr_withdrawl_amount") ?? "");
}

saveFingerprint(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("f_enable", value);
}

getfingerprint() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool("f_enable") ?? false);
}

saveAudioSound(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("audio_enable", value);
}

getAudioSound() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool("audio_enable") ?? true);
}

removeAllPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

saveDistrict(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("district", value);
}

getDistrict() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("district") ?? "");
}

saveEmployeeId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("employee_id", value);
}

getEmployeeId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("employee_id") ?? "");
}

saveQRInvestor(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("qr_money_invst", value);
}

getQRInvestor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("qr_money_invst") ?? "");
}

saveAEPSKyc(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("aeps_kyc", value);
}

getAEPSKyc() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("aeps_kyc") ?? "");
}

saveAEPSMerchantId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("aeps_merchant_id", value);
}

getAEPSMerchantId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("aeps_merchant_id") ?? "");
}

saveMatmAepsActive(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("matm_aeps_active", value);
}

getMatmAepsActive() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("matm_aeps_active") ?? "0");
}

saveBankName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("bank_name", value);
}

getBankName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("bank_name") ?? "");
}

saveWelcomeAmt(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("welcome_amount", value);
}

getWelcomeAmt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("welcome_amount") ?? "0");
}

/*saveAESPTransId(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("aeps_trans_id", value);
}

getAESPTransId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("aeps_trans_id") ?? "");
}*/

saveContactCount(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("contact_count", value);
}

getContactCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getInt("contact_count") ?? 0);
}

saveLatitude(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble("lat", value);
}

getLatitude() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getDouble("lat") ?? 0.0);
}

saveLongitude(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble("lng", value);
}

getLongitude() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getDouble("lng") ?? 0.0);
}

saveWhastAppValue(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("wp_msg", value);
}

getWhastAppValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("wp_msg") ?? "No");
}

savelocState(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("app_local_state", value);
}

getlocState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("app_local_state") ?? "");
}

saveSettlementType(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("settlement_type", value);
}

getSettlementType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("settlement_type") ?? "");
}

saveApproved(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("approved", value);
}

getApproved() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("approved") ?? "");
}

saveQRDisplayName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("qr_display_name", value);
}

getQRDisplayName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("qr_display_name") ?? "");
}

saveBranchCreate(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("branch_create", value);
}

getBranchCreate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("branch_create") ?? "0");
}

saveAdsCount(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("ads_count", value);
}

getAdsCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getInt("ads_count") ?? 0);
}

saveCurrentDate(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("current_date", value);
}

getCurrentDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("current_date") ?? "0");
}

saveLngType(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lng_type", value);
}

getLngType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("lng_type") ?? "en");
}

saveFirstRun(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("firstRun", value);
}

getFirstRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool("firstRun") ?? false);
}

saveUserType(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("reg_type", value);
}

getUserType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("reg_type") ?? "");
}

saveHolderName(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("holder_name", value);
}

getHolderName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getString("holder_name") ?? "");
}
