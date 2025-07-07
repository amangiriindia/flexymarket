import 'package:shared_preferences/shared_preferences.dart';

class UserConstants {
  // Keys for SharedPreferences (constant)
  static const String AUTH_TOKEN_KEY = 'authToken';
  static const String BANK_STATUS_KEY = 'bankStatus';
  static const String USER_ID_KEY = 'userId';
  static const String EMAIL_KEY = 'email';
  static const String PHONE_KEY = 'phone';
  static const String NAME_KEY = 'name';
  static const String PROFILE_IMAGE_KEY = 'profileImage';
  static const String ADDRESS_KEY = 'address';
  static const String CITY_KEY = 'city';
  static const String STATE_KEY = 'state';
  static const String COUNTRY_KEY = 'country';
  static const String POSTAL_CODE_KEY = 'postalCode';
  static const String KYC_STATUS_KEY = 'kycStatus';
  static const String TWO_FA_STATUS_KEY = 'twoFAStatus';
  static const String REFERRAL_CODE_KEY = 'referralCode';
  static const String AADHAR_PROOF_KEY = 'aadharProof';
  static const String AADHAR_NUMBER_KEY = 'aadharNumber';
  static const String DEFAULT_NAME = "";
  static const String DEFAULT_EMAIL = "user@credbull.in";
  static const String DEFAULT_PHONE = "";
  static const String DEFAULT_PROFILE_IMAGE = "";
  static const String DEFAULT_ADDRESS = "";
  static const String DEFAULT_CITY = "";
  static const String DEFAULT_STATE = "";
  static const String DEFAULT_COUNTRY = "";
  static const String DEFAULT_POSTAL_CODE = "";
  static const String DEFAULT_KYC_STATUS = "";
  static const String DEFAULT_TWO_FA_STATUS = "";
  static const String DEFAULT_REFERRAL_CODE = "";
  static const String DEFAUT_AADHAR_PROOF = "";
  static const String DEFAUT_AADHAR_NUMBER = "";
  static String? TOKEN;
  static String? BANK_STATUS;
  static String? USER_ID;
  static String EMAIL = DEFAULT_EMAIL;
  static String PHONE = DEFAULT_PHONE;
  static String NAME = DEFAULT_NAME;
  static String PROFILE_IMAGE = DEFAULT_PROFILE_IMAGE;
  static String ADDRESS = DEFAULT_ADDRESS;
  static String CITY = DEFAULT_CITY;
  static String STATE = DEFAULT_STATE;
  static String COUNTRY = DEFAULT_COUNTRY;
  static String POSTAL_CODE = DEFAULT_POSTAL_CODE;
  static String KYC_STATUS = DEFAULT_KYC_STATUS;
  static String TWO_FA_STATUS = DEFAULT_TWO_FA_STATUS;
  static String REFERRAL_CODE = DEFAULT_REFERRAL_CODE;
  static String AADHAR_PROOF = DEFAUT_AADHAR_PROOF;
  static String AADHAR_NUMBER = DEFAUT_AADHAR_NUMBER;

