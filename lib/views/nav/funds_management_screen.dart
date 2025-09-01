import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants.dart';
import '../../utils/tabs/app_custom_tab.dart';
import '../fund/Weekly/weekly_withdrawal_screen.dart';
import '../fund/deposit/quick_deposit_screen.dart';
import '../fund/email/email_list_screen.dart';
import '../fund/interac/interac_transfer_screen.dart';
import '../fund/switch/switch_screen.dart';
import '../fund/withdrawal/quick_withdrawal_screen.dart';

class FundsManagementScreen extends StatelessWidget {
  const FundsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: AppCustomTab(
            fontSize: 12.sp,
            selectedLabelColor: appColor.blackThemeColor,
            unSelectedLabelColor: appColor.whiteThemeColor,
            tabBackGroundColor: appColor.color353535,
            indicatorSelectedColor: appColor.greenThemeColor,
            indicatorUnSelectedColor: Colors.transparent,
            tabTitles: [
              'Interac E-Transfer',
              'Email',
              'Quick Withdrawal',
              'Weekly Withdrawal',
              'Switch',
              'Quick Deposit',
            ],
            tabViews: [
              InteracTransferScreen(),
              EmailListScreen(),
              QuickWithdrawalScreen(),
              WeeklyWithdrawalScreen(),
              SwitchScreen(),
              QuickDepositScreen(),
            ],
            decoratedBoxRadius: 0,
            indicatorRadius: 5.r,
          ),
        ),
      ),
    );
  }
}
