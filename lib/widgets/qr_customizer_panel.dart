import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotech_app/controllers/qr_customization_controller.dart';
import 'package:gotech_app/decoration.dart';

class QrCustomizerPanel extends StatelessWidget {
  final bool showCloseButton;
  const QrCustomizerPanel({super.key, this.showCloseButton = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QrCustomizationController>();

    return GlassContainer(
      borderRadius: showCloseButton ? 30 : 0,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCloseButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Infinite Styles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            if (showCloseButton) const SizedBox(height: 20),

            // --- Shapes Section ---
            _sectionHeader('Shapes & Rounding'),
            const SizedBox(height: 10),
            Obx(() => _sliderRow('Dot Rounding', controller.dotRoundness.value,
                (v) => controller.setDotRoundness(v))),
            const SizedBox(height: 15),
            _buildShapeSelector(controller),
            const SizedBox(height: 15),
            Obx(() => _sliderRow('Eye Rounding', controller.eyeRoundness.value,
                (v) => controller.setEyeRoundness(v))),

            const SizedBox(height: 25),

            // --- Logos Section ---
            _sectionHeader('Center Logo'),
            const SizedBox(height: 15),
            _buildLogoSelector(controller),

            const SizedBox(height: 25),

            // --- Colors Section ---
            _sectionHeader('Colors'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: _colorPickerTile('Dots', controller.dotColor.value,
                        (c) => controller.setDotColor(c), context)),
                const SizedBox(width: 12),
                Expanded(
                    child: _colorPickerTile('Eyes', controller.eyeColor.value,
                        (c) => controller.setEyeColor(c), context)),
              ],
            ),
            const SizedBox(height: 12),
            _colorPickerTile('Background', controller.qrBackgroundColor.value,
                (c) => controller.setQRBackgroundColor(c), context),

            const SizedBox(height: 25),

            // --- Effects Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionHeader('Electric Gradient'),
                Obx(() => Switch(
                      value: controller.hasGradient.value,
                      onChanged: (v) => controller.hasGradient.value = v,
                      activeTrackColor:
                          Colors.blueAccent.withValues(alpha: 0.5),
                      activeThumbColor: Colors.blueAccent,
                    )),
              ],
            ),
            Obx(() => controller.hasGradient.value
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      _sliderRow(
                        'Rotation',
                        controller.gradientRotation.value,
                        (v) => controller.setGradientRotation(v),
                        max: 360,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: _colorPickerTile(
                                  'Color 1',
                                  controller.gradientColor1.value,
                                  (c) => controller.gradientColor1.value = c,
                                  context)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _colorPickerTile(
                                  'Color 2',
                                  controller.gradientColor2.value,
                                  (c) => controller.gradientColor2.value = c,
                                  context)),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        color: Colors.white54,
      ),
    );
  }

  Widget _sliderRow(String label, double value, Function(double) onChanged,
      {double max = 1.0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text(value.toStringAsFixed(1),
                style: const TextStyle(color: Colors.blueAccent)),
          ],
        ),
        Slider(
          value: value,
          max: max,
          onChanged: (v) {
            if ((v * 10).round() != (value * 10).round()) {
              HapticFeedback.selectionClick();
            }
            onChanged(v);
          },
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.white10,
        ),
      ],
    );
  }

  Widget _colorPickerTile(String label, Color color,
      Function(Color) onColorChanged, BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xff1a1a2e),
              title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: ColorPicker(
                  color: color,
                  onColorChanged: (Color c) {
                    onColorChanged(c);
                  },
                  width: 40,
                  height: 40,
                  borderRadius: 10,
                  spacing: 10,
                  runSpacing: 10,
                  wheelDiameter: 180,
                  enableOpacity: true,
                  showColorCode: true,
                  colorCodeHasColor: true,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: false,
                    ColorPickerType.primary: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: true,
                    ColorPickerType.wheel: true,
                  },
                  copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                    longPressMenu: true,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('DONE', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 15,
        opacity: 0.05,
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 12),
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeSelector(QrCustomizationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Module Shape', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          children: [
            _shapeItem(controller, QrModuleType.smooth, Icons.bubble_chart_rounded, 'Smooth'),
            const SizedBox(width: 12),
            _shapeItem(controller, QrModuleType.squares, Icons.grid_view_rounded, 'Squares'),
            const SizedBox(width: 12),
            _shapeItem(controller, QrModuleType.rounded, Icons.circle_rounded, 'Rounded'),
          ],
        ),
      ],
    );
  }

  Widget _shapeItem(QrCustomizationController controller, QrModuleType type, IconData icon, String label) {
    return Obx(() {
      final isSelected = controller.moduleType.value == type;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            controller.setModuleType(type);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white10,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.white10,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: isSelected ? Colors.blueAccent : Colors.white38, size: 20),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.white38)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLogoSelector(QrCustomizationController controller) {
    final List<String?> logos = [
      null, // None
      'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-color-icon.png',
      'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/facebook-app-round-white-icon.png',
      'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/twitter-icon.png',
      'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/instagram-black-icon.png',
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // PICKER BUTTON
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                HapticFeedback.mediumImpact();
                controller.setLogo(image.path, isCustom: true);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3), width: 2),
              ),
              child: const Center(child: Icon(Icons.add_photo_alternate_rounded, color: Colors.blueAccent, size: 20)),
            ),
          ),

          ...logos.map((logo) {
            return Obx(() {
              final isSelected = controller.selectedLogo.value == logo && controller.customLogoPath.value == null;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.setLogo(logo);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.white10,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: logo == null
                        ? const Icon(Icons.block_rounded, size: 20, color: Colors.white24)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              logo,
                              width: 30,
                              height: 30,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported_rounded, size: 20, color: Colors.white24),
                            ),
                          ),
                  ),
                ),
              );
            });
          }),
          
          // CUSTOM LOGO PREVIEW (if exists)
          Obx(() {
            if (controller.customLogoPath.value == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 12),
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(controller.customLogoPath.value!),
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
