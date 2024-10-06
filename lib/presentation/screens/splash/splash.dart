import 'dart:async';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trace_or/device/device_size.dart';
import 'package:trace_or/config/theme/app_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  VideoState createState() => VideoState();
}

DeviceSize? deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    appRouter.go('/login');
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
        size: MediaQuery.of(context).size,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
      backgroundColor: AppColors.colorOne,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: animation.value * 250,
                height: animation.value * 250,
                child: SvgPicture.asset(ImagesReferences.logo),
              ),
            ],
          ),
        ],
      ),
    );
  }
}