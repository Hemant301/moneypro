import 'dart:ui';

import 'package:flutter/material.dart';

var deviceWidth = 380.0;
var deviceHeight = 800.0;


// color value
var blue = const Color(0xFF1443C3);
var darkBlue = const Color(0xFF243ed2);
var lightBlue = const Color(0xFF1F87FA);
var black = Colors.black;
var lightBlack = const Color(0xFF979797);
var white = Colors.white;
var gray = const Color(0xFFE4E4E4);
var green = const Color(0xFF02BA81);
var arrowBoxBg = const Color(0xFFF9F9F9);
var editBg = const Color(0xFFF0F3F9);
var boxBg = const Color(0xFFF0F5FF);
var dividerSplash = const Color(0xFFC3D3FF);
var orange = const Color(0xFFF37021);
var dotColor = const Color(0xFFFFB523);
var walletBg = const Color(0xFF022964);
var tabBg = const Color(0xFFF2F2F2);
var red = const Color(0xffff0000);
var invBoxBg = const Color(0xFFCEE5FF);
var homeOrage = const Color(0xFFF37021);
var planBg = const Color(0xFFCEE5FF);
var bankBox = const Color (0xFFCEE5FF);
var palered = const Color (0xFFf6ad9d);
var greenLight = const Color (0xFFE7FEF1);
var homeOrageLight = const Color(0xFFF6CEB3);
var seaGreenLight = const Color(0xffadf3ee);
var greenShade = const Color(0xB2018E67);

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

//paddings
double padding = 20;
double paddingLeft = 20;
double paddingRight = 20;
double paddingTop = 20;
double paddingBottom = 20;
double avatarRadius = 45;


/*Font size used in App*/
var font8 = 8.0;
var font10 = 10.0;
var font11 = 11.0;
var font12 = 12.0;
var font13 = 13.0;
var font14 = 14.0;
var font15 = 15.0;
var font16 = 16.0;
var font18 = 18.0;
var font20 = 20.0;
var font22 = 22.0;
var font24 = 24.0;
var font26 = 26.0;

var inputFont = 16.0;

List<String> banners = [
  "assets/homeB1.jpeg",
  "assets/homeB2.jpeg",
  "assets/homeB3.jpeg",
  "assets/homeB4.jpeg",
  "assets/homeB5.jpeg",
];

List<String> productArray = [
  "assets/dummy_p_fd.jpg",
  "assets/dummy_p_bd.jpg",
];

List<String> categories = [
  "Individual",
  "Freelancers",
  "Proprietorship",
  "Company",
  "Govt Institutions",
  "Educational Institutions",
];

List<String> segments = [
  "Retail Store",
  "Kirana Store",
  "Medicine Store",
  "Grocery Store",
  "Super Market",
  "Milk/Fruits/Fish/Meat Store",
  "Garments Store",
  "Food Stall",
  "Departmental Store",
  "Sweets/ Beverage Store",
  "Pathological Lab",
  "Hospitals/ Doctors Clinic",
  "Hotels/Restaurants",
  "Bar/ Wine Shop",
  "Guest House",
  "Airport Lounges",
  "Auto/Bus/Taxi",
  "Gym/Spa/Saloon",
  "Educational Institute",
  "Govt Entities",
  "Digital Marketer",
  "Freelancers",
  "Web Developers",
  "MAtm/DMT Business",
  "Insurance Companies",
  "NBFC",
  "Cinema Hall",
];

List<String> deviceList = [
  "Select device",
  "Mantra",
  "Morpho",
];

List<String> qrPrefsList = [
  "Medium",
  "Large",
];

List<String> filterOptions = [
  "Today",
  "Last Week",
  "This Month",
  "Last 3 Months",
  "One Year",
];

List<String> memberRole = [
  "Select role",
  "Cashier",
  "Manager",
  "Accounts",
];

List<String> investorTitle = [
  "Select title",
  "Mr.",
  "Ms."
];

List<String> emiTenure = [
  "Monthly",
  "Yearly"
];

List<String> notificationSound = [
  "Select language",
  "English",
  "Hindi",
  "Bengali"
];

List<String> leaveTypes = [
  "Casual Leave",
  "Medical Leave",
  "Maternity Leave",
  "Mandatory Leave",
  "Loss of Pay",
];


var fChar;
var lChar;
var nameChar = "";
var mobileChar = "";
var roleType = "";
var companyName = "";
var currentState = "";

int imageQuality = 30;

enum BestTutorSite { imps, neft }

