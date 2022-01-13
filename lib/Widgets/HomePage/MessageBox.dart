import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    Key? key,
    required this.sizeofScreen,
    required this.data,
    required this.alignRight,
  }) : super(key: key);

  final Size sizeofScreen;
  final Map<String,dynamic> data;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: sizeofScreen.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: alignRight ? Colors.blueAccent.shade700 : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: alignRight ?  const Radius.circular(20) : const Radius.circular(5),
              bottomLeft: const Radius.circular(20),
              topRight: alignRight ?  const Radius.circular(5) : const Radius.circular(20),
              bottomRight: const Radius.circular(20),
            )
        ),
        child: Text(
          data["text"],
          style: TextStyle(
            fontSize: 18,
            color: alignRight ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}