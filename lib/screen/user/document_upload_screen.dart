import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/user_service.dart';
import '../../widget/common/main_app_bar.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({Key? key}) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  File? _poiImage;
  File? _poaImage;
  bool _isLoading = false;
  final _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDocumentDetails();
  }

  Future<void> _loadDocumentDetails() async {
    setState(() => _isLoading = true);
    final result = await _userService.getDocumentDetails();
    setState(() => _isLoading = false);

    if (!result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.red,
        ),
      );
    }
    // Note: Since the provided API response for getDocumentDetails is not detailed,
    // we assume no pre-filled data is needed for now.
  }

  Future<void> _pickPoiImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _poiImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPoaImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _poaImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadDocuments() async {
    if (_poiImage == null || _poaImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please upload both Proof of Identity and Proof of Address documents',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _userService.uploadDocuments(
      poi: _poiImage!,
      poa: _poaImage!,
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MainAppBar(
        title: 'Upload Documents',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Verification',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Proof of Identity (e.g., Passport, ID Card)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickPoiImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _poiImage == null ? 'Upload Proof of Identity' : 'POI Image Selected',
                          style: TextStyle(
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            fontSize: 16.sp,
                          ),
                        ),
                        Icon(
                          Icons.upload_file,
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Proof of Address (e.g., Utility Bill, Bank Statement)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickPoaImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _poaImage == null ? 'Upload Proof of Address' : 'POA Image Selected',
                          style: TextStyle(
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            fontSize: 16.sp,
                          ),
                        ),
                        Icon(
                          Icons.upload_file,
                          color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _isLoading ? null : _uploadDocuments,
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
                      'Upload Documents',
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
    );
  }
}