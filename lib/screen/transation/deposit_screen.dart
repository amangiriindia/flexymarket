// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../constant/app_color.dart';
// import '../../providers/theme_provider.dart';
// import '../../widget/common/common_app_bar.dart';
// import '../../widget/common/main_app_bar.dart';
// import '../transation/bank_deposit_screen.dart';
// import '../transation/crypto_deposit_screen.dart';
//
// class DepositScreen extends StatelessWidget {
//   const DepositScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
//       appBar:  CommonAppBar(
//         title: 'Deposit Funds',
//         showBackButton: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               SizedBox(height: 8.h),
//               Text(
//                 'Choose a deposit method to fund your account',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                 ),
//               ),
//               SizedBox(height: 24.h),
//               GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16.w,
//                 mainAxisSpacing: 16.h,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 childAspectRatio: 0.8, // Added to control card height
//                 children: [
//                   _buildDepositCard(
//                     context,
//                     isDarkMode,
//                     icon: FontAwesomeIcons.buildingColumns,
//                     title: 'Bank Deposit',
//                     processingTime: '30 min - 1 hour',
//                     fee: '0%',
//                     limits: '50 - 2,000 USD',
//                     gradientColors: isDarkMode
//                         ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
//                         : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const BankDepositScreen()),
//                       );
//                     },
//                   ),
//                   _buildDepositCard(
//                     context,
//                     isDarkMode,
//                     icon: FontAwesomeIcons.bitcoin,
//                     title: 'Tether (USDT TRC20)',
//                     processingTime: 'Instant - 15 min',
//                     fee: '0%',
//                     limits: '10 - 10M USD',
//                     gradientColors: isDarkMode
//                         ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
//                         : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const CryptoDepositScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDepositCard(
//       BuildContext context,
//       bool isDarkMode, {
//         required IconData icon,
//         required String title,
//         required String processingTime,
//         required String fee,
//         required String limits,
//         required List<Color> gradientColors,
//         required VoidCallback onTap,
//       }) {
//     return AnimatedScaleContainer(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: gradientColors,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.lightShadow.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Header section
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
//                       shape: BoxShape.circle,
//                     ),
//                     child: FaIcon(
//                       icon,
//                       size: 20.sp,
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                         color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12.h),
//               // Details section
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow('Time', processingTime, isDarkMode),
//                   SizedBox(height: 6.h),
//                   _buildDetailRow('Fee', fee, isDarkMode),
//                   SizedBox(height: 6.h),
//                   _buildDetailRow('Limits', limits, isDarkMode),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, bool isDarkMode) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10.sp,
//             fontWeight: FontWeight.w400,
//             color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.8) : AppColors.lightSecondaryText.withOpacity(0.8),
//           ),
//         ),
//         Flexible(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontWeight: FontWeight.w600,
//               color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//             ),
//             textAlign: TextAlign.end,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AnimatedScaleContainer extends StatefulWidget {
//   final Widget child;
//   final VoidCallback? onTap;
//
//   const AnimatedScaleContainer({Key? key, required this.child, this.onTap}) : super(key: key);
//
//   @override
//   _AnimatedScaleContainerState createState() => _AnimatedScaleContainerState();
// }
//
// class _AnimatedScaleContainerState extends State<AnimatedScaleContainer> with SingleTickerProviderStateMixin {
//   double _scale = 1.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       onTapDown: (_) => setState(() => _scale = 0.95),
//       onTapUp: (_) => setState(() => _scale = 1.0),
//       onTapCancel: () => setState(() => _scale = 1.0),
//       child: AnimatedScale(
//         scale: _scale,
//         duration: const Duration(milliseconds: 150),
//         curve: Curves.easeInOut,
//         child: widget.child,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../widget/common/common_app_bar.dart';
import '../transation/bank_deposit_screen.dart';
import '../transation/crypto_deposit_screen.dart';

class DepositScreen extends StatelessWidget {


  const DepositScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: 'Deposit Funds',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 8.h),

              SizedBox(height: 16.h),
              Text(
                'Choose a deposit method to fund your account',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 24.h),
              _buildDepositOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.account_balance,
                title: 'Bank Deposit',
                subtitle: '30 min - 1 hour • 0% fee',
                limits: '50 - 2,000 USD',
                gradientColors: isDarkMode
                    ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
                    : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BankDepositScreen()),
                  );
                },
              ),
              SizedBox(height: 16.h),
              _buildDepositOption(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.currency_bitcoin,
                title: 'Tether (USDT TRC20)',
                subtitle: 'Instant - 15 min • 0% fee',
                limits: '10 - 10M USD',
                gradientColors: isDarkMode
                    ? [AppColors.darkAccent.withOpacity(0.8), AppColors.darkAccent]
                    : [AppColors.lightAccent.withOpacity(0.8), AppColors.lightAccent],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CryptoDepositScreen()),
                  );
                },
              ),
              SizedBox(height: 24.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 16.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'All transactions are secure and encrypted',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      semanticsLabel: 'All transactions are secure and encrypted',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepositOption({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required String limits,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: isDarkMode
              ? [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))]
              : [BoxShadow(color: AppColors.lightShadow.withOpacity(0.5), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Limits: $limits',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText.withOpacity(0.8) : AppColors.lightSecondaryText.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}