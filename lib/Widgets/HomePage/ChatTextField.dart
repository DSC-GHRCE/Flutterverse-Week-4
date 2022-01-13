import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User? user;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _chatController = TextEditingController();
  CollectionReference chatRef = FirebaseFirestore.instance.collection('chats');

  Future sendMessage () async {
    if(_chatController.text.isNotEmpty && _chatController.text.length <= 500){
      try{
        return chatRef.doc().set(
            {
              "text": _chatController.text,
              "owner": widget.user!.uid,
              "imageURL": widget.user!.photoURL,
              "createdAt":FieldValue.serverTimestamp(),
            }
        ).then((value) => _chatController.clear());
      } catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(e.toString())
            )
        );
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              content: Text("Failed to send Message")
          )
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blueAccent.shade700
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blueAccent.shade700
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                filled: true,
                fillColor: Colors.blue.shade50 ,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Enter your message here',
              ),
            )
        ),
        const SizedBox(width: 10,),
        GestureDetector(
          onTap: sendMessage,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: GestureDetector(
              onTap: sendMessage,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent.shade700,
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}