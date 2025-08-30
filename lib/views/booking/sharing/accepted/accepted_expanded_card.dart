import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/views/booking/sharing/manual/manual_expanded_card.dart';

import '../route/route_expanded_card.dart';

class AcceptedExpandedCard extends StatelessWidget {
  final Map item;
  const AcceptedExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // same as manual
    return ManualExpandedCard(item: item);
  }
}

