import 'package:calendar/core/utils/context_utils.dart';
import 'package:flutter/material.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_images.dart';
import '../../router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    introPage();
  }

  void introPage() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    router.pushReplacement('/home');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            heightFactor: size.height * 0.0045,
            child: Image.asset(
              AppIcons.appIcon,
              width: size.width * 0.5,
              height: size.width * 0.5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size(size.width * 0.1, size.width * 0.1),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(AppImages.flutterBro),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "powered by",
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    "FlutterBro",
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
