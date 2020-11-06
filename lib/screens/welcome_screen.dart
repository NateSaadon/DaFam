import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation =
        ColorTween(begin: Colors.blueGrey, end: Color.fromARGB(255, 48, 48, 48))
            .animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Image.asset('images/logo.png')),
                ),
                height: 180, //60.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Text(
                'DaFam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 88.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            /*
            TypewriterAnimatedTextKit(
              onTap: () {
                print("Tap Event");
              },
              text: ['DaFam'],
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 88.0,
                fontWeight: FontWeight.w900,
              ),
            ),*/
            SizedBox(
              height: 30.0,
            ),
            ButtonWidget(
              title: 'Log In',
              colour: Color.fromARGB(150, 0, 160, 196),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ButtonWidget(
              title: 'Register',
              colour: Color.fromARGB(150, 86, 195, 187),
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
