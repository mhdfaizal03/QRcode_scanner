import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/pages/Page_2.dart';
import 'package:gotech_app/pages/page_3.dart';
import 'package:lottie/lottie.dart';

class Page1 extends StatefulWidget {
  const Page1({
    super.key,
  });

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return StartBackgroundColor(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NextPageButton(
              text: 'Scan code',
              icon: const Icon(
                Icons.qr_code_2_rounded,
              ),
              goto: () =>
                  Get.to(() => const Page2(), transition: Transition.cupertino),
              heroTag: 'scanCodeHero',
            ),
            const SizedBox(
              width: 10,
            ),
            NextPageButton(
              text: 'Create code',
              icon: const Icon(
                Icons.qr_code_2_rounded,
              ),
              goto: () =>
                  Get.to(() => Page3(), transition: Transition.cupertino),
              heroTag: 'createCodeHero',
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'QR Scanner,',
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            GestureDetector(
              onTap: () =>
                  Get.to(const Page2(), transition: Transition.cupertino),
              child: Lottie.asset(
                frameRate: FrameRate.max,
                filterQuality: FilterQuality.high,
                "assets/qranimation1.json",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
