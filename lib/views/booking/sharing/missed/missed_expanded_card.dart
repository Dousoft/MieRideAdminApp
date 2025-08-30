import 'package:flutter/material.dart';
import 'package:mie_admin/views/booking/sharing/manual/manual_expanded_card.dart';

class MissedExpandedCard extends StatelessWidget {
  final Map item;
  const MissedExpandedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // same as manual
    return ManualExpandedCard(item: item);
  }
}

