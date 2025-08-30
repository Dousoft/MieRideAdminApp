import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/components/widgets/count_badge.dart';

class AppCustomTab extends StatefulWidget {
  final List<String> tabTitles;
  final List<dynamic>? tabCounts;
  final List<Widget> tabViews;
  final double decoratedBoxRadius;
  final double indicatorRadius;
  final Color indicatorSelectedColor;
  final Color indicatorUnSelectedColor;
  final Color tabBackGroundColor;
  final Color selectedLabelColor;
  final Color unSelectedLabelColor;

  const AppCustomTab({
    super.key,
    required this.tabTitles,
    this.tabCounts,
    required this.tabViews,
    required this.decoratedBoxRadius,
    required this.indicatorRadius,
    required this.indicatorSelectedColor,
    required this.indicatorUnSelectedColor,
    required this.tabBackGroundColor,
    required this.selectedLabelColor,
    required this.unSelectedLabelColor,
  });

  @override
  State<AppCustomTab> createState() => _AppCustomTabState();
}

class _AppCustomTabState extends State<AppCustomTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabTitles.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        FocusManager.instance.primaryFocus?.unfocus();
        selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: widget.tabBackGroundColor,
            borderRadius: BorderRadius.circular(widget.decoratedBoxRadius),
          ),
          child: TabBar(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w).copyWith(top: 5.h),
            tabAlignment: TabAlignment.center,
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
            tabs: List.generate(widget.tabTitles.length, (index) {
              final isSelected = selectedIndex == index;
              final count = (widget.tabCounts != null && index < widget.tabCounts!.length)
                  ? widget.tabCounts![index]
                  : 0;
              return _buildTab(widget.tabTitles[index], isSelected, count: count);
            }),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, bool isSelected, {dynamic count}) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 6.w,vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.indicatorSelectedColor
                      : widget.indicatorUnSelectedColor,
                  borderRadius: BorderRadius.circular(widget.indicatorRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? widget.selectedLabelColor
                        : widget.unSelectedLabelColor,
                    fontSize: 12.sp,
                    letterSpacing: 0.8,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if(!isSelected)CountBadge(count: count??0)
            ],
          ),
        ],
      ),
    );
  }
}
