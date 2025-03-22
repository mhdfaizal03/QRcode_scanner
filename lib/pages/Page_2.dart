import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool _hasPermission = false;
  String _barcodeData = '';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
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
          'Permission denied', 'Please turn on permission in settings');
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    setState(() {
      if (capture.barcodes.isNotEmpty) {
        _barcodeData = capture.barcodes.first.rawValue ?? "No Data Found";
      }
    });
  }

  bool _isURL(String text) {
    const urlPattern =
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    return RegExp(urlPattern).hasMatch(text);
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    // if (await canLaunchUrlString(url)) {
    launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    // } else {
    //   Get.snackbar('Error', 'Could not launch $url');
    //   print('Could not launch $url');
    // }
  }

  Future<void> testLaunch() async {
    const url = 'https://www.google.com';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: AppBarWidget(
            onTap: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        floatingActionButton: _barcodeData.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NextPageButton(
                    text: 'Scan again',
                    icon: const Icon(
                      Icons.qr_code_2_rounded,
                    ),
                    goto: () {
                      setState(() {
                        _barcodeData = ''; // Clear the scanned data
                      });
                    },
                    heroTag: 'scanAgainHero',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  NextPageButton(
                    text: 'Copy text',
                    icon: const Icon(
                      Icons.qr_code_2_rounded,
                    ),
                    goto: () {
                      Clipboard.setData(ClipboardData(text: _barcodeData))
                          .then((value) => Get.snackbar(
                                'Copied text',
                                'Text copied successfully',
                              ));
                    },
                    heroTag: 'copyTextHero',
                  ),
                ],
              )
            : Container(),
        body: Center(
          child: _hasPermission
              ? _barcodeData.isEmpty
                  ? SizedBox(
                      width: 300,
                      height: 300,
                      child: MobileScanner(
                        onDetect: _onBarcodeDetected,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // if (_isURL(_barcodeData)) {
                        _launchURL(_barcodeData);
                        // }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _barcodeData,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
              : const Text(
                  'Camera permission is required to scan QR codes.',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
