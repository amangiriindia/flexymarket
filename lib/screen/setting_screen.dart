import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool faceIdEnabled = true;
  bool hideBalances = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00685a),
          secondary: Color(0xFF00685a),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,
                            size: 24.w, color: Colors.white),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Default text color
                        ),
                      ),
                    ],
                  ),
                ),
            
            
            
            
                SizedBox(height: 16.h),
            
                // Account Details Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Details',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Default text color
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Type',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xFF00685a), // Changed from Colors.grey
                                ),
                              ),
                              Text(
                                'Real MT4',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white, // Default text color
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Account Number',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xFF00685a), // Changed from Colors.grey
                                ),
                              ),
                              Text(
                                '12345678',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white, // Default text color
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Leverage',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xFF00685a), // Changed from Colors.grey
                                ),
                              ),
                              Text(
                                '1:1000',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white, // Default text color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 16.h),
            
                // Settings options
                _buildSettingsOption(
                  icon: Icons.key,
                  iconColor:Color(0xFF00685a),
                  title: 'Change PIN',
                  hasChevron: true,
                ),
            
                _buildSettingsOption(
                  icon: Icons.face,
                  iconColor: Color(0xFF00685a),
                  title: 'Enable Face ID',
                  hasSwitch: true,
                  switchValue: faceIdEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      faceIdEnabled = value;
                    });
                  },
                ),
            
                _buildSettingsOption(
                  icon: Icons.visibility_off,
                  iconColor: Color(0xFF00685a),
                  title: 'Hide Balances',
                  hasSwitch: true,
                  switchValue: hideBalances,
                  onSwitchChanged: (value) {
                    setState(() {
                      hideBalances = value;
                    });
                  },
                ),
            
                _buildSettingsOption(
                  icon: Icons.language,
                  iconColor: Color(0xFF00685a),
                  title: 'Language',
                  hasChevron: true,
                  trailingText: 'English',
                ),
            
                _buildSettingsOption(
                  icon: Icons.palette,
                  iconColor: Color(0xFF00685a),
                  title: 'Appearance',
                  hasChevron: true,
                  trailingText: 'Dark',
                ),
            
                _buildSettingsOption(
                  icon: Icons.shield,
                  iconColor: Colors.red,
                  title: 'Secure Account',
                  titleColor: Colors.red, // Preserved as red
                  hasChevron: true,
                ),
            
                _buildSettingsOption(
                  icon: Icons.delete,
                  iconColor: Colors.red,
                  title: 'Terminate Account',
                  titleColor: Colors.red, // Preserved as red
                  hasChevron: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    bool hasChevron = false,
    bool hasSwitch = false,
    bool? switchValue,
    void Function(bool)? onSwitchChanged,
    String? trailingText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24.w,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: titleColor ?? Colors.white, // Default to white if titleColor is null
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color:Color(0xFF00685a), // Changed from Colors.grey
                  ),
                ),
              if (hasChevron)
                Icon(
                  Icons.chevron_right,
                  color: Color(0xFF00685a), // Changed from Colors.grey
                  size: 24.w,
                ),
              if (hasSwitch)
                Switch(
                  value: switchValue ?? false,
                  onChanged: onSwitchChanged,
                  activeColor: Color(0xFF00685a),
                  activeTrackColor: Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}