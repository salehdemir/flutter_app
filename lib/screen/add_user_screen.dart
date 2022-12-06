import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_first_test/models/user.dart';
import 'package:flutter_first_test/screen/user_list_screen.dart';
import 'package:provider/provider.dart';
import '../widget/image_input.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = './add-user';

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController = TextEditingController()
    ..addListener(() {
      if (_titleController.text.isEmpty) {
        setState(() {});
      }
    });
  late final TextEditingController _ageController = TextEditingController()
    ..addListener(() {
      if (_ageController.text.isEmpty) {
        setState(() {});
      }
    });
  late final TextEditingController _salaryController = TextEditingController()
    ..addListener(() {
      if (_salaryController.text.isEmpty) {
        setState(() {});
      }
    });
  late final TextEditingController _jobController = TextEditingController()
    ..addListener(() {
      if (_jobController.text.isEmpty) {
        setState(() {});
      }
    });
  File? _savedImage;

  var _isLoading = false;

  void _selectImage(File savedImage) {
    _savedImage = savedImage;
  }

  void _saveUser() async {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_titleController.text.isEmpty ||
        _savedImage == null ||
        _ageController.text.isEmpty ||
        _salaryController.text.isEmpty ||
        _jobController.text.isEmpty) {
      return;
    }
    try {
      await Provider.of<Users>(context, listen: false).addUser(
          _titleController.text,
          _savedImage!,
          _jobController.text,
          int.parse(_ageController.text),
          double.parse(_salaryController.text));
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('An error accured!'),
          content: const Text('SOmething went wrong'),
          actions: [
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageInput(_selectImage),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          maxLength: 15,
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'What is your name?',
                            border: OutlineInputBorder(),
                            suffixIcon: _titleController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _titleController.clear;
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the job';
                            }
                            return null;
                          },
                          maxLength: 15,
                          controller: _jobController,
                          decoration: InputDecoration(
                            hintText: 'What is your job?',
                            border: OutlineInputBorder(),
                            suffixIcon: _jobController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _jobController.clear();
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.task),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Enter number amount';
                            }
                            return null;
                          },
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          controller: _salaryController,
                          decoration: InputDecoration(
                            hintText: 'How much is your salary?',
                            border: OutlineInputBorder(),
                            suffixIcon: _salaryController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _salaryController.clear();
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.money),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          onFieldSubmitted: (value) => _saveUser(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your age';
                            } else if (int.parse(value) < 18) {
                              return 'This is not for kids';
                            } else if (int.parse(value) > 50) {
                              return 'your to old for this app';
                            }
                            return null;
                          },
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          controller: _ageController,
                          decoration: InputDecoration(
                            hintText: 'How old are you?',
                            border: OutlineInputBorder(),
                            suffixIcon: _ageController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _ageController.clear();
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.live_help),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserListScreen(),
                                ));
                              },
                              child: Text(
                                'Ignore',
                                style: TextStyle(color: Colors.black),
                              )),
                          MaterialButton(
                            onPressed: _saveUser,
                            color: Colors.amber,
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
