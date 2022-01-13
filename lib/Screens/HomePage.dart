import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playground/Screens/SignInScreen.dart';
import 'package:playground/Services/auth_services.dart';
import 'package:playground/Widgets/HomePage/ChatListWidget.dart';
import 'package:playground/Widgets/HomePage/ChatTextField.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final Size sizeofScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect( 
              borderRadius: BorderRadius.circular(50),
              child: Image.network(user!.photoURL!)),
        ),
        title: Text(user.displayName!),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<AuthServices>().signOut().whenComplete(() {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context)=> const SignInScreen(),
                    )
                );
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: Icon(Icons.logout_rounded)),
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: ChatListStream(user: user, sizeOfScreen: sizeofScreen,)
              ),
              SizedBox(
                height: sizeofScreen.height * 0.1,
                width: double.maxFinite,
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: sizeofScreen.height * 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: ChatTextField(user: user,),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListStream extends StatefulWidget {
  const ChatListStream({Key? key,required this.user,required this.sizeOfScreen}) : super(key: key);
  final User? user;
  final Size sizeOfScreen;

  @override
  _ChatListStreamState createState() => _ChatListStreamState();
}

class _ChatListStreamState extends State<ChatListStream> {
  final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
      .collection('chats')
      .orderBy('createdAt',descending: false)
      .limit(15)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatStream,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return ChatList(user: widget.user, sizeofScreen: widget.sizeOfScreen, snapshot: snapshot,);
        }
    );
  }
}




