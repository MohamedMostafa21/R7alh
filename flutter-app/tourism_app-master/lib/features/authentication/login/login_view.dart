import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/login/widgets/auth_prompt.dart';
import 'package:tourism_app/features/authentication/login/widgets/curved_container.dart';
import 'package:tourism_app/features/authentication/login/widgets/login_dialog.dart';
import 'package:tourism_app/features/authentication/signup/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: CurvedContainer(),
            ),
            Positioned(
              top: MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.sizeOf(context).height * 0.3 : MediaQuery.sizeOf(context).height * 0.17,
              child: SlideTransition(
                position: _slideAnimation,
                child: LoginDialog(),
              ),
            ),
            Positioned(
              bottom: 60,
              child: AuthPrompt(
                text: 'Don\'t have an account? ',
                actionText: 'Sign Up',
                onTap: () => context.navigateToPage(pageTransitionType: PageTransitionType.bottomToTop, SignUpScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
