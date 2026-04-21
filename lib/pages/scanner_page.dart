import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/widgets/scan_overlay.dart';
import 'package:gotech_app/controllers/history_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gotech_app/widgets/adaptive_shell.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  bool _hasPermission = false;
  String _barcodeData = '';
  late AnimationController _animationController;
  final historyController = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb) {
      setState(() {
        _hasPermission = true;
      });
      return;
    }

    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
    } else {
      Get.snackbar(
        'Permission denied',
        'Please turn on camera permission in settings',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_barcodeData.isEmpty && capture.barcodes.isNotEmpty) {
      HapticFeedback.heavyImpact();
      setState(() {
        _barcodeData = capture.barcodes.first.rawValue ?? "No Data Found";
      });
      // Save to Vault
      historyController.addItem(_barcodeData, QrType.scanned);
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.tryParse(url) ?? Uri();
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
      child: AdaptiveShell(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: ResponsiveLayout.isMobile(context)
                ? AppBarWidget(
                    onTap: () => Get.back(),
                  )
                : null,
            title: const Text('SCAN QR',
                style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white24)),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: MaxWidthContainer(
              maxWidth: 800,
              child: _hasPermission
                  ? _barcodeData.isEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: MobileScanner(
                                onDetect: _onBarcodeDetected,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: NeonScanOverlay(
                                    animationValue: _animationController.value,
                                  ),
                                  size: MediaQuery.of(context).size,
                                );
                              },
                            ),
                            const Positioned(
                              bottom: 100,
                              child: Text(
                                'Align code within the frame to capture intelligence',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight),
                                child: Center(
                                  child: EntranceAnimation(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 40),
                                        _buildResultCard(),
                                        const SizedBox(height: 40),
                                        _buildActionBottomBar(context),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded,
                            size: 80, color: Colors.white24),
                        SizedBox(height: 20),
                        Text(
                          'Camera permission required',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBottomBar(BuildContext context) {
    return EntranceAnimation(
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 25,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            NextPageButton(
              text: 'Rescan',
              icon: const Icon(Icons.refresh_rounded),
              goto: () => setState(() => _barcodeData = ''),
              heroTag: 'scanAgainHero',
            ),
            _ActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () => SharePlus.instance.share(
                ShareParams(
                  text: 'Visionary Scanned Intelligence: $_barcodeData',
                ),
              ),
            ),
            _ActionButton(
              icon: Icons.copy_rounded,
              label: 'Copy',
              onTap: () {
                Clipboard.setData(ClipboardData(text: _barcodeData));
                Get.snackbar('Copied', 'Saved to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white10);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final bool isUrl = _barcodeData.startsWith('http://') ||
        _barcodeData.startsWith('https://');
    final bool isEmail =
        _barcodeData.contains('@') && _barcodeData.contains('.');
    final bool isPhone = _barcodeData.startsWith('+') ||
        (RegExp(r'^[0-9]+$').hasMatch(_barcodeData.replaceAll(' ', '')) &&
            _barcodeData.length > 5);

    return GlassContainer(
      padding: const EdgeInsets.all(30),
      borderRadius: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActionIcon(isUrl, isEmail, isPhone),
              color: Colors.blueAccent,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'INTELLIGENT DATA FOUND',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _barcodeData,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 30),
          if (isUrl || isEmail || isPhone)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _handleAction(_barcodeData, isUrl, isEmail, isPhone),
                icon: Icon(isUrl
                    ? Icons.open_in_new_rounded
                    : isEmail
                        ? Icons.email_rounded
                        : Icons.phone_rounded),
                label: Text(isUrl
                    ? 'OPEN WEBSITE'
                    : isEmail
                        ? 'SEND EMAIL'
                        : 'CALL NUMBER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getActionIcon(bool isUrl, bool isEmail, bool isPhone) {
    if (isUrl) return Icons.language_rounded;
    if (isEmail) return Icons.alternate_email_rounded;
    if (isPhone) return Icons.phone_android_rounded;
    return Icons.text_snippet_rounded;
  }

  void _handleAction(String data, bool isUrl, bool isEmail, bool isPhone) {
    if (isUrl) {
      _launchURL(data);
    } else if (isEmail) {
      _launchURL('mailto:$data');
    } else if (isPhone) {
      _launchURL('tel:${data.replaceAll(' ', '')}');
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
