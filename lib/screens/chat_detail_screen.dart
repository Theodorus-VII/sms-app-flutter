import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class ChatDetailsPage extends StatefulWidget {
  final String name;
  final String threadId;
  const ChatDetailsPage(
      {required this.name, required this.threadId, super.key});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getConversationHistoryById(widget.threadId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SmsMessage> messages = snapshot.data as List<SmsMessage>;
            return Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black12,
                  flexibleSpace: SafeArea(
                      child: Container(
                          padding: const EdgeInsets.only(right: 16),
                          child: Row(children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  // Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                                ]))
                          ])))),
              body: Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages[index].type ==
                                  SmsType.MESSAGE_TYPE_INBOX
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (messages[index].type ==
                                        SmsType.MESSAGE_TYPE_INBOX
                                    ? Colors.grey.shade200
                                    : Colors.green[200]),
                              ),
                              child: Text(
                                messages[index].body ?? "",
                                style: TextStyle(fontSize: 15),
                              )),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              onSubmitted: (value) {
                                messageController.text = value;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              final recipient = widget.name;
                              setState(() {
                                _sendMessage(
                                    [recipient], messageController.text);
                                messageController.text = "";
                              });
                            },
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
            ;
          }
        });
  }

  _sendMessage(List<String> recipients, String message) async {
    final Telephony telephony = Telephony.instance;
    for (var recepient in recipients) {
      telephony.sendSms(to: recepient, message: message);
    }
  }

  Future<List<SmsMessage>> getInboxById(String id) async {
    ///each conversation has a thread id. this will filter it by that
    final Telephony telephony = Telephony.instance;
    return await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.THREAD_ID,
        SmsColumn.ID
      ],
      filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(id),
      sortOrder: [
        OrderBy(SmsColumn.DATE, sort: Sort.DESC),
        OrderBy(SmsColumn.BODY)
      ],
    );
  }

  Future<List<SmsMessage>> getSentById(String id) async {
    ///each conversation has a thread id. this will filter it by that
    final Telephony telephony = Telephony.instance;
    return await telephony.getSentSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.THREAD_ID,
        SmsColumn.ID
      ],
      filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(id),
      sortOrder: [
        OrderBy(SmsColumn.DATE, sort: Sort.DESC),
        OrderBy(SmsColumn.BODY)
      ],
    );
  }

  getConversationHistoryById(String id) async {
    List<SmsMessage> inbox = await getInboxById(id);
    List<SmsMessage> sent = await getSentById(id);
    List<SmsMessage> history = [...inbox, ...sent];
    history.sort((a, b) => a.date!.compareTo(b.date!));
    return history;
  }
}
