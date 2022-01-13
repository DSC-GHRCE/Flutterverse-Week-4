import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playground/Screens/HomePage.dart';
import 'package:playground/Services/auth_services.dart';
import 'package:provider/src/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top  + 10;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              )
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: topPadding),
              children: [
                SizedBox(
                  height: 35,
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Image.asset('assets/applogo.jpg'),
                      SizedBox(width: 10,),
                      Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    thickness: 2,
                    height: 30
                ),
                SizedBox(
                  height: 200,
                  child: Center(
                      child: Image.asset('assets/login.png')
                  ),
                ),
                const Divider(
                    thickness: 2,
                    height: 30
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String msg;
                      msg = await context.read<AuthServices>().loginWithGoogle();
                      if(msg == 'In'){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)
                    ),
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: context.watch<AuthServices>().isSigningIn ?  const Center(
                      child: CircularProgressIndicator(),
                    ) : const Text('Login with Google',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

