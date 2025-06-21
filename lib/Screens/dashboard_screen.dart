import 'dart:async';

import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/dashboard_provider.dart';
import 'package:argil_tiles/utils/size_helper/size_helper.dart';
import 'package:argil_tiles/utils/text_style_helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
          leadingWidth: 20.w,
          leading: CustomContainer(
            padding: EdgeInsets.all(AppSize.size10),
            child: Image.asset(
              'assets/images/logo.png',
              height: 5.h,
              width: 20.w,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text("Dashboard", style: TextStyleHelper.mediumHeading),
          centerTitle: true,
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.blackColor),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        endDrawer: DrawerWidget(),
        body:
            dashboardProvider.isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppColors.brown,
                    color: AppColors.appBar,
                  ),
                )
                : RefreshIndicator(
                  onRefresh:
                      () async => await dashboardProvider.getDashboard(
                        context: context,
                      ),
                  backgroundColor: AppColors.brown,
                  color: AppColors.appBar,
                  child: ListView(
                    children: [
                      CustomContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                label: "Inquiries",
                                count: data?.inquiryCount ?? 0,
                              ),
                            ),
                            SizeHelper.width(),
                            Expanded(
                              child: StatCard(
                                label: "Contacts",
                                count: data?.contactCount ?? 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizeHelper.height(),
                      SectionHeader(
                        title: "Recent Inquiries",
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
                      ...List.generate(
                        (data?.inquiryData?.take(3).length ?? 0),
                        (index) => InfoTile(
                          title: data!.inquiryData![index].subject ?? "",
                          subtitle: data.inquiryData![index].message ?? "",
                        ),
                      ),
                      const SizedBox(height: 16),
                      SectionHeader(
                        title: "Recent Contacts",
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
                      ...List.generate(
                        (data?.contactData?.take(3).length ?? 0),
                        (index) => InfoTile(
                          title: data!.contactData![index].name ?? "",
                          subtitle: data.contactData![index].message ?? "",
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final int count;

  const StatCard({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSize.size10),
      decoration: BoxDecoration(
        color: AppColors.homeGradient3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backGroundColor: AppColors.homeGradient2,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              "View All",
              style: TextStyleHelper.smallHeading.copyWith(
                color: AppColors.brown,
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
    return CustomContainer(
      padding: EdgeInsets.all(AppSize.size10),
      borderColor: AppColors.brown,
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      borderRadius: BorderRadius.circular(AppSize.size10),
      borderWidth: 0.3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Inquiries"),
        backgroundColor: AppColors.appBar,
        surfaceTintColor: AppColors.appBar,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final item = data[index];
          return CustomContainer(
            borderColor: AppColors.brown,
            margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            borderRadius: BorderRadius.circular(AppSize.size10),
            borderWidth: 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizeHelper.height(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(item.createdAt ?? ""), SizeHelper.width()],
                ),
                ListTile(
                  title: Text(item.name ?? ""),
                  subtitle: Text(item.message ?? ""),
                ),
              ],
            ),
          );
        },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Contacts"),
        backgroundColor: AppColors.appBar,
        surfaceTintColor: AppColors.appBar,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final item = data[index];
          return CustomContainer(
            borderColor: AppColors.brown,
            margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            borderRadius: BorderRadius.circular(AppSize.size10),
            borderWidth: 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizeHelper.height(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(item.createdAt ?? ""), SizeHelper.width()],
                ),
                ListTile(
                  title: Text(item.name ?? ""),
                  subtitle: Text(item.message ?? ""),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
