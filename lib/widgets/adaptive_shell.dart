import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/pages/dashboard_page.dart';
import 'package:gotech_app/pages/scanner_page.dart';
import 'package:gotech_app/pages/input_page.dart';
import 'package:gotech_app/pages/history_page.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';

class AdaptiveShell extends StatefulWidget {
  final Widget child;
  const AdaptiveShell({super.key, required this.child});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.offAll(() => const DashboardPage(), transition: Transition.noTransition);
        break;
      case 1:
        Get.to(() => const ScannerPage(), transition: Transition.cupertino);
        break;
      case 2:
        Get.to(() => const InputPage(), transition: Transition.cupertino);
        break;
      case 3:
        Get.to(() => const HistoryPage(), transition: Transition.cupertino);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mobile: Direct return to allow inner pages to handle their own Scaffold
    if (ResponsiveLayout.isMobile(context)) {
      return widget.child;
    }

    // Desktop/Tablet: Side Navigation Rail layout (No nested Scaffold or Background)
    return Row(
      children: [
        _buildNavigationRail(),
        VerticalDivider(width: 1, color: Colors.white.withValues(alpha: 0.05)),
        Expanded(child: widget.child),
      ],
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _getSelectedIndexForRoute(),
      onDestinationSelected: _onItemTapped,
      labelType: NavigationRailLabelType.selected,
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      unselectedIconTheme: const IconThemeData(color: Colors.white24),
      selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
      selectedLabelTextStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white24),
      indicatorColor: Colors.blueAccent.withValues(alpha: 0.1),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.qr_code_2_rounded, color: Colors.blueAccent, size: 32),
            ),
            const SizedBox(height: 10),
            if (!ResponsiveLayout.isTablet(context))
              const Text('VISIONARY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white38)),
          ],
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_max_rounded),
          selectedIcon: Icon(Icons.home_max_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.qr_code_scanner_rounded),
          label: Text('Scan'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.add_box_rounded),
          label: Text('Create'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_rounded),
          label: Text('Vault'),
        ),
      ],
    );
  }

  int _getSelectedIndexForRoute() {
    final String route = Get.currentRoute;
    if (route.contains('DashboardPage')) return 0;
    if (route.contains('ScannerPage')) return 1;
    if (route.contains('InputPage')) return 2;
    if (route.contains('HistoryPage')) return 3;
    
    return _selectedIndex;
  }
}
