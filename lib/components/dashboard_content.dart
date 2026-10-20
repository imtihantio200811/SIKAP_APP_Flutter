import 'package:flutter/material.dart';

import 'dashboard_discussions.dart';
import 'dashboard_link_checker.dart';
import 'dashboard_news_feed.dart';
import 'dashboard_stats.dart';
import 'dashboard_trending.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.linkController,
    required this.onPaste,
    required this.onCheck,
    this.onSelectContent,
  });

  final TextEditingController linkController;
  final VoidCallback onPaste;
  final VoidCallback onCheck;
  final ValueChanged<String>? onSelectContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 27, 19, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardLinkChecker(
            controller: linkController,
            onPaste: onPaste,
            onCheck: onCheck,
            onSelectDemo: onSelectContent,
          ),
          const SizedBox(height: 34),
          const DashboardStats(),
          const SizedBox(height: 29),
          DashboardTrending(onSelectTrend: onSelectContent),
          const SizedBox(height: 25),
          DashboardNewsFeed(onSelectNews: onSelectContent),
          const SizedBox(height: 19),
          const DashboardDiscussions(),
        ],
      ),
    );
  }
}
