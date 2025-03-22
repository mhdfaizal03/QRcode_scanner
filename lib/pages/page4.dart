import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/pages/page_3.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class Page4 extends StatelessWidget {
  final TextEditingController controller;
  Page4({super.key, required this.controller});

  Uint8List? image;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: AppBarWidget(
            onTap: () {
              Get.back();
              controller.clear();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NextPageButton(
              text: 'Generate again',
              icon: const Icon(
                Icons.qr_code_2_rounded,
              ),
              goto: () {
                Get.back();
                controller.clear();
              },
              heroTag: 'generateAgainHero',
            ),
            const SizedBox(
              width: 10,
            ),
            NextPageButton(
              text: 'Capture',
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              goto: () async {
                await captureAndSaveScreenshot();
              },
              heroTag: 'screenshotHero',
            ),
          ],
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              color: Colors.white,
              child: QrImageView(
                data: controller.text,
                embeddedImageStyle:
                    const QrEmbeddedImageStyle(size: Size(100, 100)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> captureAndSaveScreenshot() async {
    try {
      // Check for storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Capture the screenshot
      final img = await screenshotController.capture();
      if (img == null) {
        throw Exception('Failed to capture screenshot.');
      }

      // Get the directory to save the image
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final imageFile = File(imagePath);

      // Save the image to the file
      await imageFile.writeAsBytes(img);
      Get.snackbar('Success', 'Screenshot saved to $imagePath');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture screenshot: $e',
        colorText: Colors.white,
        backgroundColor: Colors.black,
        barBlur: 0.4,
      );
    }
  }
}
