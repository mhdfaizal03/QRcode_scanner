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
            maxWidth: UiConstants.maxContentWidth,
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              tablet: _buildWideLayout(context),
              desktop: _buildWideLayout(context),
            ),
          ),
        ),
      ),
    ));
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
                  _buildPreviewBox(context, constraints),
                  SizedBox(height: padding),
                  _buildInputFields(),
                  SizedBox(height: padding),
                  const Text(
                    'The preview updates instantly as you type.',
                    style: TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                  SizedBox(height: padding),
                  _buildBottomBar(context),
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
          flex: 1,
          child: LayoutBuilder(builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: EntranceAnimation(
                  child: _buildPreviewBox(context, constraints),
                ),
              ),
            );
          }),
        ),
        VerticalDivider(width: 1, color: Colors.white.withValues(alpha: 0.05)),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: EntranceAnimation(
              delay: const Duration(milliseconds: 200),
              child: Column(
                children: [
                  _buildInputFields(),
                  SizedBox(height: padding),
                  _buildBottomBar(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewBox(BuildContext context, BoxConstraints constraints) {
    final double qrContainerSize = ResponsiveSizer.scale(context, 220, max: constraints.maxHeight * 0.5);
    final double qrInnerSize = qrContainerSize * 0.7;

    return GlassContainer(
      borderRadius: 30,
      padding: EdgeInsets.all(qrContainerSize * 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LIVE PREVIEW',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.blueAccent)),
          SizedBox(height: qrContainerSize * 0.08),
          Container(
            padding: EdgeInsets.all(qrContainerSize * 0.08),
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
              width: qrInnerSize,
              height: qrInnerSize,
              child: PrettyQrView.data(
                data: _qrData.isEmpty ? 'VISIONARY QR' : _qrData,
                errorCorrectLevel: QrErrorCorrectLevel.H,
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
