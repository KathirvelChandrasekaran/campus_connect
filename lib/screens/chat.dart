import 'package:campus_connect/utils/constants.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class Chat extends StatefulWidget {
  String? email;
  Chat({Key? key, this.email}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final TextEditingController _messageController;
  List<dynamic>? chats;
  bool isLoading = false;
  bool isDataLoaded = false;

  @override
  void initState() {
    _messageController = TextEditingController();
    getChat();
    super.initState();
  }

  getChat() async {
    setState(() {
      isDataLoaded = false;
      isLoading = true;
    });
    var res = await supabase.from('chat').select().execute();
    setState(() {
      chats = res.data;
      isDataLoaded = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.email.toString(),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isDataLoaded
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .where('from',
                              isEqualTo: supabase.auth.currentUser?.email)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return GestureDetector(
                          onTap: () {
                            getChat();
                          },
                          child: ListView(
                              shrinkWrap: true,
                              children: chats!
                                  .map(
                                    (chat) => Column(
                                      children: [
                                        BubbleSpecialOne(
                                          text: chat['message'],
                                          color: const Color(0xFF1B97F3),
                                          isSender: chat['from'] ==
                                                  supabase
                                                      .auth.currentUser?.email
                                              ? true
                                              : false,
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()),
                        );
                      },
                    )
                  : const LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  cursorColor: theme.darkTheme
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  controller: _messageController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async {
                        await supabase.from('chat').insert({
                          'from': supabase.auth.currentUser?.email,
                          'to': widget.email,
                          'message': _messageController.text,
                          'created_at': DateTime.now().toIso8601String(),
                        }).execute();
                        FirebaseFirestore.instance
                            .collection("chat")
                            .doc(supabase.auth.currentUser?.email)
                            .update({
                          'chats': FieldValue.arrayUnion([
                            {
                              'from': supabase.auth.currentUser?.email,
                              'to': widget.email,
                              'message': _messageController.text,
                              'created_at': DateTime.now().toIso8601String(),
                            }
                          ])
                        });
                        getChat();
                        _messageController.clear();
                      },
                      icon: const Icon(FluentIcons.send_24_filled),
                      color: theme.darkTheme
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    hintText: 'Your message',
                    hintStyle: TextStyle(
                      color: theme.darkTheme ? Colors.white : Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                      color: theme.darkTheme ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
