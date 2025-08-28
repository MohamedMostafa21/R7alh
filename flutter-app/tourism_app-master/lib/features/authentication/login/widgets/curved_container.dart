import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/features/authentication/login/widgets/top_curve_clipper.dart';

class CurvedContainer extends StatefulWidget {
  const CurvedContainer({super.key});

  @override
  CurvedContainerState createState() => CurvedContainerState();
}

class CurvedContainerState extends State<CurvedContainer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;

  final _image = AssetImage(AppImages.egypt);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload the image after the dependencies are ready
    precacheImage(_image, context);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and the slide animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: Offset(-1, 0), // Start from the left
      end: Offset(0, 0), // End at the current position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation2 = Tween<Offset>(
      begin: Offset(-1, 0), // Start from the left
      end: Offset(0, 0), // End at the current position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation when the widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopCurveClipper(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.egypt),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
          gradient: LinearGradient(
            colors: [AppColors.primaryColor.withOpacity(0.8), AppColors.primaryColor],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        height: MediaQuery.sizeOf(context).height * 0.65,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            // Apply SlideTransition to both texts
            SlideTransition(
              position: _slideAnimation1,
              child: Text(
                'Guide To Egypt',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
              ),
            ),
            SlideTransition(
              position: _slideAnimation2,
              child: Text(
                'Discover Egypt',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