enum GenderOptions { male, female }

enum billMonths { one, two, three }

enum AepsOption { withdrl, miniStatement, aadharPay, balcEnq }

String patternName = r'[!@#<>?":_`~;[\]\\|=+"′″€₹£)(*&^%0-9-]';
RegExp regExpName = new RegExp(patternName);
final emailPattern = RegExp(
    r'^(([^<>()[\]\\...,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final mobilePattern = RegExp(r'(^[6-9][0-9]*$)');

final panCardPattern = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}');

final amountPattern = RegExp(r'[(?i)(?:(?:RS|INR|MRP)\.?\s?)(\d+(:?\,\d+)?(\,\d+)?(\.\d{1,2})?)]');
final bankPattern = RegExp(r'^(?i)(?:\sat\s|in\*)([A-Za-z0-9]*\s?-?\s?[A-Za-z0-9]*\s?-?\.?)');
final cardType = RegExp(r'^(?i)(?:\smade on|ur|made a\s|in\*)([A-Za-z]*\s?-?\s[A-Za-z]*\s?-?\s[A-Za-z]*\s?-?)');

//below are Strings used in App
String appName = "Moneypro";

var appUrl = "https://play.google.com/store/apps/details?id=com.moneyproapp";
String updateText = "MoneyPro recommends that you update to latest version. The current version is no longer supported";

String rupeeSymbol = "\u{20B9}";
String createAccount = "Create your account";
String firstName = "First Name";
String lastName = "Last Name";
String email = "Email";
String phoneNumber = "Phone Number";
String chooseRole = "Choose Role";
String merchant = "Merchant";
String user = "User";

String signUp = "Sign Up";
String iAccept = "I accept all terms & conditions";
String alreadyMember = "Already a Member";
String signIn = "Sign In";
String pleaseWait = "Please wait...";
String enterOtp = "Enter the OTP";
String weHaveSent = "We have sent 6 Digit OTP to your mobile number";
String continue_ = "Continue";
String resendCode = "Re-send code in ";
String set4digit = "Set 4 Digit Login PIN";
String forgotPin = "Forgot PIN?";
String success = "Success";
String pinMsg = "Your PIN number is saved. Use this PIN Number to login into app next time.";
String ok = "Ok";
String login = "Login";
String loginMsg = "Enter your mobile number, we will send you OTP to verify later";
String dntHavAcc = "Don't have a account";
String mobileCode = "+91-";
String somethingWrong = "Something went wrong, please try after sometime";
String toContact = "To Contact";
String toAccount = "To Account";
String toSelf = "To Self";
String walletBalance = "Wallet Balance";

String recharge = "Recharge &";
String utilities = "Utilities";
String financial = "Financial";
String services = "Services";

String mobilePrepaid = "Mobile Prepaid";
String mobilePostpaid = "Mobile Postpaid";
String dth = "DTH";
String electricity = "Electricity";
String fasttag = "FASTAG";
String broadband = "Broadband";
String landline = "Landline";
String lpgGas = "LPG GAS";
String irctc = "IRCTC";
String gas = "GAS";
String cableTV = "Cable Tv";
String waterBill = "Water Bill";
String dataCard = "Data Card";
String more = "More";


String microAtm = "Micro ATM";
String dmt = "DMT";
String aeps = "AEPS";
String insurance = "Insurance";
String myInvestment = "My Investment";
String applyLoan = "Apply Loan";
String giftCard = "Gift Card";
String comingSoon = "Coming Soon";
String search = "Search";
String billMsg = "Paying this bill allow MoneyPro to fetch your current & upcoming bills so you can view and pay them.";
String debitFrom = "Debit From";
String wallet = "Wallet";
String selectPayOptions = "Select Payment Options";
String recharge_ = "Recharge";
String powered_by = "Powered By";
String noUPIapp = "You don't have any upi Id registered with any bank. Kindly choose other payment options.";
String transactionId = "Transaction Id";
String mode_ = "Mode";
String refIdd = "Ref Id.";
String remarks = "Remarks";
String customerCare = "Customer Care";
String customerEmail = "support@moneypropay.com";
String merchantMob = "Merchant Mobile No.";
String totalValue = "Total value with";

String investment = "Investment";
String earning_ = "Earning";
String addMoney = "Add Money";
String requestWithdrawal = "Request Withdrawal";
String portfolio = "Portfolio";
String acStatement = "A/c Statement";
String faqs = "FAQ's";
String callUs = "Call us 24x7 Helpdesk";
String helplineNum = "033 40443429";
String autoInvest = "QR Money Auto Invest";
String enterAmount = "Enter amount";
String youCanWithdraw = "You can withdraw up to ";
String submit = "Submit";
String myAccount = "My Account";
String reqStatement = "Request Statement";

