import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/pages/customizer_page.dart';
import 'package:gotech_app/widgets/adaptive_shell.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController controller = TextEditingController();

  // Track data for live preview
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _qrData = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
        child: AdaptiveShell(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppBarWidget(
            onTap: () => Get.back(),
          ),
          title: const Text('GENERATE QR',
              style: TextStyle(
                  letterSpacing: 4,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: MaxWidthContainer(
            maxWidth: 800,
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: EntranceAnimation(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          _buildPreviewBox(),
                          const SizedBox(height: 40),
                          _buildInputFields(),
                          const SizedBox(height: 40),
                          const Text(
                            'The preview updates instantly as you type.',
                            style: TextStyle(color: Colors.white24, fontSize: 12),
                          ),
                          const SizedBox(height: 40),
                          _buildBottomBar(context),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    ));
  }

  Widget _buildPreviewBox() {
    return GlassContainer(
      borderRadius: 30,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('LIVE PREVIEW',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.blueAccent)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
            ),
            child: SizedBox(
              width: 180,
              height: 180,
              child: PrettyQrView.data(
                data: _qrData.isEmpty ? 'VISIONARY QR' : _qrData,
                errorCorrectLevel: QrErrorCorrectLevel.H, // Maximum resilience for custom styles
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    roundFactor: 1,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return GlassContainer(
      borderRadius: 30,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTENT DATA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Paste link or type text here...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: Colors.blueAccent.withValues(alpha: 0.3)),
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return EntranceAnimation(
      delay: const Duration(milliseconds: 200),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 25,
        child: Row(
          children: [
            Expanded(
              child: NextPageButton(
                text: 'PREVIEW & STYLE',
                icon: const Icon(Icons.auto_awesome_rounded),
                goto: () => _handleGenerate(),
                heroTag: 'generateHero',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGenerate() {
    if (controller.text.trim().isNotEmpty) {
      Get.to(() => CustomizerPage(controller: controller),
          transition: Transition.cupertino);
    } else {
      Get.snackbar(
        'Empty Data',
        'Please enter some text or URL first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 20,
      );
    }
  }
}
