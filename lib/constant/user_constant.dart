import 'package:shared_preferences/shared_preferences.dart';

class UserConstants {
  // Keys for SharedPreferences (constant)
  static const String AUTH_TOKEN_KEY = 'authToken';
  static const String BANK_STATUS_KEY = 'bankStatus';
  static const String USER_ID_KEY = 'userId';
  static const String EMAIL_KEY = 'email';
  static const String PHONE_KEY = 'phone';
  static const String NAME_KEY = 'name';
  static const String ADDRESS_KEY = 'address';
  static const String COUNTRY_KEY = 'country';
  static const String KYC_STATUS_KEY = 'kycStatus';
  static const String TWO_FA_STATUS_KEY = 'twoFAStatus';
  static const String IS_IB_KEY = 'isIbStatus';

  // Default values
  static const String DEFAULT_NAME = "";
  static const String DEFAULT_EMAIL = "user@credbull.in";
  static const String DEFAULT_PHONE = "";
  static const String DEFAULT_ADDRESS = "";
  static const String DEFAULT_COUNTRY = "";
  static const String DEFAULT_KYC_STATUS = "";
  static const String DEFAULT_TWO_FA_STATUS = "";
  static const String DEFAULT_IS_IB_STATUS = "";

  // Static variables
  static String? TOKEN;
  static String? BANK_STATUS;
  static String? USER_ID;
  static String EMAIL = DEFAULT_EMAIL;
  static String PHONE = DEFAULT_PHONE;
  static String NAME = DEFAULT_NAME;
  static String ADDRESS = DEFAULT_ADDRESS;
  static String COUNTRY = DEFAULT_COUNTRY;
  static String KYC_STATUS = DEFAULT_KYC_STATUS;
  static String TWO_FA_STATUS = DEFAULT_TWO_FA_STATUS;
  static String IS_IB_STATUS = DEFAULT_IS_IB_STATUS;

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
    ADDRESS = prefs.getString(ADDRESS_KEY) ?? DEFAULT_ADDRESS;
    COUNTRY = prefs.getString(COUNTRY_KEY) ?? DEFAULT_COUNTRY;
    KYC_STATUS = prefs.getString(KYC_STATUS_KEY) ?? DEFAULT_KYC_STATUS;
    TWO_FA_STATUS = prefs.getString(TWO_FA_STATUS_KEY) ?? DEFAULT_TWO_FA_STATUS;
    IS_IB_STATUS = prefs.getString(IS_IB_KEY) ?? DEFAULT_IS_IB_STATUS;
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
    await prefs.setString(ADDRESS_KEY, userData['address'] ?? DEFAULT_ADDRESS);
    await prefs.setString(COUNTRY_KEY, userData['country'] ?? DEFAULT_COUNTRY);
    await prefs.setString(
        KYC_STATUS_KEY, userData['isKycVerified'].toString() ?? DEFAULT_KYC_STATUS);
    await prefs.setString(
        TWO_FA_STATUS_KEY, userData['isMfaAdded'].toString() ?? DEFAULT_TWO_FA_STATUS);
    await prefs.setString(
        IS_IB_KEY, userData['isIb'].toString() ?? DEFAULT_IS_IB_STATUS);

    // Reload data into static variables
    await loadUserData();
  }

  // Method to update 2FA status
  static Future<void> updateTwoFAStatus(String twoFAStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TWO_FA_STATUS_KEY, twoFAStatus);
    TWO_FA_STATUS = twoFAStatus;
    print("Updated Two FA Status: $twoFAStatus");
  }

  // Method to update KYC status
  static Future<void> updateKycStatus(String kycStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KYC_STATUS_KEY, kycStatus);
    KYC_STATUS = kycStatus;
    print("Updated KYC Status: $kycStatus");
  }

  // Method to update bank status
  static Future<void> updateBankStatus(String bankStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(BANK_STATUS_KEY, bankStatus);
    BANK_STATUS = bankStatus;
    print("Updated Bank Status: $bankStatus");
  }

  // Method to update IB status
  static Future<void> updateIsIbStatus(String isIbStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(IS_IB_KEY, isIbStatus);
    IS_IB_STATUS = isIbStatus;
    print("Updated IB Status: $isIbStatus");
  }
}