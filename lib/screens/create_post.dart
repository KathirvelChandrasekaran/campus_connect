import 'package:campus_connect/utils/constants.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:campus_connect/widgets/rounded_button_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Post"),
          ),
          body: GestureDetector(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _title,
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
                      hintText: 'Enter title',
                      hintStyle: TextStyle(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _title.clear();
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _description,
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
                      hintText: 'Enter description',
                      hintStyle: TextStyle(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _description.clear();
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
                    buttonText: "Create Post",
                    width: MediaQuery.of(context).size.width * 0.90,
                    onpressed: () async {
                      await supabase.from('posts').insert({
                        "created_at": DateTime.now().toIso8601String(),
                        "email_id": supabase.auth.currentUser!.email,
                        "title": _title.text,
                        "content": _description.text,
                      }).execute();
                      Navigator.pop(context);
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.black,
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