String keyTrmsNCB = "Key Terms of NBFC - P2P";
String note9 = "Upto 9% assured Return on Investment";
String note10 = "Become Investor in India’s Newest asset class";
String note11 = "Individual Portfolio performance may vary";
String note12 = "Liquidity may be solicited but not assured";
String note13 = "Become Lender with NBFC – P2P";
String note14 = "India’s finest Investment Model";
String channelPartner = "Channel Partner";
String iAgree = "I agree with the Terms & Conditions";
String accept = "Accept";
String note17 = "I/We hereby authorize Moneypro and consent to invest/settle my/our collected transaction(s) amount(s), to such value added services that is P2P lending and Investment services under RBI P2P NBFC provided by Moneypro, time to time.";
String note18 = "I understand and agree that:";
String note19 = "- I have not invested more than 50,00,000 across all P2P investment platform in India.";
String note20 = "- I will not lend more than 50,000 across all P2P platform including Lendbox.";
String note21 = "- Lendbox will assured my Investment in best possible ways through secondary sales of Loan.";
String note22 = "- Interest is indicative and may vary depends upon Loan profiles.";
String accountType = "Account Type";
String mandatory = "(mandatory)";
String noExit = "You have to complete your on-boarding process first to use the app features, if you cancel the process in the middle, you are not able to use app and exit the app.";
String exitMsg = "If you go back or exit process in the middle, then you have to re-start from first step.";
String getStarted = "Get Started";
String businessDetail = "Business Details";
String businessTag = "Let people know more about your business the go";
String step1 = "Step 1";
String step2 = "Step 2";
String businessName = "Business Name";
String customerWould = "Customer would see this name on their MoneyPro app.";
String businessCat = "Business Category";
String selectCat = "Select your category for customers to discover you quickly";
String businessSeg = "Business Segment";
String selectSeg = "Select your segment for customers to discover you quickly";
String businessLogo = "Business Logo/Shop Image";
String businessMake = "Make your business stand out";
String dosNdont = "Do's and Don't";
String verifyBusiness1 = "Verify Business for ";
String verifyBusiness2 = "using any one documents";
String gstEnable = "*GSTIN unable unlimited payments";
String gstIN = "Using GSTIN:";
String enterGSTno = "Enter GSTIN Number";
String useOtherDoc = "Use any other document";
String docType = "Document name";
String imgCapture = "(Captured the image of selected document)";
String panWillVerify = "PAN will verify the identity of the contact person";
String nameAppear = "(Name will be appear form PAN data)";
String dob = "Select your date";
String selfiContact = "Selfi of the Contact Person";
String accDetails = "Enter Bank Account Details";
String startAccept = "Start accepting payments";
String paymentOption =
    "Customers would be able to pay you using below options:";
String bhimUpi = "BHIM UPI";
String netCharge = "Net charge on payment: 0%";
String noetAll = "Note : All rates are exclusive of taxes";
String downloadQRUPI = "Generate UPI QR";
String yourMonthly =
    "Earn Instant 1% cashback on every transactions and also enjoy upto 9% Interest on wallet Balance.";
String yahYouCan =
    "Hurry!! You can start accepting payments using UPI QR from any APP";
String payPurchase = "Purchase & Payment";

String muncipleTax = "Munciple Taxes";
String housingSociety = "Housing Society";
String education = "Education";
String challen = "Challan";
String entertainment = "Entertainment";
String hospital = "Hospital & Pathology";
String brandVoucher = "Brand Voucher";
String mGiftCard = "MoneyPro Gift Card";
String loadrepay = "Loan Repayment";
String subscription = "Subscription";
String muncipalServices = "Muncipal Services";
String club = "Clubs & Assiciations";

String plan = "PLAN";
String validity = "VALIDITY";
String viewDeatil = "View Details";
String buy = "Buy";
String transId = "Trans ID";

String investmentAc = "Investment A/c";
String upiQRWallet = "UPI QR wallet";

String settlement = "Settlement";

String walletHistory = "Wallet History";
String viewWalletTrnx = "View Wallet Txns";
String walletSummary = "Wallet Summary";
String viewSummaryWallet = "View Summary of Wallet";
String opts = "OPts";
String loyaltyPoints = "Loyalty Point";
String moveToBank = "Move to Bank";
String transferFundBank = "Transfer Fund to Bank";

