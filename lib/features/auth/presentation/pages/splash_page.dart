import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/core/common/assets/app_vectors.dart';
import 'package:spotify_clone/features/auth/presentation/pages/get_started_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    redirectToGetStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AppVectors.logoSvg,
        ),
      ),
    );
  }

  Future<void> redirectToGetStarted() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const GetStartedPage()));
  }
}
