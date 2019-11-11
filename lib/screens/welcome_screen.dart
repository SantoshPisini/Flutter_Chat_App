import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String name = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();

    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_animationController);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {
        //for setting animation color bg
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                  tag: 'logo',
                ),
                TypewriterAnimatedTextKit(
                  textStyle: TextStyle(
                    letterSpacing: 3.0,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  text: <String>['Flash Chat'],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            new RoundedButton(
              color: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.name);
              },
            ),
            new RoundedButton(
              color: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
