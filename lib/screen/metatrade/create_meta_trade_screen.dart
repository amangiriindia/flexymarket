import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';
import '../../service/apiservice/meta_trade_service.dart';
import '../../widget/common/common_app_bar.dart';


enum ScreenView { empty, plans, form }

class Plan {
  final int groupId; // Added groupId
  final String name;
  final String chipLabel;
  final String minDeposit;
  final String spread;
  final String commission;

  Plan({
    required this.groupId,
    required this.name,
    required this.chipLabel,
    required this.minDeposit,
    required this.spread,
    required this.commission,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      groupId: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      chipLabel: json['status'] == 'ACTIVE' ? 'Professional' : 'Standard', // Simplified logic
      minDeposit: '10 USD', // API doesn't provide, using default
      spread: 'From 0.20', // API doesn't provide, using default
      commission: 'No commission', // API doesn't provide, using default
    );
  }
}

class CreateMetaAccountScreen extends StatefulWidget {
  const CreateMetaAccountScreen({super.key});

  @override
  State<CreateMetaAccountScreen> createState() => _CreateMetaAccountScreenState();
}

class _CreateMetaAccountScreenState extends State<CreateMetaAccountScreen> with SingleTickerProviderStateMixin {
  ScreenView _currentView = ScreenView.empty;
  Plan? _selectedPlan; // Changed to Plan type to store groupId
  String? _selectedLeverage;
  final TextEditingController _mainPasswordController = TextEditingController();
  final TextEditingController _investorPasswordController = TextEditingController();
  bool _showMainPassword = false;
  bool _showInvestorPassword = false;
  int _mainPasswordStrength = 0;
  int _investorPasswordStrength = 0;
  bool _isLoading = true;
  List<Plan> _plans = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final MetaTradeService _metaTradeService = MetaTradeService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _mainPasswordController.addListener(_updateMainPasswordStrength);
    _investorPasswordController.addListener(_updateInvestorPasswordStrength);
    _fetchPlans();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mainPasswordController.dispose();
    _investorPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
    final result = await _metaTradeService.getMT5GroupList();
    setState(() {
      _isLoading = false;
      if (result['success'] && result['data'] != null) {
        _plans = (result['data']['groupList'] as List)
            .map((group) => Plan.fromJson(group))
            .toList();
        if (_plans.isNotEmpty && _currentView == ScreenView.empty) {
          _switchView(ScreenView.plans);
        }
      } else {
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
    });
  }

  void _updateMainPasswordStrength() {
    final password = _mainPasswordController.text;
    int strength = 0;
    if (password.length >= 8 && password.length <= 15) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    setState(() => _mainPasswordStrength = strength);
  }

  void _updateInvestorPasswordStrength() {
    final password = _investorPasswordController.text;
    int strength = 0;
    if (password.length >= 8 && password.length <= 15) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    setState(() => _investorPasswordStrength = strength);
  }

  void _switchView(ScreenView view, {Plan? plan}) {
    setState(() {
      _currentView = view;
      if (plan != null) _selectedPlan = plan;
      _animationController.reset();
      _animationController.forward();
    });
  }

