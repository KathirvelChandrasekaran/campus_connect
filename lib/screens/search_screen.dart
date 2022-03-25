import 'package:campus_connect/screens/view_student.dart';
import 'package:campus_connect/utils/constants.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:campus_connect/widgets/rounded_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchText = TextEditingController();
  List<dynamic>? students;
  bool isLoading = false;
  bool isDataLoaded = false;

  getSearchResults() async {
    setState(() {
      isDataLoaded = false;
      isLoading = true;
    });

    var result = await supabase
        .from('profiles')
        .select()
        .like('username', '%${_searchText.text}%')
        .execute();

    setState(() {
      students = result.data;
      isDataLoaded = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Search',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _searchText,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: theme.darkTheme
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: theme.darkTheme
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      hintText: 'Enter name',
                      hintStyle: TextStyle(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchText.clear();
                        },
                        icon: const Icon(
                          FluentIcons.text_clear_formatting_24_filled,
                        ),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    style: TextStyle(
                      color: theme.darkTheme
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RoundedButtonWidget(
                    buttonText: "Search",
                    width: MediaQuery.of(context).size.width * 0.90,
                    onpressed: getSearchResults,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                isDataLoaded
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: students!
                                .map(
                                  (student) => Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            student['username'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            student['email_id'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              enableDrag: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 2,
                                              builder: (context) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child:
                                                            RoundedButtonWidget(
                                                          buttonText:
                                                              "View Student",
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.90,
                                                          onpressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ViewStudent(
                                                                    email: student[
                                                                        'email_id'],
                                                                    name: student[
                                                                        'username'],
                                                                    mobile: student[
                                                                            'mobile_number']
                                                                        .toString()),
                                                              ),
                                                            );
                                                          },
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      Center(
                                                        child:
                                                            RoundedButtonWidget(
                                                          buttonText:
                                                              "Add as friend",
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.90,
                                                          onpressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "user_requests")
                                                                .doc(student[
                                                                    'email_id'])
                                                                .set({
                                                              "email_id": student[
                                                                  'email_id'],
                                                              "username": student[
                                                                  'username'],
                                                              "requested_by":
                                                                  supabase
                                                                      .auth
                                                                      .currentUser
                                                                      ?.email,
                                                              "request_type":
                                                                  "friend",
                                                              "request_status":
                                                                  "Pending",
                                                              "request_date":
                                                                  DateTime.now()
                                                                      .toString()
                                                            }).whenComplete(() =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop());
                                                          },
                                                          backgroundColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              color: theme.darkTheme
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
