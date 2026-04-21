import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

enum QrModuleType { smooth, squares, rounded }

class QrCustomizationController extends GetxController {
  // --- Style State ---
  var dotRoundness = 0.5.obs;
  var eyeRoundness = 0.5.obs;

  var dotColor = Rx<Color>(Colors.black);
  var eyeColor = Rx<Color>(Colors.black);
  var qrBackgroundColor = Rx<Color>(Colors.white);

  var hasGradient = false.obs;
  var gradientColor1 = Rx<Color>(Colors.blue);
  var gradientColor2 = Rx<Color>(Colors.purple);
  var gradientRotation = 0.0.obs; // In degrees

  var selectedLogo = Rx<String?>(null); 
  var customLogoPath = Rx<String?>(null); // New: Chosen from gallery
  var moduleType = QrModuleType.smooth.obs; // New: DNA Shape
  var isScannable = true.obs; 

  // --- Setters ---
  void setDotRoundness(double value) => dotRoundness.value = value;
  void setEyeRoundness(double value) => eyeRoundness.value = value;
  void setDotColor(Color color) => dotColor.value = color;
  void setEyeColor(Color color) => eyeColor.value = color;
  void setQRBackgroundColor(Color color) => qrBackgroundColor.value = color;
  void setGradientRotation(double value) => gradientRotation.value = value;
  void setModuleType(QrModuleType type) => moduleType.value = type;

  void setLogo(String? logoPath, {bool isCustom = false}) {
    if (isCustom) {
      customLogoPath.value = logoPath;
      selectedLogo.value = null;
    } else {
      selectedLogo.value = logoPath;
      customLogoPath.value = null;
    }
    checkScannability();
  }

  // --- Scannability Guard ---
  void checkScannability() {
    double bgLuminance = qrBackgroundColor.value.computeLuminance();
    
    // Calculate average gradient luminance
    double g1Luminance = gradientColor1.value.computeLuminance();
    double g2Luminance = gradientColor2.value.computeLuminance();
    double avgGradientLuminance = (g1Luminance + g2Luminance) / 2;

    double contrast;
    if (hasGradient.value) {
      contrast = (bgLuminance - avgGradientLuminance).abs();
    } else {
      contrast = (bgLuminance - dotColor.value.computeLuminance()).abs();
    }

    // A contrast difference of > 0.3 is generally enough for modern phone cameras, 
    // but we use 0.4 for "Visionary" level reliability.
    isScannable.value = contrast > 0.4;
  }

  @override
  void onInit() {
    super.onInit();
    // Re-check scannability whenever core properties change
    everAll([dotColor, eyeColor, qrBackgroundColor, hasGradient, gradientColor1, gradientColor2], (_) => checkScannability());
  }

  // --- Derived Styles ---

  Gradient get qrGradient => LinearGradient(
        colors: [gradientColor1.value, gradientColor2.value],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(gradientRotation.value * (3.14159 / 180)),
      );

  PrettyQrDecoration get advancedDecoration {
    final logoImage = customLogoPath.value != null
        ? FileImage(File(customLogoPath.value!))
        : (selectedLogo.value != null ? NetworkImage(selectedLogo.value!) : null);

    PrettyQrShape dataSymbol;
    switch (moduleType.value) {
      case QrModuleType.squares:
        dataSymbol = PrettyQrSquaresSymbol(
          color: hasGradient.value ? Colors.white : dotColor.value,
          rounding: 0,
        );
        break;
      case QrModuleType.rounded:
        dataSymbol = PrettyQrSquaresSymbol(
          color: hasGradient.value ? Colors.white : dotColor.value,
          rounding: 1,
        );
        break;
      case QrModuleType.smooth:
        dataSymbol = PrettyQrSmoothSymbol(
          color: hasGradient.value ? Colors.white : dotColor.value,
          roundFactor: dotRoundness.value,
        );
        break;
    }

    return PrettyQrDecoration(
      background: Colors.transparent,
      image: logoImage != null
          ? PrettyQrDecorationImage(
              image: logoImage as ImageProvider,
              position: PrettyQrDecorationImagePosition.embedded,
            )
          : null,
      shape: PrettyQrShape.custom(
        dataSymbol,
        finderPattern: PrettyQrSquaresSymbol(
          color: hasGradient.value ? Colors.white : eyeColor.value,
          rounding: eyeRoundness.value,
          unifiedFinderPattern: true,
        ),
      ),
    );
  }
}
  // To support gradients across the entire QR in PrettyQrCode, 
  // it's best to use a ShaderMask on the widget as before, 
  // or use the 'brush' property if available. 
  // PrettyQrDecoration in 3.0 uses 'PrettyQrBrush' for colors.

