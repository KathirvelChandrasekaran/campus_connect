import 'package:campus_connect/services/user_profile_service.dart';
import 'package:campus_connect/utils/constants.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:campus_connect/widgets/rounded_button_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final UserProfileService _user = UserProfileService();
  List<dynamic>? posts;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    var res = _user.isUserProfileFound(supabase.auth.currentUser!.id);
    res.then((user) {
      if (user == 0) {
        Navigator.pushNamed(context, '/add_details');
      }
    });
    getDetails();
  }

  getDetails() async {
    setState(() {
      isDataLoaded = true;
    });
    var res = await supabase.from('posts').select().execute();
    setState(() {
      posts = res.data;
      isDataLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createPost');
            },
            child: Icon(
              FluentIcons.add_circle_24_filled,
              color: theme.darkTheme ? Colors.black : Colors.white,
            ),
          ),
          body: Container(
            child: isDataLoaded
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: posts!.isEmpty
                        ? const Center(
                            child: Text(
                              "No posts found",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView(
                            children: posts!
                                .map(
                                  (post) => Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: ListTile(
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post['email_id'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                Text(
                                                  post['title'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                Text(
                                                  post['content'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // trailing: Text(
                                          //   post['content'],
                                          //   style: const TextStyle(
                                          //     color: Colors.black,
                                          //     fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                          onTap: () {
                                            if (supabase
                                                    .auth.currentUser!.email ==
                                                post['email_id']) {
                                              showModalBottomSheet(
                                                context: context,
                                                enableDrag: true,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    child: Center(
                                                      child:
                                                          RoundedButtonWidget(
                                                        buttonText:
                                                            "Delete Post",
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.90,
                                                        onpressed: () {
                                                          supabase
                                                              .from('posts')
                                                              .delete()
                                                              .eq('id',
                                                                  post['id'])
                                                              .execute();
                                                          getDetails();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .error,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
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
          ),
        );
      },
    );
  }
}
