import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:playground/Screens/HomePage.dart';
import 'package:playground/Services/auth_services.dart';
import 'package:provider/provider.dart';
import 'Screens/SignInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return MultiProvider(
            providers: [
              Provider(
                create: (_) => AuthServices(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) => context.read<AuthServices>().authStateChanges,
                initialData: null,
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chat-Up',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const AuthWrapper(),
            ),
          );
        }else {
         return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser != null){
      return const HomePage();
    }
    else{
      return const SignInScreen();
    }
  }
}




