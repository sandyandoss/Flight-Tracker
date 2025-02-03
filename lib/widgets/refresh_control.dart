import 'package:flutter/material.dart';

class RefreshControl extends StatelessWidget {
  final Widget child;
  final VoidCallback onRefresh;

  RefreshControl({required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: child,
    );
  }
}