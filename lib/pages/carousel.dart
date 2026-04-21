import 'package:flutter/material.dart';
import 'package:gotech_app/pages/scanner_page.dart';
import 'package:gotech_app/pages/dashboard_page.dart';
import 'package:gotech_app/pages/input_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  bool isFirstPage = false;
  bool isLastPage = false;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              PageView(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    isFirstPage = value > 0;
                    isLastPage = value < 2;
                  });
                },
                children: const [
                  DashboardPage(),
                  ScannerPage(),
                  InputPage(),
                ],
              ),
              Container(
                  alignment: const Alignment(0, 0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isFirstPage
                          ? TextButton(
                              onPressed: () {
                                controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              },
                              child: const Text('Back'))
                          : const TextButton(
                              onPressed: null, child: Text('Back')),
                      SmoothPageIndicator(
                          effect: const JumpingDotEffect(),
                          controller: controller,
                          count: 3),
                      isLastPage
                          ? TextButton(
                              onPressed: () {
                                controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: const Text('Next'))
                          : TextButton(
                              onPressed: () {
                                controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: const Text('Done')),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.01,
                  vertical: MediaQuery.of(context).size.height * 0.030,
                ),
                child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          controller.jumpToPage(3);
                        },
                        child: const Text('Skip'))),
              ),
            ],
          )),
    );
  }
}
