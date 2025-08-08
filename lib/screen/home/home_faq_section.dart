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
      question: 'Why should I trade with Flexy Markets?',
      answer: 'Because we make trading simple, smooth, and rewarding. No complicated processes, just a great experience you can rely on.',
    ),
    FAQItem(
      question: 'Are there any extra or hidden charges?',
      answer: 'No. What you see is exactly what you get. Your earnings are yours to keep.',
    ),
    FAQItem(
      question: 'How fast can I get my money after withdrawal?',
      answer: 'Your money is always your right. We process withdrawals instantly so you’re never left waiting.',
    ),
    FAQItem(
      question: 'Is my money safe with Flexy Markets?',
      answer: 'Absolutely. We use the same advanced security systems trusted by global banks to protect your funds and personal details.',
    ),
    FAQItem(
      question: 'Can I get help anytime I need it?',
      answer: 'Yes. Our support team is available 24/7 — real people, real solutions, whenever you need them.',
    ),
    FAQItem(
      question: 'Is Flexy Markets a regulated broker?',
      answer: 'Yes. We are licensed and regulated by trusted authorities, so you can trade with complete peace of mind.',
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