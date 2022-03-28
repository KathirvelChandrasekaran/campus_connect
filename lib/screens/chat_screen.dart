import 'package:campus_connect/screens/chat.dart';
import 'package:campus_connect/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? email;
  @override
  void initState() {
    getChats();
    super.initState();
  }

  getChats() async {
    var res = await supabase
        .from('chat')
        .select()
        .eq('to', supabase.auth.currentUser?.email)
        .execute();
    setState(() {
      email = res.data[0]['to'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user_requests")
            // .where('requested_by', isEqualTo: supabase.auth.currentUser?.email)
            .where('email_id', isEqualTo: email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text('No Pending Requests'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final dynamic document = snapshot.data.docs[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: ListTile(
                    title: Text(
                      document.data()['email_id'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      document.data()['request_status'],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          email: document.data()['email_id'],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
