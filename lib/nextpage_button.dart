import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NextPageButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function goto;
  final String heroTag;

  const NextPageButton({
    super.key,
    required this.text,
    required this.icon,
    required this.goto,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black38),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        onPressed: () => goto(),
        child: Row(
          children: [
            const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
