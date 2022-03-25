import 'package:campus_connect/services/user_profile_service.dart';
import 'package:campus_connect/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewStudent extends StatefulWidget {
  String? email, name, mobile;
  ViewStudent({Key? key, this.email, this.name, this.mobile}) : super(key: key);

  @override
  _ViewStudentState createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  final UserProfileService _user = UserProfileService();
  dynamic userData;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    var res = _user.getUserProfileByEmail(widget.email.toString());
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
      appBar: AppBar(
        title: const Text(
          "View student",
        ),
      ),
      body: isLoading
          ? const LinearProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Name: ${widget.name}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Email: ${userData[0]['email_id']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Department: ${userData[0]['department']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Roll Number: ${userData[0]['roll_number']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Mobile: ${widget.mobile.toString()}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Center(
                  child: RoundedButtonWidget(
                    buttonText: "Add as friend",
                    width: MediaQuery.of(context).size.width * 0.90,
                    onpressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
