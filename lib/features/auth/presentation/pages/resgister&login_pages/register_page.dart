import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/core/common/assets/app_vectors.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/buttons/basic_app_button.dart';
import 'package:spotify_clone/core/common/widgets/text_feild/text_form_feild.dart';
import 'package:spotify_clone/features/auth/presentation/pages/sign_in_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // isObscureText value
  bool isObscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Register',
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
                hintText: 'Full Name',
                controller: nameController,
              ),
              const SizedBox(
                height: 20,
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
                    // context.read<AuthBloc>().add(
                    //       AuthRegisterUserEvent(
                    //         name: nameController.text.trim(),
                    //         email: emailController.text.trim(),
                    //         password: passwordController.text.trim(),
                    //       ),
                    //     );
                  }
                },
                btnText: 'Create Account',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Do You Have An Account ? ',
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
                        builder: (_) => const SignInPage(),
                      ),
                    );
                  },
                text: 'Sign In',
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
