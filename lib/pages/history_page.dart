import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/controllers/history_controller.dart';
import 'package:gotech_app/widgets/adaptive_shell.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    // RESTORED HIERARCHY: Background -> Shell -> Single Scaffold
    return StartBackgroundColor(
      child: AdaptiveShell(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: ResponsiveLayout.isMobile(context)
                ? AppBarWidget(onTap: () => Get.back())
                : null,
            title: const Text(
              'THE VAULT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white70,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white38),
                onPressed: () => _showClearDialog(context, controller),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: MaxWidthContainer(
            maxWidth: UiConstants.maxContentWidth,
            child: Obx(() {
              final double padding = UiConstants.mainPadding(context);
              
              if (controller.history.isEmpty) {
                return Center(
                  child: EntranceAnimation(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: ResponsiveSizer.scale(context, 100, max: 150), 
                            color: Colors.white.withValues(alpha: 0.1)),
                        SizedBox(height: padding),
                        Text(
                          'Your vault is empty',
                          style: TextStyle(
                            color: Colors.white24, 
                            fontSize: ResponsiveSizer.scale(context, 18, max: 24), 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Scanned and created codes appear here.',
                          style: TextStyle(
                            color: Colors.white10, 
                            fontSize: ResponsiveSizer.scale(context, 12, max: 16)
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final bool isWide = !ResponsiveLayout.isMobile(context);

              return isWide
                  ? GridView.builder(
                      padding: EdgeInsets.all(padding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveLayout.isDesktop(context) ? 4 : 2,
                        crossAxisSpacing: padding / 2,
                        mainAxisSpacing: padding / 2,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: controller.history.length,
                      itemBuilder: (context, index) => _HistoryCard(
                        item: controller.history[index],
                        controller: controller,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(padding),
                      itemCount: controller.history.length,
                      itemBuilder: (context, index) {
                        final item = controller.history[index];
                        return _HistoryCard(item: item, controller: controller);
                      },
                    );
            }),
          ),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, HistoryController controller) {
    Get.defaultDialog(
      title: 'Clear Vault?',
      middleText: 'This will permanently remove all saved history.',
      backgroundColor: const Color(0xff1a1a2e),
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: 'CLEAR',
      textCancel: 'CANCEL',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        HapticFeedback.heavyImpact();
        controller.clearHistory();
        Get.back();
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QrHistoryItem item;
  final HistoryController controller;

  const _HistoryCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isScanned = item.type == QrType.scanned;
    final String dateStr = DateFormat('MMM d, HH:mm').format(item.timestamp);
    
    // Smart Data Detection
    final bool isUrl = item.data.startsWith('http://') || item.data.startsWith('https://');
    final bool isEmail = item.data.contains('@') && item.data.contains('.');
    final bool isPhone = item.data.startsWith('+') || (RegExp(r'^[0-9]+$').hasMatch(item.data.replaceAll(' ', '')) && item.data.length > 5);

    return EntranceAnimation(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(0),
          borderRadius: 20,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isScanned
                    ? Colors.blueAccent.withValues(alpha: 0.1)
                    : Colors.purpleAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isScanned ? Icons.qr_code_scanner_rounded : Icons.add_box_rounded,
                color: isScanned ? Colors.blueAccent : Colors.purpleAccent,
              ),
            ),
            title: Text(
              item.data,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${isScanned ? "Scanned" : "Created"} • $dateStr',
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isUrl || isEmail || isPhone)
                  IconButton(
                    icon: Icon(
                      isUrl ? Icons.open_in_new_rounded : isEmail ? Icons.email_rounded : Icons.phone_rounded,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _handleAction(item.data, isUrl, isEmail, isPhone);
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20, color: Colors.white38),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Clipboard.setData(ClipboardData(text: item.data));
                    Get.snackbar('Copied', 'Content copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white10);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 20, color: Colors.redAccent.withValues(alpha: 0.5)),
                  onPressed: () {
                     HapticFeedback.lightImpact();
                     controller.deleteItem(item.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.tryParse(url) ?? Uri();
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch link');
    }
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

