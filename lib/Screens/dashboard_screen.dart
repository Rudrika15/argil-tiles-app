import 'dart:async';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/dashboard_provider.dart';
import 'package:argil_tiles/utils/text_style_helper/text_style_helper.dart';
import 'package:argil_tiles/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_const/app_color.dart';
import '../model/dashboard_model.dart';
import '../provider/quartzproducts_provider.dart';
import '../provider/spcproducts_provider.dart';
import '../utils/widget_helper/widhet_helper.dart';
import '../widgets/custom_container.dart';
import '../widgets/drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _backPressTimer;
  static const int _exitTimeInSec = 2;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _recentContactsKey = GlobalKey();
  final GlobalKey _recentInquiriesKey = GlobalKey();

  @override
  void dispose() {
    _backPressTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToRecentContacts() {
    final targetContext = _recentContactsKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _scrollToRecentInquiries() {
    final targetContext = _recentInquiriesKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DashboardProvider dashboardProvider = context.read<DashboardProvider>();
    Future.microtask(() async {
      await dashboardProvider.getDashboard(context: context);
      await context.read<QuartzproductsProvider>().loadQuartzProducts(
        context: context,
      );
      await context.read<SpcProductProvider>().loadSpcProducts(
        context: context,
      );
    });
  }

  Future<bool> _onWillPop() async {
    if (_backPressTimer == null || !_backPressTimer!.isActive) {
      _backPressTimer = Timer(const Duration(seconds: _exitTimeInSec), () {
        _backPressTimer = null;
      });
      WidgetHelper.customSnackBar(
        context: context,
        title: 'Press back again to exit',
        color: AppColors.brown,
        isError: true,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider = context.watch<DashboardProvider>();
    final DashboardModelData? data = dashboardProvider.dashboardModel?.data;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _onWillPop();
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.homeGradient2,
          surfaceTintColor: AppColors.homeGradient2,
          elevation: 0,
          leadingWidth: isTablet ? 100 : 20.w,
          leading: CustomContainer(
            padding: EdgeInsets.all(isTablet ? 6 : AppSize.size10),
            child: Image.asset(
              'assets/images/logo.png',
              height: isTablet ? 36 : 5.h,
              width: isTablet ? 80 : 20.w,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Dashboard",
            style: TextStyleHelper.mediumHeading.copyWith(
              fontSize: isTablet ? 22 : null,
            ),
          ),
          centerTitle: true,
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.blackColor,
                      size: isTablet ? 28 : 24,
                    ),
                    onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                  ),
            ),
            SizedBox(width: isTablet ? 16 : 10),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DrawerWidget(),
        body:
            dashboardProvider.isLoading
                ? Loader()
                : RefreshIndicator(
                  onRefresh:
                      () async => await dashboardProvider.getDashboard(
                        context: context,
                      ),
                  backgroundColor: AppColors.brown,
                  color: AppColors.appBar,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 800 : double.infinity,
                      ),
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 12 : 0,
                        ),
                        children: [
                          CustomContainer(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 16 : 5.w,
                              vertical: isTablet ? 16 : 2.h,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: "Inquiries",
                                    count: data?.inquiryCount ?? 0,
                                    onTap: _scrollToRecentInquiries,
                                    isTablet: isTablet,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 16 : AppSize.size10),
                                Expanded(
                                  child: StatCard(
                                    label: "Contacts",
                                    count: data?.contactCount ?? 0,
                                    onTap: _scrollToRecentContacts,
                                    isTablet: isTablet,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 16 : 2.h),
                          SectionHeader(
                            key: _recentInquiriesKey,
                            title: "Recent Inquiries",
                            isTablet: isTablet,
                            onViewAll: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AllInquiriesPage(
                                        data: data?.inquiryData ?? [],
                                      ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isTablet ? 8 : 0),
                          ...List.generate(
                            (data?.inquiryData?.take(3).length ?? 0),
                            (index) {
                              final item = data?.inquiryData?[index];
                              return InquiryTile(
                                id: item?.id,
                                name: item?.name,
                                createdAt: item?.createdAt,
                                email: item?.email,
                                message: item?.message,
                                phone: item?.phone,
                                subject: item?.subject,
                              );
                            },
                          ),
                          SizedBox(height: isTablet ? 24 : 16),
                          SectionHeader(
                            key: _recentContactsKey,
                            title: "Recent Contacts",
                            isTablet: isTablet,
                            onViewAll: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AllContactsPage(
                                        data: data?.contactData ?? [],
                                      ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isTablet ? 8 : 0),
                          ...List.generate(
                            (data?.contactData?.take(3).length ?? 0),
                            (index) {
                              final item = data?.contactData?[index];
                              return InquiryTile(
                                name: item?.name,
                                createdAt: item?.createdAt,
                                email: item?.email,
                                message: item?.message,
                                phone: item?.contactno,
                                // subject: item?.subject,
                              );
                            },
                          ),
                          SizedBox(height: isTablet ? 32 : 16),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback? onTap;
  final bool isTablet;

  const StatCard({
    super.key,
    required this.label,
    required this.count,
    this.onTap,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeGradient3,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: isTablet
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 20 : AppSize.size10,
              horizontal: isTablet ? 16 : AppSize.size10,
            ),
            child: Column(
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: isTablet ? 34 : 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey.shade700,
                    fontWeight: isTablet ? FontWeight.w500 : FontWeight.normal,
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

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  final bool isTablet;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backGroundColor: AppColors.homeGradient2,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 5.w,
        vertical: isTablet ? 4 : 0,
      ),
      borderRadius: isTablet ? BorderRadius.circular(10) : null,
      margin: isTablet ? const EdgeInsets.symmetric(horizontal: 16) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              "View All",
              style: TextStyleHelper.smallHeading.copyWith(
                color: AppColors.brown,
                fontSize: isTablet ? 16 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return CustomContainer(
      padding: EdgeInsets.all(isTablet ? 14 : AppSize.size10),
      borderColor: AppColors.brown,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 3.w,
        vertical: isTablet ? 8 : 1.h,
      ),
      borderRadius: BorderRadius.circular(isTablet ? 12 : AppSize.size10),
      borderWidth: 0.3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 17 : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: isTablet ? 15 : null),
        ),
      ),
    );
  }
}

//// simple page to
class AllInquiriesPage extends StatelessWidget {
  final List<InquiryData> data;

  const AllInquiriesPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Inquiries",
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
          ),
        ),
        backgroundColor: AppColors.appBar,
        surfaceTintColor: AppColors.appBar,
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
              final isExporting = dashboardProvider.isExportingInquiry;
              return Padding(
                padding: EdgeInsets.only(right: isTablet ? 16 : 12),
                child: Center(
                  child: InkWell(
                    onTap:
                        isExporting
                            ? null
                            : () => dashboardProvider.exportInquiries(
                              context: context,
                            ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isExporting) ...[
                            SizedBox(
                              width: isTablet ? 16 : 14,
                              height: isTablet ? 16 : 14,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "Exporting...",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.file_download_outlined,
                              size: isTablet ? 18 : 16,
                              color: AppColors.whiteColor,
                            ),
                            SizedBox(width: isTablet ? 6 : 4),
                            Text(
                              "Export",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 800 : double.infinity,
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 12 : 0,
            ),
            itemCount: data.length,
            itemBuilder: (_, index) {
              final item = data[index];
              return InquiryTile(
                id: item.id,
                name: item.name,
                createdAt: item.createdAt,
                email: item.email,
                message: item.message,
                phone: item.phone,
                subject: item.subject,
              );
            },
          ),
        ),
      ),
    );
  }
}

