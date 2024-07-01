import 'package:camera/camera.dart';
import 'package:cours_miage/main.dart';
import 'package:cours_miage/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController controller;
  late PageController pageController;
  bool isFlashOn = false;
  int numPage=0;

  setFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    pageController=PageController(initialPage: numPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              //physics: NeverScrollableScrollPhysics(),
              children: [
                cameraScanner(),
                Stack(
                  children: [
                    Container(color: Colors.white,child: const Center(
                      child: CardWidget(isClickable: false,isRotated: true,),
                    ),),
                    SafeArea(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
                alignment: Alignment.bottomCenter ,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: numPage == 0 ? Colors.black : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                  ),
                  child: ToggleSwitch(
                    initialLabelIndex: numPage,
                    minWidth: 150,
                    cornerRadius: 35,
                    activeFgColor: numPage == 0 ? Colors.white : Colors.black,
                    inactiveFgColor: numPage == 0 ? Colors.white : Colors.black,
                    activeBgColor:
                    numPage == 0 ? const [Colors.grey] : const [Colors.white],
                    inactiveBgColor: numPage == 0 ? Colors.black : Colors.grey,
                    labels: const ["Scanner un code", "Ma carte"],
                    totalSwitches: 2,
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        numPage = index!;
                        pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      });
                    },
                  ),
                )),
          ],
        ));
  }

  Widget cameraScanner() {
    return Stack(
      children: [
        Center(
            child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                child: CameraPreview(
                  controller,
                ))),
        //Overlay sur la caméra
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode
                        .dstOut), // This one will handle background + difference out
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    )),
                GestureDetector(
                    onTap: () {
                      setFlash();
                      controller.setFlashMode(
                          isFlashOn ? FlashMode.torch : FlashMode.off);
                    },
                    child: Icon(
                      isFlashOn ? Icons.flash_off : Icons.flash_on,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
