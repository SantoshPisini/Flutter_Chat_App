import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//        theme: ThemeData.dark().copyWith(
//          textTheme: TextTheme(
//            body1: TextStyle(color: Colors.black54),
//          ),
//        ),
        initialRoute: WelcomeScreen.name,
        routes: {
          WelcomeScreen.name: (context) => WelcomeScreen(),
          LoginScreen.name: (context) => LoginScreen(),
          RegistrationScreen.name: (context) => RegistrationScreen(),
          ChatScreen.name: (context) => ChatScreen(),
        });
  }
}
