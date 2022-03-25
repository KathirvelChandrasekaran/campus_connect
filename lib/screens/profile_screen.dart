import 'package:campus_connect/services/user_profile_service.dart';
import 'package:campus_connect/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _user = UserProfileService();
  dynamic userData;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    var res = _user.getUserProfile(supabase.auth.currentUser!.id);
    res.then((user) {
      setState(() {
        userData = user;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          isLoading
              ? const LinearProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              'Name: ${userData[0]['username'] ?? 'Not set'}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              'User Role: ${userData[0]['user_role'] ?? 'Not set'}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              'Mobile: ${userData[0]['mobile_number'] ?? 'Not set'}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              '${userData[0]['email_id'] ?? 'Not set'}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
