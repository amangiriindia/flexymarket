// import 'package:flexy_markets/constant/user_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../constant/app_color.dart';
// import '../../providers/theme_provider.dart';
// import '../../service/apiservice/wallet_service.dart';
// import '../../widget/common/main_app_bar.dart';
// import '../ib/ib_request_screen.dart';
// import '../metatrade/create_meta_trade_screen.dart';
// import '../metatrade/meta_trade_list_screen.dart';
// import '../profile/edit_profile_screen.dart';
// import '../profile/login_history_screen.dart';
// import '../support/my_tickets_screen.dart';
// import '../profile/support_screen.dart';
// import '../transation/deposit_screen.dart';
// import '../transation/transation_history_screen.dart';
// import '../auth/welcome_screen.dart';
// import '../profile/about_us_screen.dart';
// import '../profile/feedback_screen.dart';
// import '../transation/withdraw_fund_screen.dart';
// import '../transation/withdraw_screen.dart';
// import '../twofa/twofa_setup_screen.dart';
// import '../user/bank_deatils_screen.dart';
// import '../user/change_password_screen.dart';
// import '../user/document_upload_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
//   final WalletService _walletService = WalletService();
//   final int referrals = 28; // Retained as hardcoded since not in API response
//   Map<String, dynamic>? _assetData;
//   bool _isLoading = false;
//   String? _errorMessage;
//   int _retryCount = 0;
//   static const int _maxRetries = 3;
//
//   late AnimationController _animationController;
//   late List<Animation<double>> _fadeAnimations;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimations = List.generate(
//       2, // For the two MT5 rows
//           (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(
//           parent: _animationController,
//           curve: Interval(0.1 * index, 0.3 + 0.1 * index, curve: Curves.easeIn),
//         ),
//       ),
//     );
//     _animationController.forward();
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     if (_retryCount >= _maxRetries) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Maximum retry attempts reached. Please try again later or contact support.';
//       });
//       _showSnackBar(_errorMessage!, AppColors.red);
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       final userDataResponse = await _walletService.fetchUserData();
//       if (userDataResponse['status'] == true) {
//         setState(() {
//           _assetData = userDataResponse['data']['assetData'];
//           _isLoading = false;
//           _retryCount = 0;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = userDataResponse['message'] ?? 'Failed to fetch user data';
//           _retryCount++;
//         });
//         _showSnackBar(_errorMessage!, AppColors.red);
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString().contains('EACCES')
//             ? 'Server error: Unable to process request. Please try again or contact support.'
//             : 'Error fetching data: ${e.toString()}';
//         _retryCount++;
//       });
//       _showSnackBar(_errorMessage!, AppColors.red);
//     }
//   }
//
//   void _showSnackBar(String message, Color backgroundColor) {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//             fontSize: 14.sp,
//           ),
//         ),
//         backgroundColor: backgroundColor,
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//         action: _retryCount < _maxRetries
//             ? SnackBarAction(
//           label: 'Retry',
//           textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//           onPressed: _fetchData,
//         )
//             : null,
//       ),
//     );
//   }
//
//   // Helper function to safely extract num values from _assetData
//   double _getBalanceValue(String key) {
//     if (_assetData == null || _assetData![key] == null) {
//       return 0.0;
//     }
//     return (_assetData![key] is num) ? (_assetData![key] as num).toDouble() : 0.0;
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
//       appBar: const MainAppBar(
//         title: 'Profile',
//         showBackButton: true,
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 16.h),
//                     _buildBalanceSection(isDarkMode),
//                     SizedBox(height: 20.h),
//                     _buildPersonalDetailsSection(isDarkMode),
//                     SizedBox(height: 20.h),
//                     _buildComplianceSection(isDarkMode),
//                     SizedBox(height: 20.h),
//                     _buildSupportSection(isDarkMode),
//                     SizedBox(height: 20.h),
//                     Text(
//                       "Logged in as ${UserConstants.EMAIL}",
//                       style: TextStyle(
//                         color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     _buildLogoutButton(isDarkMode),
//                     SizedBox(height: 20.h),
//                   ],
//                 ),
//               ),
//             ),
//             if (_isLoading)
//               Container(
//                 color: isDarkMode
//                     ? AppColors.darkBackground.withOpacity(0.7)
//                     : AppColors.lightBackground.withOpacity(0.7),
//                 child: Center(
//                   child: CircularProgressIndicator(
//                     color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                     strokeWidth: 3,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBalanceSection(bool isDarkMode) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.sp),
//       decoration: BoxDecoration(
//         color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//         borderRadius: BorderRadius.circular(12.r),
//         border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
//         boxShadow: isDarkMode
//             ? null
//             : [
//           BoxShadow(
//             color: AppColors.lightShadow.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30.r,
//                 backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                 child: Icon(
//                   Icons.person,
//                   size: 30.sp,
//                   color: AppColors.white,
//                 ),
//               ),
//
//               SizedBox(width: 16.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     UserConstants.NAME,
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                   ),
//                   Text(
//                     '${UserConstants.USER_ID}',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           Text(
//             'Wallet Overview',
//             style: TextStyle(
//               color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             _errorMessage != null
//                 ? 'Balance Unavailable'
//                 : '\$${_getBalanceValue('mainBalance').toStringAsFixed(2)} USD',
//             style: TextStyle(
//               color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//               fontSize: 24.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (_errorMessage != null) ...[
//             SizedBox(height: 8.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 TextButton(
//                   onPressed: _fetchData,
//                   child: Text(
//                     'Retry',
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Failed to load balance',
//                   style: TextStyle(
//                     color: AppColors.red,
//                     fontSize: 12.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//           SizedBox(height: 12.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildBalanceItem(
//                   label: 'Total Deposit',
//                   value: '\$${_getBalanceValue('totalDeposit').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: AppColors.green,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'Total Withdrawal',
//                   value: '\$${_getBalanceValue('totalWithdrawal').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: AppColors.red,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'Meta Deposit',
//                   value: '\$${_getBalanceValue('totalMetaDeposit').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: AppColors.green,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'Meta Withdrawal',
//                   value: '\$${_getBalanceValue('totalMetaWithdrawal').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: AppColors.red,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'Internal Transfer',
//                   value: '\$${_getBalanceValue('totalInternalTransfer').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'IB Income',
//                   value: '\$${_getBalanceValue('totalIBIncome').toStringAsFixed(2)}',
//                   isDarkMode: isDarkMode,
//                   color: AppColors.green,
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildBalanceItem(
//                   label: 'Referrals',
//                   value: '$referrals',
//                   isDarkMode: isDarkMode,
//                   color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBalanceItem({
//     required String label,
//     required String value,
//     required bool isDarkMode,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(
//           color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
//           width: 0.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPersonalDetailsSection(bool isDarkMode) {
//     final isKycVerified = UserConstants.KYC_STATUS == "true";
//     final isBankVerified = UserConstants.BANK_STATUS == "true";
//     final is2FAEnabled = UserConstants.TWO_FA_STATUS == "true";
//
//     String verificationStatus;
//     if (isKycVerified && isBankVerified && is2FAEnabled) {
//       verificationStatus = "Fully Verified";
//     } else {
//       List<String> pendingStatuses = [];
//       if (!isKycVerified) pendingStatuses.add("KYC Pending");
//       if (!isBankVerified) pendingStatuses.add("Bank Verification Pending");
//       if (!is2FAEnabled) pendingStatuses.add("2FA Not Enabled");
//       verificationStatus = pendingStatuses.join(", ");
//     }
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const EditProfileScreen()),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//           borderRadius: BorderRadius.circular(12.r),
//           border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
//           boxShadow: isDarkMode
//               ? null
//               : [
//             BoxShadow(
//               color: AppColors.lightShadow,
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(
//               Icons.person,
//               color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//               size: 24.sp,
//             ),
//             SizedBox(width: 16.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Personal Details",
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     UserConstants.NAME.isNotEmpty ? UserConstants.NAME : "Name not set",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     UserConstants.EMAIL.isNotEmpty ? UserConstants.EMAIL : "Email not set",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     UserConstants.PHONE.isNotEmpty ? UserConstants.PHONE : "Phone not set",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                     decoration: BoxDecoration(
//                       color: verificationStatus == "Fully Verified"
//                           ? AppColors.green.withOpacity(0.3)
//                           : AppColors.orange.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(16.r),
//                     ),
//                     child: Text(
//                       verificationStatus,
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode ? AppColors.white : Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               size: 24.sp,
//               color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildComplianceSection(bool isDarkMode) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Compliance",
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         _buildSupportRow(
//           Icons.account_balance,
//           "Bank Details",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const BankDetailsScreen()),
//           ),
//           isDarkMode,
//           semanticLabel: "View Bank Details",
//         ),
//         _buildSupportRow(
//           Icons.upload_file,
//           "Upload Documents",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const DocumentUploadScreen()),
//           ),
//           isDarkMode,
//           semanticLabel: "Upload Documents",
//         ),
//         _buildSupportRow(
//           Icons.group_add,
//           "IB Request",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const IBRequestScreen()),
//           ),
//           isDarkMode,
//           semanticLabel: "IB Request",
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSupportSection(bool isDarkMode) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "MT5 Accounts",
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         FadeTransition(
//           opacity: _fadeAnimations[0],
//           child: _buildSupportRow(
//             Icons.add_circle_outline,
//             "Create New Account",
//                 () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CreateMetaAccountScreen()),
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     "Opening Create Account",
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                   ),
//                   backgroundColor: AppColors.green,
//                 ),
//               );
//             },
//             isDarkMode,
//             semanticLabel: "Create New MT5 Account",
//           ),
//         ),
//         FadeTransition(
//           opacity: _fadeAnimations[1],
//           child: _buildSupportRow(
//             Icons.list_alt,
//             "MT5 List Account",
//                 () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MetaTradeListScreen()),
//               );
//             },
//             isDarkMode,
//             semanticLabel: "View MT5 Account List",
//           ),
//         ),
//         SizedBox(height: 16.h),
//         Text(
//           "Financial Actions",
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         _buildSupportRow(
//           Icons.account_balance_wallet,
//           "Deposit",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => DepositScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.money_off,
//           "Withdraw",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => WithdrawScreen(
//                 mainBalance: _getBalanceValue('mainBalance'),
//               ),
//             ),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.history,
//           "Transaction History",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
//           ),
//           isDarkMode,
//         ),
//         SizedBox(height: 16.h),
//         Text(
//           "Support & Settings",
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         _buildSupportRow(
//           Icons.lock,
//           "Change Password",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.security,
//           "2FA Setup",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const TwoFASetupScreen()),
//           ),
//           isDarkMode,
//           semanticLabel: "2FA Setup",
//         ),
//         _buildSupportRow(
//           Icons.support_agent,
//           "Help Center",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SupportScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.support,
//           "My Ticket",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.local_offer,
//           "Login History",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginHistoryScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.star_border,
//           "Rate App",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const FeedbackScreen()),
//           ),
//           isDarkMode,
//         ),
//         _buildSupportRow(
//           Icons.info_outline,
//           "About",
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AboutUsScreen()),
//           ),
//           isDarkMode,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSupportRow(
//       IconData icon,
//       String title,
//       VoidCallback onPressed,
//       bool isDarkMode, {
//         String? semanticLabel,
//       }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 8.h),
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         decoration: BoxDecoration(
//           color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//           borderRadius: BorderRadius.circular(12.r),
//           border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
//           boxShadow: isDarkMode
//               ? null
//               : [
//             BoxShadow(
//               color: AppColors.lightShadow,
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//               size: 24.sp,
//             ),
//             SizedBox(width: 16.w),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               size: 24.sp,
//               color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton(bool isDarkMode) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.red,
//           foregroundColor: AppColors.white,
//           padding: EdgeInsets.symmetric(vertical: 16.h),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//         ),
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//           );
//         },
//         child: Text(
//           "Log Out",
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: AppColors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flexy_markets/constant/user_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/wallet_service.dart';
import '../../widget/common/main_app_bar.dart';
import '../ib/ib_request_screen.dart';
import '../metatrade/create_meta_trade_screen.dart';
import '../metatrade/meta_trade_list_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/login_history_screen.dart';
import '../support/my_tickets_screen.dart';
import '../profile/support_screen.dart';
import '../transation/deposit_screen.dart';
import '../transation/transation_history_screen.dart';
import '../auth/welcome_screen.dart';
import '../profile/about_us_screen.dart';
import '../profile/feedback_screen.dart';
import '../transation/withdraw_fund_screen.dart';
import '../transation/withdraw_screen.dart';
import '../twofa/twofa_setup_screen.dart';
import '../user/bank_deatils_screen.dart';
import '../user/change_password_screen.dart';
import '../user/document_upload_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final WalletService _walletService = WalletService();
  final int referrals = 28; // Retained as hardcoded since not in API response
  Map<String, dynamic>? _assetData;
  bool _isLoading = false;
  String? _errorMessage;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimations = List.generate(
      2, // For the two MT5 rows
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.1 * index, 0.3 + 0.1 * index, curve: Curves.easeIn),
        ),
      ),
    );
    _animationController.forward();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Maximum retry attempts reached. Please try again later or contact support.';
      });
      _showSnackBar(_errorMessage!, AppColors.red);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userDataResponse = await _walletService.fetchUserData();
      if (userDataResponse['status'] == true) {
        setState(() {
          _assetData = userDataResponse['data']['assetData'];
          _isLoading = false;
          _retryCount = 0;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = userDataResponse['message'] ?? 'Failed to fetch user data';
          _retryCount++;
        });
        _showSnackBar(_errorMessage!, AppColors.red);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('EACCES')
            ? 'Server error: Unable to process request. Please try again or contact support.'
            : 'Error fetching data: ${e.toString()}';
        _retryCount++;
      });
      _showSnackBar(_errorMessage!, AppColors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        action: _retryCount < _maxRetries
            ? SnackBarAction(
          label: 'Retry',
          textColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
          onPressed: _fetchData,
        )
            : null,
      ),
    );
  }

  // Helper function to safely extract num values from _assetData
  double _getBalanceValue(String key) {
    if (_assetData == null || _assetData![key] == null) {
      return 0.0;
    }
    return (_assetData![key] is num) ? (_assetData![key] as num).toDouble() : 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildBalanceSection(isDarkMode),
                    SizedBox(height: 20.h),
                    _buildPersonalDetailsSection(isDarkMode),
                    SizedBox(height: 20.h),
                    _buildComplianceSection(isDarkMode),
                    SizedBox(height: 20.h),
                    _buildSupportSection(isDarkMode),
                    SizedBox(height: 20.h),
                    Text(
                      "Logged in as ${UserConstants.EMAIL}",
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildLogoutButton(isDarkMode),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: isDarkMode
                    ? AppColors.darkBackground.withOpacity(0.7)
                    : AppColors.lightBackground.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                child: UserConstants.PROFILE_IMAGE_URL != null &&
                    UserConstants.PROFILE_IMAGE_URL!.isNotEmpty
                    ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: UserConstants.PROFILE_IMAGE_URL!,
                    fit: BoxFit.cover,
                    width: 60.r,
                    height: 60.r,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 30.sp,
                      color: AppColors.white,
                    ),
                  ),
                )
                    : Icon(
                  Icons.person,
                  size: 30.sp,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UserConstants.NAME.isNotEmpty ? UserConstants.NAME : "Name not set",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  Text(
                    '${UserConstants.USER_ID}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'Wallet Overview',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _errorMessage != null
                ? 'Balance Unavailable'
                : '\$${_getBalanceValue('mainBalance').toStringAsFixed(2)} USD',
            style: TextStyle(
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: _fetchData,
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Text(
                  'Failed to load balance',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBalanceItem(
                  label: 'Total Deposit',
                  value: '\$${_getBalanceValue('totalDeposit').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Total Withdrawal',
                  value: '\$${_getBalanceValue('totalWithdrawal').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: AppColors.red,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Meta Deposit',
                  value: '\$${_getBalanceValue('totalMetaDeposit').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Meta Withdrawal',
                  value: '\$${_getBalanceValue('totalMetaWithdrawal').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: AppColors.red,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Internal Transfer',
                  value: '\$${_getBalanceValue('totalInternalTransfer').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'IB Income',
                  value: '\$${_getBalanceValue('totalIBIncome').toStringAsFixed(2)}',
                  isDarkMode: isDarkMode,
                  color: AppColors.green,
                ),
                SizedBox(width: 8.w),
                _buildBalanceItem(
                  label: 'Referrals',
                  value: '$referrals',
                  isDarkMode: isDarkMode,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem({
    required String label,
    required String value,
    required bool isDarkMode,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection(bool isDarkMode) {
    final isKycVerified = UserConstants.KYC_STATUS == "true";
    final isBankVerified = UserConstants.BANK_STATUS == "true";
    final is2FAEnabled = UserConstants.TWO_FA_STATUS == "true";

    String verificationStatus;
    if (isKycVerified && isBankVerified && is2FAEnabled) {
      verificationStatus = "Fully Verified";
    } else {
      List<String> pendingStatuses = [];
      if (!isKycVerified) pendingStatuses.add("KYC Pending");
      if (!isBankVerified) pendingStatuses.add("Bank Verification Pending");
      if (!is2FAEnabled) pendingStatuses.add("2FA Not Enabled");
      verificationStatus = pendingStatuses.join(", ");
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.person,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    UserConstants.NAME.isNotEmpty ? UserConstants.NAME : "Name not set",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    UserConstants.EMAIL.isNotEmpty ? UserConstants.EMAIL : "Email not set",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    UserConstants.PHONE.isNotEmpty ? UserConstants.PHONE : "Phone not set",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: verificationStatus == "Fully Verified"
                          ? AppColors.green.withOpacity(0.3)
                          : AppColors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      verificationStatus,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Compliance",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSupportRow(
          Icons.account_balance,
          "Bank Details",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BankDetailsScreen()),
          ),
          isDarkMode,
          semanticLabel: "View Bank Details",
        ),
        _buildSupportRow(
          Icons.upload_file,
          "Upload Documents",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DocumentUploadScreen()),
          ),
          isDarkMode,
          semanticLabel: "Upload Documents",
        ),
        _buildSupportRow(
          Icons.group_add,
          "IB Request",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IBRequestScreen()),
          ),
          isDarkMode,
          semanticLabel: "IB Request",
        ),
      ],
    );
  }

  Widget _buildSupportSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MT5 Accounts",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        FadeTransition(
          opacity: _fadeAnimations[0],
          child: _buildSupportRow(
            Icons.add_circle_outline,
            "Create New Account",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateMetaAccountScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Opening Create Account",
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  backgroundColor: AppColors.green,
                ),
              );
            },
            isDarkMode,
            semanticLabel: "Create New MT5 Account",
          ),
        ),
        FadeTransition(
          opacity: _fadeAnimations[1],
          child: _buildSupportRow(
            Icons.list_alt,
            "MT5 List Account",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MetaTradeListScreen()),
              );
            },
            isDarkMode,
            semanticLabel: "View MT5 Account List",
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Financial Actions",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSupportRow(
          Icons.account_balance_wallet,
          "Deposit",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DepositScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.money_off,
          "Withdraw",
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WithdrawScreen(
                mainBalance: _getBalanceValue('mainBalance'),
              ),
            ),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.history,
          "Transaction History",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
          ),
          isDarkMode,
        ),
        SizedBox(height: 16.h),
        Text(
          "Support & Settings",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSupportRow(
          Icons.lock,
          "Change Password",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.security,
          "2FA Setup",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TwoFASetupScreen()),
          ),
          isDarkMode,
          semanticLabel: "2FA Setup",
        ),
        _buildSupportRow(
          Icons.support_agent,
          "Help Center",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupportScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.support,
          "My Ticket",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.local_offer,
          "Login History",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginHistoryScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.star_border,
          "Rate App",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
          isDarkMode,
        ),
        _buildSupportRow(
          Icons.info_outline,
          "About",
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsScreen()),
          ),
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildSupportRow(
      IconData icon,
      String title,
      VoidCallback onPressed,
      bool isDarkMode, {
        String? semanticLabel,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        },
        child: Text(
          "Log Out",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}