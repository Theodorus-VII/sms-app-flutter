import 'package:flutter/material.dart';
import 'package:sms_mms_app/screens/chat_detail_screen.dart';

class Conversation extends StatefulWidget {
  final String name;
  final String snippet;
  final int threadId;
  const Conversation(
      {required this.name,
      required this.snippet,
      required this.threadId,
      super.key});

  @override
  State<Conversation> createState() => _ChatItemState();
}

class _ChatItemState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatDetailsPage(
              name: widget.name,
              threadId: "${widget.threadId}",
            );
          }));
        },
        child: Container(
          color: Colors.black12,
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                child: const Icon(Icons.person),
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.snippet,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    )
                  ],
                )),
              )
            ],
          ),
        ));
  }
}
