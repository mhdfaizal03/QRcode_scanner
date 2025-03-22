import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/appbar.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/nextpage_button.dart';
import 'package:gotech_app/pages/page4.dart';

class Page3 extends StatelessWidget {
  Page3({super.key});

  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NextPageButton(
            text: 'Generate QR',
            icon: const Icon(
              Icons.qr_code_2_rounded,
            ),
            goto: () {
              try {
                final valid = formKey.currentState!.validate();
                if (valid) {
                  Get.to(
                      () => Page4(
                            controller: controller,
                          ),
                      transition: Transition.cupertino);
                } else {
                  Get.snackbar(
                    'Text not found',
                    'Type something to generate QR code!',
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'An error occurred: $e',
                );
              }
            },
            heroTag: 'createQrHero',
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            textAlign: TextAlign.center,
            'Write here something to create your own QR code,',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white38,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  } else {
                    return null;
                  }
                },
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Eg: https://www.google.com',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.black12,
                  filled: true,
                ),
              ),
            ),
          ),
          const Text(
            'Click \'Generate QR\' to see the QR code',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          )
        ],
      ),
    ));
  }
}
