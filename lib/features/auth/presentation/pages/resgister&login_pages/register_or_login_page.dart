import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/core/common/assets/app_images.dart';
import 'package:spotify_clone/core/common/assets/app_vectors.dart';
import 'package:spotify_clone/core/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/buttons/basic_app_button.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/auth/presentation/pages/resgister&login_pages/register_page.dart';
import 'package:spotify_clone/features/auth/presentation/pages/sign_in_page.dart';

class RegisterOrLoginPage extends StatelessWidget {
  const RegisterOrLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVectors.topPattern,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              AppVectors.bottomPattern,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              AppImages.authBG,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    width: 70,
                    height: 70,
                    AppVectors.logoSvg,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Enjoy Listening To Music',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                const Text(
                  'Spotify is a proprietary Swedish audio streamimg and media service provider.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: BasicAppButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        btnText: 'Register',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextButton(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 27)),
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              width: 2,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
