import 'package:flutter/material.dart';
import 'package:sms_mms_app/screens/chat_detail_screen.dart';

class Conversation extends StatefulWidget {
  final String name;
  final String snippet;
  final int threadId;
  final int? messageCount;
  const Conversation(
      {required this.name,
      required this.snippet,
      required this.threadId,
      this.messageCount,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 230, 225, 243),
                
                child: Icon(Icons.person_2_outlined, color: Colors.blueGrey[900],),
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
                    Container(
                      // color: Colors.white,
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        children: [Text(
                          widget.snippet,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        if (widget.messageCount != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircleAvatar(
                          child: Text('${widget.messageCount}', style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    )]
                      ),
                    ),
                    
                  ],
                )),
              )
            ],
          ),
        ));
  }
}