String myQRCode = "My QR Code";
String requestQR = "Request QR";
String myUPIId = "My UPI ID";
String myAddress = "My Address";
String manageBankAccount =
    "Manage Bank Accounts"; //--- Once clicked this one page will appear where merchant can add multiple bank accounts.
String notification = "Notifications";
String addTeam = "Add Team";
String audioAlert = "Audio Alert"; //-----Enable or Disable Button
String changePin = "Change Pin";
String screenLock = "Fingerprint"; //----- Enable/Disable Button
String policyTerms = "Policy and Terms";
String complaint = "Complaint";
String logout = "Logout";
String empSection = "Employee Section";
String lic = "LIC";

String youNotAuthorize = "You are not authorize to use this service";
String wouldApply = "Would you like to apply?";
String reqPending = "Your request is pending. Please wait or contact to Customer Care.";
String addASender = "Add a Sender";
String moneyProDMT = "MoneyPro DMT";
String howToUser = "How to Use";
String favourites = "Favourites";
String transactions = "Transactions";
String searchSender = "Search a Sender by Mobile number";
String approved = "Approved";
String favourite = "Favourite";
String addFavourite = "Add to Favourite";
String addBeneficiary = "Add Beneficiary";
String searchBeneficiary = "Search Beneficiary by A/C Number";
String viewTransaction = "View Transaction";
String enterBeneficiary = "Enter Beneficiary Details";
String ifscTag = "This is the common IFSC of all branches of this bank";
String bankMob = "MOBILE NO. (Optional)";
String bankRemarks = "REMARKS (Optional)";
String upgradeKyc = "Upgrade KYC";
String imps = "IMPS";
String neft = "NEFT";
String transferMoney = "Transfer Money";

String senderWallet = "Sender's Wallet";
String totalAdhikariCost = "Total Customer Charge";
String chargesFromCustomer = "T. charges from customer";
String gstTag = "(Inclusive of applicable GST)";
String adhikariComission = "Merchant Revenue(Excluding TDS@5%)";
String subjectTDS = "(Subject to TDS @5%)";
String cancel = "Cancel";
String confirm = "Confirm";
String addMoneyToWallet = "Would you like to add money to your wallet?";
String transferringMoney = "Transferring Money";

String note1 = "1) Only E - aadhar will be accepted.";
String note2 = "2) Mobile Number in Aadhaar & Portal must be the same.";
String note3 = "3) It must have a download date of not older than 3 days.";
String note4 =
    "4) The aadhar's first 8 digits must be masked.(i.e only the last 4 digits should be visible for KYC.";
String note5 =
    "5) Download MASKED E-Aadhaar from https://eaadhaar.uidai.gov.in (not older than 3 days)";
String note6 = "6)Take a print and self-attest the copy of E-Aadhaar.";
String note7 =
    "7) Scan and upload the self-attested copy here (only JPG / JPEG / PNG / PDF formats)";

String uploadFile_ = "Upload File";
String upto5 = "(Upto 5MB)";
String withdraw = "Withdraw";
String balcEnquiry = "Balc. Enquiry";
String miniState = "Mini Statement";
String withdrawNow = "Withdraw Now";
String checkBalc = "Check Balance";
String resendOtp = "Resend OTP";
String settlements = "Settlements";

String addTeamMsg = "Hassled by repeated calls from staff to confirm payments? Add member in your team and allow them to check payments directly on their phone.";

String termNCondition = "Terms & conditions";
String wel_1 = "This welcome offer is non transferable.";
String wel_2 = "Welcome offer can be used only to avail services within Moneypro app";
String wel_3 = "Recharge- For Prepaid mobiles 3% or max Rs.30 can be used. Minimum recharge amount should be 399 or above.";
String wel_4 = "Recharge- For DTH recharge 3% or max Rs.30 can be used. Minimum recharge amount should be 300 or above";
String wel_5 = "Fastag Recharge- For any amount of FASTAG recharge Rs. 10 will be used by default.";
String wel_6 = "Bill Payments- For any other bill payments Rs.5 will be applicable from welcome offer.";
String wel_7 = "No other offers will be clubbed with welcome offer.";
String wel_8 = "Time duration- There is no time limit to avail this offer";
String wel_9 ="Credited in your wallet as\nWELCOME OFFER\nuse this amount to recharge or pay your bills";

