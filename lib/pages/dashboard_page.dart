import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/pages/scanner_page.dart';
import 'package:gotech_app/pages/history_page.dart';
import 'package:gotech_app/pages/input_page.dart';
import 'package:gotech_app/widgets/adaptive_shell.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';
import 'package:lottie/lottie.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine responsive sizing
    final bool isWide = !ResponsiveLayout.isMobile(context);

    // RESTORED HIERARCHY: Background -> Shell -> Single Scaffold
    return StartBackgroundColor(
      child: AdaptiveShell(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: MaxWidthContainer(
              maxWidth: 1200,
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 80), // account for vertical padding
                    child: Center(
                      child: EntranceAnimation(
                        child: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // --- Layout Builders ---

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBranding(centerText: true),
        const SizedBox(height: 60),
        _buildLottieArea(context),
        const SizedBox(height: 60),
        Center(
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 25,
            child: _buildActionButtons(),
          ),
        ),
        const SizedBox(height: 40),
        Center(child: _buildVaultLink()),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBranding(),
              const SizedBox(height: 60),
              _buildVaultLink(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLottieArea(context),
              const SizedBox(height: 40),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: 25,
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Component Widgets ---

  Widget _buildBranding({bool centerText = false}) {
    return Column(
      crossAxisAlignment: centerText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Visionary',
          textAlign: centerText ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          'QR SCANNER & GENERATOR',
          textAlign: centerText ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildLottieArea(BuildContext context) {
    final double sizeFactor = ResponsiveLayout.isMobile(context) ? 0.6 : 0.4;
    final double size = MediaQuery.of(context).size.width * sizeFactor;

    return Center(
      child: GestureDetector(
        onTap: () => Get.to(() => const ScannerPage(), transition: Transition.cupertino),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ],
          ),
          child: Lottie.asset(
            "assets/qranimation1.json",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        NextPageButton(
          text: 'SCAN',
          icon: const Icon(Icons.qr_code_scanner_rounded),
          goto: () => Get.to(() => const ScannerPage(), transition: Transition.cupertino),
          heroTag: 'scanCodeHero',
        ),
        NextPageButton(
          text: 'CREATE',
          icon: const Icon(Icons.add_box_rounded),
          goto: () => Get.to(() => const InputPage(), transition: Transition.cupertino),
          heroTag: 'createCodeHero',
        ),
      ],
    );
  }

  Widget _buildVaultLink() {
    return TextButton.icon(
      onPressed: () => Get.to(() => const HistoryPage(), transition: Transition.downToUp),
      icon: const Icon(Icons.inventory_2_rounded, size: 20, color: Colors.white38),
      label: const Text(
        'ACCESS THE VAULT',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
    );
  }
}
