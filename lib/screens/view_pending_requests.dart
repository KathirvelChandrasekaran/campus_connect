import 'package:campus_connect/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPendingRequests extends StatefulWidget {
  const ViewPendingRequests({Key? key}) : super(key: key);

  @override
  State<ViewPendingRequests> createState() => _ViewPendingRequestsState();
}

class _ViewPendingRequestsState extends State<ViewPendingRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Pending Requests'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_requests')
            .where('requested_by', isEqualTo: supabase.auth.currentUser?.email)
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
                    subtitle: Text(
                      document.data()['request_date'],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      document.data()['request_status'],
                      style: const TextStyle(
                        color: Colors.black,
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
