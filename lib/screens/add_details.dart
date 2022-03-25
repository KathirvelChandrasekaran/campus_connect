import 'package:campus_connect/services/user_profile_service.dart';
import 'package:campus_connect/utils/theme.dart';
import 'package:campus_connect/widgets/rounded_button_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_connect/utils/constants.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  insertData() async {
    await supabase.from('profiles').insert({
      'id': supabase.auth.currentUser!.id,
      'username': _nameController.text,
      'user_role': _selectedRole,
      'mobile_number': int.parse(_mobileController.text),
      "avatar_url": "",
      "updated_at": DateTime.now().toIso8601String(),
      "email_id": supabase.auth.currentUser!.email,
    }).execute();
    Navigator.pushNamed(context, '/home');
  }

  String _selectedRole = 'Student';
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
            appBar: AppBar(
              title: const Text('Add Details'),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/AddDetails.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    cursorColor: theme.darkTheme
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FluentIcons.rename_24_filled,
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
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
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: theme.darkTheme ? Colors.white : Colors.grey,
                      ),
                    ),
                    style: TextStyle(
                        color: theme.darkTheme ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    cursorColor: theme.darkTheme
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FluentIcons.phone_add_24_filled,
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
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
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        color: theme.darkTheme ? Colors.white : Colors.grey,
                      ),
                    ),
                    style: TextStyle(
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Please choose your role',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                RadioListTile(
                  value: 'Student',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value.toString();
                    });
                  },
                  title: const Text('Student'),
                ),
                RadioListTile(
                  value: 'Club',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value.toString();
                    });
                  },
                  title: const Text('Club'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RoundedButtonWidget(
                    buttonText: "Add Profile Details",
                    width: MediaQuery.of(context).size.width * 0.80,
                    onpressed: () async {
                      if (_nameController.text.isEmpty ||
                          _mobileController.text.isEmpty) {
                        context.showSnackBar(
                            message: "Please fill all the details");
                      } else {
                        insertData();
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
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
