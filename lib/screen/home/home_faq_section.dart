import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/app_color.dart';
import '../../providers/theme_provider.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? expandedIndex;

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What is MT5 and how does it work?',
      answer: 'MetaTrader 5 (MT5) is a multi-asset trading platform that allows you to trade Forex, stocks, commodities, indices, and cryptocurrencies. It offers advanced charting tools, technical indicators, and automated trading capabilities.',
    ),
    FAQItem(
      question: 'How do I deposit funds into my trading account?',
      answer: 'You can deposit funds through various methods including bank transfer, credit/debit cards, and e-wallets. Go to the Deposit section from the home screen and choose your preferred payment method.',
    ),
    FAQItem(
      question: 'What are the minimum deposit requirements?',
      answer: 'The minimum deposit varies by account type. Standard accounts typically require a minimum of \$100, while premium accounts may have higher requirements. Check your account details for specific limits.',
    ),
    FAQItem(
      question: 'How do I enable two-factor authentication (2FA)?',
      answer: 'Go to Settings > Security > Two-Factor Authentication. Follow the setup process using an authenticator app like Google Authenticator or Authy to secure your account with an additional layer of protection.',
    ),
    FAQItem(
      question: 'What trading instruments are available?',
      answer: 'Our platform offers a wide range of instruments including major and minor currency pairs, stocks, commodities like gold and oil, stock indices, and popular cryptocurrencies like Bitcoin and Ethereum.',
    ),
    FAQItem(
      question: 'How do I withdraw my profits?',
      answer: 'Withdrawals can be made through the same method you used for deposits. Go to your account dashboard, select withdrawal, choose the amount and method. Processing times vary from 1-5 business days depending on the method.',
    ),
    FAQItem(
      question: 'What is the difference between Demo and Live accounts?',
      answer: 'Demo accounts use virtual money for practice trading without any financial risk, while Live accounts use real money for actual trading. Demo accounts are perfect for learning and testing strategies.',
    ),
    FAQItem(
      question: 'How can I contact customer support?',
      answer: 'Our customer support is available 24/5 through live chat, email, and phone. You can also access our help center and submit support tickets through the app or website.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showAllFAQs(context, isDarkMode);
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkAccent : AppColors.lightAccent,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...faqItems.take(3).map((faq) => _buildFAQCard(faq, faqItems.indexOf(faq), isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildFAQCard(FAQItem faq, int index, bool isDarkMode) {
    final isExpanded = expandedIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode
            ? Border.all(color: AppColors.darkBorder, width: 0.5)
            : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDarkMode
                          ? AppColors.darkAccent
                          : AppColors.lightAccent,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1.0 : 0.0,
              child: isExpanded
                  ? Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllFAQs(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllFAQsScreen(faqItems: faqItems),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}

class AllFAQsScreen extends StatefulWidget {
  final List<FAQItem> faqItems;

  const AllFAQsScreen({
    super.key,
    required this.faqItems,
  });

  @override
  State<AllFAQsScreen> createState() => _AllFAQsScreenState();
}

class _AllFAQsScreenState extends State<AllFAQsScreen> {
  int? expandedIndex;
  List<FAQItem> filteredFAQs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFAQs = widget.faqItems;
  }

  void _filterFAQs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFAQs = widget.faqItems;
      } else {
        filteredFAQs = widget.faqItems
            .where((faq) =>
        faq.question.toLowerCase().contains(query.toLowerCase()) ||
            faq.answer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      expandedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'FAQ',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: searchController,
                onChanged: _filterFAQs,
                decoration: InputDecoration(
                  hintText: 'Search FAQs...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
            ),
            Expanded(
              child: filteredFAQs.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64.sp,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No FAQs found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: filteredFAQs.length,
                itemBuilder: (context, index) {
                  return _buildFAQCard(filteredFAQs[index], index, isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq, int index, bool isDarkMode) {
    final isExpanded = expandedIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: isDarkMode
            ? Border.all(color: AppColors.darkBorder, width: 0.5)
            : null,
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: AppColors.lightShadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDarkMode
                          ? AppColors.darkAccent
                          : AppColors.lightAccent,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1.0 : 0.0,
              child: isExpanded
                  ? Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}