  Future<void> _validateAndCreateAccount() async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    if (_selectedPlan == null ||
        _selectedLeverage == null ||
        _mainPasswordController.text.isEmpty ||
        _investorPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    if (_mainPasswordStrength < 4 || _investorPasswordStrength < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passwords do not meet requirements',
            style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _metaTradeService.createMT5Account(
      groupId: _selectedPlan!.groupId,
      leverage: _selectedLeverage!.split(':').last, // Convert "1:100" to "100"
      mainPassword: _mainPasswordController.text,
      investorPassword: _investorPasswordController.text,
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
    String title;
    VoidCallback? onBackPressed;

    switch (_currentView) {
      case ScreenView.empty:
        title = 'My Accounts';
        onBackPressed = () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Returning to Profile',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
              backgroundColor: AppColors.red,
            ),
          );
        };
        break;
      case ScreenView.plans:
        title = 'Open New Account';
        onBackPressed = () => _switchView(ScreenView.empty);
        break;
      case ScreenView.form:
        title = 'Create Account';
        onBackPressed = () => _switchView(ScreenView.plans);
        break;
    }

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CommonAppBar(
        title: title,
        showBackButton: true,
        onBackPressed: onBackPressed,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            )
                : _buildView(isDarkMode),
          ),
        ),
      ),
    );
  }

  Widget _buildView(bool isDarkMode) {
    switch (_currentView) {
      case ScreenView.empty:
        return _buildEmptyState(isDarkMode);
      case ScreenView.plans:
        return _buildPlanSelection(isDarkMode);
      case ScreenView.form:
        return _buildPasswordForm(isDarkMode);
    }
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          Icon(
            Icons.account_balance_wallet,
            size: 80.sp,
            color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
            semanticLabel: 'No accounts icon',
          ),
          SizedBox(height: 16.h),
          Text(
            'You don’t have any MT5 account',
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            semanticsLabel: 'You don’t have any MT5 account',
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => _switchView(ScreenView.plans),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 20.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Open New Account',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                    semanticsLabel: 'Open New Account',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MT5',
          style: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          semanticsLabel: 'MT5 Account Type',
        ),
        SizedBox(height: 16.h),
        if (_plans.isEmpty)
          Center(
            child: Text(
              'No plans available',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
          )
        else
          ...List.generate(
            _plans.length,
                (index) => FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.1 * index, 0.3 + 0.1 * index, curve: Curves.easeIn),
                ),
              ),
              child: _buildPlanCard(_plans[index], isDarkMode),
            ),
          ),
        SizedBox(height: 16.h),
        _buildInfoFooter(isDarkMode),
      ],
    );
  }

  Widget _buildPlanCard(Plan plan, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _switchView(ScreenView.form, plan: plan),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  plan.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_border,
                        size: 14.sp,
                        color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        plan.chipLabel,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'A great account for all types of traders',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            _buildPlanDetail('minDeposit', plan.minDeposit, isDarkMode),
            Divider(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            _buildPlanDetail('spread', plan.spread, isDarkMode),
            Divider(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            _buildPlanDetail('commission', plan.commission, isDarkMode),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => _switchView(ScreenView.form, plan: plan),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Select Plan',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  semanticsLabel: 'Select ${plan.name} Plan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetail(String label, String value, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600.w) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildFormFields(isDarkMode)),
                  SizedBox(width: 16.w),
                  Expanded(flex: 5, child: _buildSummary(isDarkMode)),
                ],
              );
            }
            return Column(
              children: [
                _buildSummary(isDarkMode),
                SizedBox(height: 16.h),
                _buildFormFields(isDarkMode),
              ],
            );
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _isLoading ? null : _validateAndCreateAccount,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: _isLoading
                  ? (isDarkMode ? AppColors.darkAccent.withOpacity(0.5) : AppColors.lightAccent.withOpacity(0.5))
                  : (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: _isLoading
                ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                strokeWidth: 2,
              ),
            )
                : Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              semanticsLabel: 'Create Account',
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildInfoFooter(isDarkMode),
      ],
    );
  }

  Widget _buildFormFields(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(isDarkMode),
        SizedBox(height: 16.h),
        _buildPasswordField('Main password *', _mainPasswordController, _showMainPassword, () {
          setState(() => _showMainPassword = !_showMainPassword);
        }, _mainPasswordStrength, isDarkMode),
        SizedBox(height: 16.h),
        _buildPasswordField('Investor password *', _investorPasswordController, _showInvestorPassword, () {
          setState(() => _showInvestorPassword = !_showInvestorPassword);
        }, _investorPasswordStrength, isDarkMode),
      ],
    );
  }

  Widget _buildDropdownField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max leverage *',
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: isDarkMode
                ? null
                : [
              BoxShadow(
                color: AppColors.lightShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLeverage,
              hint: Text(
                'Select --',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
              dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              items: ['1:100', '1:200', '1:500', '1:1000', '1:5000', '1:10000'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedLeverage = value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool showPassword,
      VoidCallback toggleVisibility,
      int strength,
      bool isDarkMode,
      ) {
    final requirements = [
      {'text': 'Between 8–15 characters', 'met': controller.text.length >= 8 && controller.text.length <= 15},
      {'text': 'At least one upper and one lower case letter', 'met': RegExp(r'[A-Z]').hasMatch(controller.text) && RegExp(r'[a-z]').hasMatch(controller.text)},
      {'text': 'At least one number', 'met': RegExp(r'\d').hasMatch(controller.text)},
      {'text': 'At least one special character', 'met': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(controller.text)},
    ];
    final strengthText = ['Weak', 'Fair', 'Good', 'Strong'][strength.clamp(0, 3)];
    final strengthColor = [AppColors.red, AppColors.red, AppColors.green, AppColors.green][strength.clamp(0, 3)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: isDarkMode
                ? null
                : [
              BoxShadow(
                color: AppColors.lightShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: !showPassword,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  size: 20.sp,
                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                onPressed: toggleVisibility,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...requirements.map((req) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Icon(
                    req['met'] == true ? Icons.check : Icons.clear,
                    size: 16.sp,
                    color: req['met'] == true ? AppColors.green : AppColors.red,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    req['text'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 4.h),
            Text(
              'Password strength: $strengthText',
              style: TextStyle(
                fontSize: 14.sp,
                color: strengthColor,
              ),
              semanticsLabel: 'Password strength: $strengthText',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedPlan?.name ?? 'Unknown',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            semanticsLabel: 'Selected plan: ${_selectedPlan?.name ?? 'Unknown'}',
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spread from',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              Text(
                _selectedPlan?.spread ?? '0.2',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Commission',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
              Text(
                _selectedPlan?.commission ?? '0',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFooter(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 20.sp,
          color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
              children: [
                const TextSpan(text: 'Detailed information on our instruments and trading conditions can be found on the '),
                TextSpan(
                  text: 'Contract Specifications',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' page.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}