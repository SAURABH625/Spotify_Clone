import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/core/common/assets/app_vectors.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/buttons/basic_app_button.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/core/common/widgets/text_feild/text_form_feild.dart';
import 'package:spotify_clone/core/utils/snakbar.dart';
import 'package:spotify_clone/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:spotify_clone/features/auth/presentation/pages/resgister&login_pages/register_page.dart';
import 'package:spotify_clone/features/home/presentation/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // isObscureText value
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logoSvg,
          width: 35,
          height: 35,
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            snakbar(context, state.error);
          } else if (state is AuthSuccessState) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Loader();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MyTextFormFeild(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFormFeild(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: isObscure,
                    sufixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  BasicAppButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthUserSignInEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    btnText: 'Sign In',
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Not A Member ? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                text: 'Register Now',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
