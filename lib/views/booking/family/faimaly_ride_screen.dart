import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upcoming_outlined,
            size: 80,
            color: Colors.orange.shade300,
          ),
          SizedBox(height: 20),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade600,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
