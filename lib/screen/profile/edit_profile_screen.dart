// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../constant/app_color.dart';
// import '../../constant/user_constant.dart';
// import '../../providers/theme_provider.dart';
// import '../../service/apiservice/user_service.dart';
// import '../../widget/common/common_app_bar.dart';
// import '../../widget/common/main_app_bar.dart';
// import 'package:intl/intl.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController(text: UserConstants.NAME);
//   final _dobController = TextEditingController();
//   final _addressController = TextEditingController();
//   String? _gender;
//   bool _isLoading = false;
//   final _userService = UserService();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _dobController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData(
//             colorScheme: ColorScheme(
//               brightness: isDarkMode ? Brightness.dark : Brightness.light,
//               primary: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//               onPrimary: AppColors.white,
//               secondary: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//               onSecondary: AppColors.white,
//               surface: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//               onSurface: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//               background: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
//               onBackground: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//               error: AppColors.red,
//               onError: AppColors.white,
//             ),
//             dialogBackgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
//       setState(() {
//         _dobController.text = formattedDate;
//       });
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final result = await _userService.updateProfile(
//       name: _nameController.text,
//       dob: _dobController.text,
//       gender: _gender ?? '',
//       address: _addressController.text,
//     );
//
//     setState(() => _isLoading = false);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           result['message'],
//           style: TextStyle(color: AppColors.white),
//         ),
//         backgroundColor: result['success'] ? AppColors.green : AppColors.red,
//       ),
//     );
//
//     if (result['success']) {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
//       appBar: const CommonAppBar(
//         title: 'Update Profile',
//         showBackButton: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//           child: Form(
//             key: _formKey,
//             child: Container(
//               padding: EdgeInsets.all(16.r),
//               decoration: BoxDecoration(
//                 color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: isDarkMode ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
//                 boxShadow: isDarkMode
//                     ? null
//                     : [
//                   BoxShadow(
//                     color: AppColors.lightShadow,
//                     spreadRadius: 1,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Personal Information',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       labelStyle: TextStyle(
//                         color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                         ),
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.h),
//                   GestureDetector(
//                     onTap: () => _selectDate(context),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         controller: _dobController,
//                         decoration: InputDecoration(
//                           labelText: 'Date of Birth (DD-MM-YYYY)',
//                           labelStyle: TextStyle(
//                             color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                             borderSide: BorderSide(
//                               color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                             borderSide: BorderSide(
//                               color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                             ),
//                           ),
//                           suffixIcon: Icon(
//                             Icons.calendar_today,
//                             color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                             size: 20.sp,
//                           ),
//                         ),
//                         style: TextStyle(
//                           color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select your date of birth';
//                           }
//                           final dateFormat = DateFormat('dd-MM-yyyy');
//                           try {
//                             final date = dateFormat.parseStrict(value);
//                             final age = DateTime.now().difference(date).inDays ~/ 365;
//                             if (age < 18) {
//                               return 'You must be at least 18 years old';
//                             }
//                           } catch (e) {
//                             return 'Invalid date format (use DD-MM-YYYY)';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   DropdownButtonFormField<String>(
//                     value: _gender,
//                     decoration: InputDecoration(
//                       labelText: 'Gender',
//                       labelStyle: TextStyle(
//                         color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                         ),
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                     items: ['M', 'F', 'Other'].map((String gender) {
//                       return DropdownMenuItem<String>(
//                         value: gender,
//                         child: Text(gender == 'M' ? 'Male' : gender == 'F' ? 'Female' : 'Other'),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() => _gender = value);
//                     },
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select your gender';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.h),
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: InputDecoration(
//                       labelText: 'Address',
//                       labelStyle: TextStyle(
//                         color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                         ),
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
//                     ),
//                     maxLines: 3,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your address';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 24.h),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
//                         foregroundColor: AppColors.white,
//                         padding: EdgeInsets.symmetric(vertical: 16.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                       ),
//                       onPressed: _isLoading ? null : _updateProfile,
//                       child: _isLoading
//                           ? SizedBox(
//                         height: 20.h,
//                         width: 20.h,
//                         child: CircularProgressIndicator(
//                           color: AppColors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                           : Text(
//                         'Update Profile',
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../constant/user_constant.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/user_service.dart';
import '../../widget/common/common_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: UserConstants.NAME);
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  String? _gender;
  bool _isLoading = false;
  bool _isImageUploading = false;
  File? _selectedImage;
  String? _profileImageUrl;
  final _userService = UserService();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileImageUrl = UserConstants.PROFILE_IMAGE_URL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primary: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              onPrimary: AppColors.white,
              secondary: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              onSecondary: AppColors.white,
              surface: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              onSurface: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              background: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
              onBackground: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              error: AppColors.red,
              onError: AppColors.white,
            ),
            dialogBackgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compress image to reduce size
      maxWidth: 800, // Limit width to prevent large images
      maxHeight: 800, // Limit height to prevent large images
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _updateProfileImage();
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _userService.updateProfile(
      name: _nameController.text,
      dob: _dobController.text,
      gender: _gender ?? '',
      address: _addressController.text,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message'],
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: result['success'] ? AppColors.green : AppColors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
    }
  }

  Future<void> _updateProfileImage() async {
    if (_selectedImage == null) return;

    setState(() => _isImageUploading = true);

    final result = await _userService.updateProfileImage(image: _selectedImage!);

    setState(() => _isImageUploading = false);

    if (result['success']) {
      setState(() {
        _profileImageUrl = result['data']['profileImage'];
        _selectedImage = null;
      });
      UserConstants.PROFILE_IMAGE_URL = _profileImageUrl!;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message'],
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: result['success'] ? AppColors.green : AppColors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CommonAppBar(
        title: 'Update Profile',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(16.r),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow,
                          child: _selectedImage != null
                              ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 100.r,
                              height: 100.r,
                            ),
                          )
                              : _profileImageUrl != null
                              ? ClipOval(
                            child: Image.network(
                              _profileImageUrl!,
                              fit: BoxFit.cover,
                              width: 100.r,
                              height: 100.r,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                                );
                              },
                            ),
                          )
                              : Icon(
                            Icons.person,
                            size: 50.sp,
                            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextButton(
                          onPressed: _isImageUploading ? null : _pickImage,
                          child: Text(
                            _isImageUploading ? 'Uploading...' : 'Change Profile Picture',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (DD-MM-YYYY)',
                          labelStyle: TextStyle(
                            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                            size: 20.sp,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          final dateFormat = RegExp(r'^\d{2}-\d{2}-\d{4}$');
                          if (!dateFormat.hasMatch(value)) {
                            return 'Invalid date format (use DD-MM-YYYY)';
                          }
                          try {
                            final parsedDate = DateFormat('dd-MM-yyyy').parseStrict(value);
                            final age = DateTime.now().difference(parsedDate).inDays ~/ 365;
                            if (age < 18) {
                              return 'You must be at least 18 years old';
                            }
                            if (parsedDate.isAfter(DateTime.now())) {
                              return 'Date of birth cannot be in the future';
                            }
                          } catch (e) {
                            return 'Invalid date (use DD-MM-YYYY)';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    items: ['M', 'F', 'Other'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender == 'M' ? 'Male' : gender == 'F' ? 'Female' : 'Other'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _gender = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkBorder : AppColors.lightShadow.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: _isLoading ? null : _updateProfile,
                      child: _isLoading
                          ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}