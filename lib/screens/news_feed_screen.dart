import 'package:campus_connect/services/user_profile_service.dart';
import 'package:campus_connect/utils/constants.dart';
import 'package:flutter/material.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final UserProfileService _user = UserProfileService();

  @override
  void initState() {
    super.initState();
    var res = _user.isUserProfileFound(supabase.auth.currentUser!.id);
    res.then((user) {
      if (user == 0) {
        Navigator.pushNamed(context, '/add_details');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
      ),
    );
  }
}
