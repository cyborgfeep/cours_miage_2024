import 'package:cours_miage/screens/scan_screen.dart';
import 'package:cours_miage/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class CardWidget extends StatefulWidget {
  final bool isClickable;
  final bool? isRotated;

  const CardWidget({super.key, required this.isClickable, this.isRotated});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isClickable) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScanScreen(),
              ));
        }
      },
      child: RotatedBox(
        quarterTurns: widget.isRotated != null && widget.isRotated! ? 1 : 0,
        child: Container(
          height: widget.isRotated != null && widget.isRotated! ? 250 : 200,
          width: widget.isRotated != null && widget.isRotated!
              ? 370
              : MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  image: const AssetImage(imgBg),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(.3), BlendMode.srcIn))),
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(
                        child: PrettyQrView.data(
                          data: 'google.comdfsfdfsfdsfdfsfdsfsdfdsggsgsgsgsgsgsdgsgsdgs',
                        ),
                      )),
                      !widget.isClickable
                          ? const SizedBox.shrink()
                          : const SizedBox(
                              height: 5,
                            ),
                      !widget.isClickable
                          ? const SizedBox.shrink()
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Scanner")
                              ],
                            )
                    ],
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 5, right: 5),
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    imgWave,
                    width: 55,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
