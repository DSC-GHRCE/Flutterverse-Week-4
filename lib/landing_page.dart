import 'package:chat_app/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/home_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went Wrong"),
            );
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: SizedBox(
                  width: 225,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      AuthPorvider().googleLogin();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(
                          Icons.login,
                          size: 30.0,
                        ),
                        Text(
                          "Google signin",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