  // Method to load user data from SharedPreferences into static variables
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve user data from SharedPreferences and assign to static variables
    TOKEN = prefs.getString(AUTH_TOKEN_KEY);
    BANK_STATUS = prefs.getString(BANK_STATUS_KEY);
    USER_ID = prefs.getString(USER_ID_KEY);
    EMAIL = prefs.getString(EMAIL_KEY) ?? DEFAULT_EMAIL;
    PHONE = prefs.getString(PHONE_KEY) ?? DEFAULT_PHONE;
    NAME = prefs.getString(NAME_KEY) ?? DEFAULT_NAME;
    PROFILE_IMAGE = prefs.getString(PROFILE_IMAGE_KEY) ?? DEFAULT_PROFILE_IMAGE;
    ADDRESS = prefs.getString(ADDRESS_KEY) ?? DEFAULT_ADDRESS;
    CITY = prefs.getString(CITY_KEY) ?? DEFAULT_CITY;
    STATE = prefs.getString(STATE_KEY) ?? DEFAULT_STATE;
    COUNTRY = prefs.getString(COUNTRY_KEY) ?? DEFAULT_COUNTRY;
    POSTAL_CODE = prefs.getString(POSTAL_CODE_KEY) ?? DEFAULT_POSTAL_CODE;
    KYC_STATUS = prefs.getString(KYC_STATUS_KEY) ?? DEFAULT_KYC_STATUS;
    TWO_FA_STATUS = prefs.getString(TWO_FA_STATUS_KEY) ?? DEFAULT_TWO_FA_STATUS;
    REFERRAL_CODE = prefs.getString(REFERRAL_CODE_KEY) ?? DEFAULT_REFERRAL_CODE;
    AADHAR_PROOF = prefs.getString(AADHAR_PROOF_KEY) ?? DEFAUT_AADHAR_PROOF;
    AADHAR_NUMBER = prefs.getString(AADHAR_NUMBER_KEY) ?? DEFAUT_AADHAR_NUMBER;
  }

  // Method to store user data to SharedPreferences
  static Future<void> storeUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = data['data']['userData'];

    // Store user data in SharedPreferences
    await prefs.setString(AUTH_TOKEN_KEY, data['data']['token'] ?? '');
    await prefs.setString(
        BANK_STATUS_KEY, userData['isBankVerified'].toString() ?? '');
    await prefs.setString(USER_ID_KEY, userData['id'].toString() ?? '');
    await prefs.setString(EMAIL_KEY, userData['email'] ?? DEFAULT_EMAIL);
    await prefs.setString(
        PHONE_KEY, '${userData['countryCode'] ?? ''}${userData['mobile'] ?? ''}');
    await prefs.setString(NAME_KEY, userData['name'] ?? DEFAULT_NAME);
    await prefs.setString(PROFILE_IMAGE_KEY, DEFAULT_PROFILE_IMAGE);
    await prefs.setString(ADDRESS_KEY, userData['address'] ?? DEFAULT_ADDRESS);
    await prefs.setString(CITY_KEY, DEFAULT_CITY);
    await prefs.setString(STATE_KEY, DEFAULT_STATE);
    await prefs.setString(COUNTRY_KEY, userData['country'] ?? DEFAULT_COUNTRY);
    await prefs.setString(POSTAL_CODE_KEY, DEFAULT_POSTAL_CODE);
    await prefs.setString(
        KYC_STATUS_KEY, userData['isKycVerified'].toString() ?? DEFAULT_KYC_STATUS);
    await prefs.setString(TWO_FA_STATUS_KEY, DEFAULT_TWO_FA_STATUS);
    await prefs.setString(REFERRAL_CODE_KEY, DEFAULT_REFERRAL_CODE);

    // Reload data into static variables
    await loadUserData();
  }

  static Future<void> updateTwoFAStatus(String twoFAStatus) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the 2FA status in SharedPreferences
    await prefs.setString(TWO_FA_STATUS_KEY, twoFAStatus);

    // Update the static variable
    TWO_FA_STATUS

    = twoFAStatus;

    // Log the update for debugging
    print("Updated Two FA Status: $twoFAStatus");
  }

  static Future<void> updateKycStatus(String kycStatus) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the KYC status in SharedPreferences
    await prefs.setString(KYC_STATUS_KEY, kycStatus);

    // Update the static variable
    KYC_STATUS = kycStatus;

    // Log the update for debugging
    print("Updated KYC Status: $kycStatus");
  }

  static Future<void> updateBankStatus(String bankStatus) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the bank status in SharedPreferences
    await prefs.setString(BANK_STATUS_KEY, bankStatus);

    // Update the static variable
    BANK_STATUS = bankStatus;

    // Log the update for debugging
    print("Updated Bank Status: $bankStatus");
  }

  static Future<void> updateAadharNumber(String aadharNumber) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the Aadhar number in SharedPreferences
    await prefs.setString(AADHAR_NUMBER_KEY, aadharNumber);

    // Update the static variable
    AADHAR_NUMBER = aadharNumber;

    // Log the update for debugging
    print("Updated Aadhar Number: $aadharNumber");
  }

  static Future<void> updateAadharProof(String aadharProof) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the Aadhar proof in SharedPreferences
    await prefs.setString(AADHAR_PROOF_KEY, aadharProof);

    // Update the static variable
    AADHAR_PROOF = aadharProof;

    // Log the update for debugging
    print("Updated Aadhar Proof: $aadharProof");
  }
}