class InquiryTile extends StatelessWidget {
  const InquiryTile({
    super.key,
    this.id,
    this.createdAt,
    this.email,
    this.message,
    this.name,
    this.phone,
    this.subject,
  });
  final int? id;
  final String? createdAt;
  final String? name;
  final String? email;
  final String? phone;
  final String? subject;
  final String? message;

  void _copyCardDetails(BuildContext context) async {
    final List<String> details = [];
    if (id != null) details.add("Inquiry ID: #$id");
    if (name?.isNotEmpty == true) details.add("Name: $name");
    if (phone?.isNotEmpty == true) details.add("Phone: $phone");
    if (email?.isNotEmpty == true) details.add("Email: $email");
    if (subject?.isNotEmpty == true) details.add("Subject: $subject");
    if (message?.isNotEmpty == true) details.add("Message: $message");
    if (createdAt?.isNotEmpty == true) details.add("Date: $createdAt");

    if (details.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: details.join("\n")));
    if (context.mounted) {
      WidgetHelper.customSnackBar(
        context: context,
        title: 'Details copied to clipboard',
        color: AppColors.brown,
        isError: false,
      );
    }
  }

  Future<void> _launchPhone(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (!await launchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        WidgetHelper.customSnackBar(
          context: context,
          title: 'Could not open dialer',
          color: AppColors.errorColor,
          isError: true,
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final cleanEmail = email.trim();
    final Uri emailUri = Uri(scheme: 'mailto', path: cleanEmail);
    try {
      if (!await launchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        WidgetHelper.customSnackBar(
          context: context,
          title: 'Could not open email app',
          color: AppColors.errorColor,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isExpanded = false;
    return CustomContainer(
      borderColor: AppColors.brown,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 3.w,
        vertical: isTablet ? 8 : 1.h,
      ),
      borderRadius: BorderRadius.circular(isTablet ? 14 : AppSize.size10),
      borderWidth: isTablet ? 0.6 : 0.3,
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Date and Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (createdAt?.isNotEmpty == true)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: isTablet ? 15 : 13,
                      color: AppColors.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      createdAt ?? "",
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 12,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              InkWell(
                onTap: () => _copyCardDetails(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 10,
                    vertical: isTablet ? 5 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brown.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.brown.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        size: isTablet ? 14 : 13,
                        color: AppColors.brown,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Copy",
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 10 : 8),

          // Name
          if (name?.isNotEmpty == true) ...[
            Text(
              name ?? "",
              style: TextStyleHelper.smallHeading.copyWith(
                fontSize: isTablet ? 18 : 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
          ],

          // Highlighted Phone with dialer redirect
          if (phone?.isNotEmpty == true) ...[
            InkWell(
              onTap: () => _launchPhone(context, phone!),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 5 : 4),
                      decoration: BoxDecoration(
                        color: AppColors.brown.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phone_rounded,
                        size: isTablet ? 15 : 13,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        phone ?? "",
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 15 : 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
          ],

          // Highlighted Email with mail redirect
          if (email?.isNotEmpty == true) ...[
            InkWell(
              onTap: () => _launchEmail(context, email!),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 5 : 4),
                      decoration: BoxDecoration(
                        color: AppColors.brown.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.email_rounded,
                        size: isTablet ? 15 : 13,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        email ?? "",
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 15 : 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
          ],

          // Subject & Message
          if (id != null || subject?.isNotEmpty == true || message?.isNotEmpty == true)
            StatefulBuilder(
              builder: (context, setState) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 4),
                    padding: EdgeInsets.all(isTablet ? 14 : 10),
                    decoration: BoxDecoration(
                      color: AppColors.homeGradient2,
                      borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (id != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Inquiry ID: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 15 : 13,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "#$id",
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.brown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 6 : 4),
                        ],
                        if (subject?.isNotEmpty == true) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Subject: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 15 : 13,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  subject ?? "",
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 6 : 4),
                        ],
                        if (message?.isNotEmpty == true) ...[
                          Text(
                            displayMessage(message ?? "", isExpanded),
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 13,
                              color: Colors.black87,
                              height: 1.35,
                            ),
                          ),
                          if ((message?.length ?? 0) > 200)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                isExpanded ? "Show less" : "Read more",
                                style: TextStyle(
                                  color: AppColors.brown,
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// simple page to
class AllContactsPage extends StatelessWidget {
  final List<ContactData> data;

  const AllContactsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Contacts",
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
          ),
        ),
        backgroundColor: AppColors.appBar,
        surfaceTintColor: AppColors.appBar,
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
              final isExporting = dashboardProvider.isExportingContact;
              return Padding(
                padding: EdgeInsets.only(right: isTablet ? 16 : 12),
                child: Center(
                  child: InkWell(
                    onTap:
                        isExporting
                            ? null
                            : () => dashboardProvider.exportContacts(
                              context: context,
                            ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isExporting) ...[
                            SizedBox(
                              width: isTablet ? 16 : 14,
                              height: isTablet ? 16 : 14,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "Exporting...",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.file_download_outlined,
                              size: isTablet ? 18 : 16,
                              color: AppColors.whiteColor,
                            ),
                            SizedBox(width: isTablet ? 6 : 4),
                            Text(
                              "Export",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 800 : double.infinity,
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 12 : 0,
            ),
            itemCount: data.length,
            itemBuilder: (_, index) {
              final item = data[index];
              return InquiryTile(
                name: item.name,
                createdAt: item.createdAt,
                email: item.email,
                message: item.message,
                phone: item.contactno,
                // subject: item?.subject,
              );
            },
          ),
        ),
      ),
    );
  }
}

String displayMessage(String message, bool isExpanded) {
  const int maxLength = 200;

  if (isExpanded) {
    return message;
  }

  if (message.length < maxLength) {
    return message;
  }

  // Return the first 20% of the message for a shrinking effect
  // as the total message length grows.
  final int twentyPercentLength = (message.length * 0.2).toInt();
  return message.substring(0, twentyPercentLength) + '...';
}