String pan1 = "Now turn your shop to a PAN Center";
String pan3 = "Instant Pan Generation";
String pan4 = "No paper work. No hard copy documents required";
String pan5 = "Charges Rs. 107 per application";
String empActions = "Employee Actions";

String axis_1 = "Get the Full Power Digital Current Account using video KYC in 4 easy steps";
String axis_2 = "The Video KYC feature breings the world of banking to your home";
String axis_3 = "PAN and Aadhaar verification";
String axis_4 = "Fill your personal details";
String axis_5 = "KYC verification via video call";
String axis_6 = "Fund your account";
String axis_7 = "Availability of video KYC Agents on business days: 9:00 AM - 8:00 PM";

String upstox_1 = "Simple and smart way to start investing in Mutual Funds";
String upstox_2 = "70 lakh+";
String upstox_3 = "Happy investors";
String upstox_4 = "Don't let brokerage eat into your profits!";
String upstox_5 = "Brokerage";
String upstox_6 = "AMC Charges";
String upstox_7 = "On investing in Mutual Funds and IPOs";
String upstox_8 = "Demat account maintenance charges!";

String regPay = "Regular Payment";
String duePay = "Overdue Payment";
String thankKycMsg = "Your KYC has been done. Now you can send and receive money from your friends & family";
String investorKycMsg = "Your Investor KYC is Complete.";
String addTeamNote = " Note: You may add maximum 5 staff's.";

String mycard_1 = "Say Hi to My Card";
String mycard_2 = "India's Best My Card";
String mycard_3 = "Exclusive card";
String mycard_4 = "Why settle for another cards?";
String mycard_5 = "ZERO joining or annual fees";
String mycard_6 = "Lifetime FREE";
String mycard_7 = "5X reward points";
String mycard_8 = "On Top 2 spend categories";
String mycard_9 = "In-App controls";
String mycard_10 = "Security in your hand";
String mycard_11 = "Get My Card";
String mycard_12 = "By clicking on Get My Card, you acknowledge that you're applying for My Card and approvel will as per our credit policy.";

String notAuthoziePayment = "You are not authorised for this action. Please contact customer support for more details. Thank You.";
String notApproved="Your account is not activated. Please wait for 2hrs to get the account activated. Thanks you";
String cropImage = "Crop Image";

String status500 = "Internal Server Error";
String panCardMsg  = "For kyc verification purpose only";

String fintag = "*Earn upto 250 rupees instant discount every time";
String rechTag = "*Earn upto 5% instant discount on Mobile & DTH recharge";
String sellShareText = "Open your Demat & Trading account on ICICIDirect Markets App, India's fastest & leading reliable platform.\nTab the link now:\n\n$appUrl";
String sellLeadText = "Lead is added & status is updated within 7 working days. If no update is received then proceed to raise's dispute.";


//String response = "{"status": 1,"response": {"status": true,"ackno": "40301812","datetime": "2022-05-1715: 58: 57","balanceamount": "10972.94","bankrrn": "213715254575","bankiin": "ICICI Bank","message": "Request Completed","errorcode": "00","ministatement": [{"date": "17/05/2022","txnType": "Dr","amount": "50.0","narration": "ADF/2137"},{"date": "17/05/2022","txnType": "Dr","amount": "50.0","narration": "ADF/2137"},{"date": "17/05/2022","txnType": "Dr","amount": "50.0","narration": "ADF/2137"},{"date": "17/05/2022","txnType": "Dr","amount": "50.0","narration": "NFI/CASH"}],"response_code": 1}}";


Map mapResponse = {
  "status": 1,
  "response": {
    "status": true,
    "ackno": "40301812",
    "datetime": "2022-05-1715: 58: 57",
    "balanceamount": "10972.94",
    "bankrrn": "213715254575",
    "bankiin": "ICICI Bank",
    "message": "Request Completed",
    "errorcode": "00",
    "ministatement": [
      {
        "date": "17/05/2022",
        "txnType": "Dr",
        "amount": "50.0",
        "narration": "ADF/2137"
      },
      {
        "date": "17/05/2022",
        "txnType": "Dr",
        "amount": "50.0",
        "narration": "ADF/2137"
      },
      {
        "date": "17/05/2022",
        "txnType": "Dr",
        "amount": "50.0",
        "narration": "ADF/2137"
      },
      {
        "date": "17/05/2022",
        "txnType": "Dr",
        "amount": "50.0",
        "narration": "NFI/CASH"
      }
    ],
    "response_code": 1
  }
};