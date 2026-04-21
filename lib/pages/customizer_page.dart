import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/controllers/qr_customization_controller.dart';
import 'package:gotech_app/controllers/history_controller.dart';
import 'package:gotech_app/widgets/adaptive_shell.dart';
import 'package:gotech_app/widgets/qr_customizer_panel.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';
// Note: We avoid dart:html import here; web saving can be handled via SharePlus or specialized web-plugins later.
class CustomizerPage extends StatelessWidget {
  final TextEditingController controller;
  CustomizerPage({super.key, required this.controller});

  final ScreenshotController screenshotController = ScreenshotController();
  final customizationController = Get.find<QrCustomizationController>();
  final historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
      child: AdaptiveShell(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: AppBarWidget(
              onTap: () {
                Get.back();
              },
            ),
            title: const Text('CUSTOMIZE', style: TextStyle(letterSpacing: 4, fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white24)),
            centerTitle: true,
            actions: [
              if (ResponsiveLayout.isMobile(context))
                IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Colors.blueAccent),
                  onPressed: () {
                    Get.bottomSheet(
                      const QrCustomizerPanel(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              const SizedBox(width: 8),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              tablet: _buildWideLayout(context),
              desktop: _buildWideLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return EntranceAnimation(
      delay: const Duration(milliseconds: 400),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 25,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _actionButton('New', Icons.add_rounded, 'generateAgainHero', () {
              Get.back();
              controller.clear();
            }),
            _actionButton('Share', Icons.share_rounded, 'shareHero',
                () async => await captureAndShare()),
            _actionButton(
                'Export',
                Icons.download_rounded,
                'screenshotHero',
                () async => await captureAndSaveScreenshot(),
                isPrimary: true),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      String text, IconData icon, String heroTag, VoidCallback onTap,
      {bool isPrimary = false}) {
    return NextPageButton(
      text: text,
      icon: Icon(icon, color: isPrimary ? Colors.white : Colors.white70),
      goto: onTap,
      heroTag: heroTag,
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double padding = UiConstants.mainPadding(context);
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: EntranceAnimation(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: padding * 2),
                  _buildQrPreview(context, constraints),
                  SizedBox(height: padding),
                  const Text(
                    'Customize the dots, eyes, and colors above.',
                    style: TextStyle(color: Colors.white10, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: padding),
                  _buildBottomActions(context),
                  SizedBox(height: padding * 2),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWideLayout(BuildContext context) {
    final double padding = UiConstants.mainPadding(context);
    return Row(
      children: [
        Expanded(
          flex: 4, // More weight to the preview on wide screens
          child: LayoutBuilder(builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: EntranceAnimation(
                  child: _buildQrPreview(context, constraints),
                ),
              ),
            );
          }),
        ),
        VerticalDivider(width: 1, color: Colors.white.withValues(alpha: 0.05)),
        Expanded(
          flex: 3,
          child: const EntranceAnimation(
            delay: Duration(milliseconds: 200),
            child: QrCustomizerPanel(showCloseButton: false),
          ),
        ),
      ],
    );
  }

  Widget _buildQrPreview(BuildContext context, BoxConstraints constraints) {
    final double qrContainerSize = ResponsiveSizer.scale(context, 280, max: constraints.maxHeight * 0.55);
    final double qrInnerSize = qrContainerSize * 0.75;

    return Screenshot(
      controller: screenshotController,
      child: Obx(() => Container(
        padding: EdgeInsets.all(qrContainerSize * 0.08),
        decoration: BoxDecoration(
          color: customizationController.qrBackgroundColor.value,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              width: qrInnerSize,
              height: qrInnerSize,
              child: Obx(() {
                final qrWidget = PrettyQrView.data(
                  data: controller.text.isEmpty ? 'VISIONARY' : controller.text,
                  errorCorrectLevel: QrErrorCorrectLevel.H,
                  decoration: customizationController.advancedDecoration,
                );

                if (customizationController.hasGradient.value) {
                  return ShaderMask(
                    shaderCallback: (bounds) =>
                        customizationController.qrGradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: qrWidget,
                  );
                }
                return qrWidget;
              }),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: customizationController.isScannable.value 
                      ? Colors.greenAccent.withValues(alpha: 0.2) 
                      : Colors.redAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: customizationController.isScannable.value ? Colors.greenAccent : Colors.redAccent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      customizationController.isScannable.value ? Icons.check_circle_rounded : Icons.warning_rounded,
                      color: customizationController.isScannable.value ? Colors.greenAccent : Colors.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      customizationController.isScannable.value ? 'SCAN SAFE' : 'LOW CONTRAST',
                      style: TextStyle(
                        color: customizationController.isScannable.value ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> captureAndSaveScreenshot() async {
    try {
      historyController.addItem(controller.text, QrType.created);

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      }

      final img = await screenshotController.capture(pixelRatio: 4.0);
      if (img == null) throw Exception('Visual capture failed.');

      final fileName = 'Visionary_QR_${DateTime.now().millisecondsSinceEpoch}.png';

      if (kIsWeb) {
        Get.snackbar('Web Export Not Available', 'Direct browser file downloads from memory require advanced platform plugins. Please use screenshot capture manually.', duration: const Duration(seconds: 4));
      } else if (Platform.isWindows) {
        final directory = await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/$fileName';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(img);

        Get.snackbar(
          'Export Successful',
          'Saved to Downloads: $fileName',
          mainButton: TextButton(
              onPressed: () =>
                  Process.run('explorer.exe', ['/select,', imagePath]),
              child: const Text('OPEN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        );
      } else {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/$fileName';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(img);
        Get.snackbar('Export Successful', 'QR Card ready!');
      }
    } catch (e) {
      Get.snackbar('Export Failed', e.toString(),
          backgroundColor: Colors.redAccent);
    }
  }

  Future<void> captureAndShare() async {
    try {
      final img = await screenshotController.capture(pixelRatio: 3.0);
      if (img == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/shared_qr.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(img);

      // New share_plus API
      // Use SharePlus v12 API
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath)],
          text: 'Check out my Visionary QR code!',
        ),
      );
    } catch (e) {
      Get.snackbar('Share Failed', e.toString());
    }
  }
}
