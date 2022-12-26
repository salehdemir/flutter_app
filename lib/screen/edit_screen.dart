import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../screen/user_list_screen.dart';
import '../widget/image_input.dart';

class EditScreen extends StatefulWidget {
  static const routeName = './edit-user';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _pickedImage;
  File? _storedImage;
  var _editUser = User(
    id: '',
    title: '',
    salary: 0,
    age: 0,
    job: '',
    image: File(''),
  );
// later it was bool not var
  var _isInit = true;
  var _isLoading = false;

  String title = '';
  String job = '';
  String age = '';
  String salary = '';

  Map _isInitValue = {
    'title': '',
    'age': 0,
    'salary': 0,
    'job': '',
    'image': '',
    'id': ''
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      if (userId != null) {
        _editUser = Provider.of<Users>(context, listen: false).findById(userId);
        _isInitValue = {
          'id': _editUser.id,
          'title': _editUser.title,
          'salary': _editUser.salary.toString(),
          'job': _editUser.job,
          'age': _editUser.age.toString(),
          'image': _editUser.image
        };
        _storedImage = _editUser.image;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _saveUser() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      setState(() {
        _isLoading = true;
      });
    });
    if (title.isEmpty) {
      return;
    }
    _editUser = User(
        title: title,
        job: job,
        age: int.parse(age),
        salary: double.parse(salary),
        image: _pickedImage == null ? _storedImage! : _pickedImage!,
        id: _isInitValue['id']);

    await Provider.of<Users>(context, listen: false)
        .updateItem(_isInitValue['id'], _editUser);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Edit User Name'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Container(
                    child: AlertDialog(
                      title: Text('Are You Sure?'),
                      content: Text('You want to remove the user'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No')),
                        TextButton(
                            onPressed: () {
                              Provider.of<Users>(context, listen: false)
                                  .removeItem(_editUser.id);
                              // Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserListScreen()),
                              );
                            },
                            child: Text('Yes'))
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.delete),
            )
          ],
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
                            onSaved: (val) {
                              title = val!;
                            },
                            initialValue: _isInitValue['title'],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            maxLength: 15,
                            decoration: InputDecoration(
                              hintText: 'What is your name?',
                              border: OutlineInputBorder(),
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
                            onSaved: (val) {
                              job = val!;
                            },
                            initialValue: _isInitValue['job'],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the job';
                              }
                              return null;
                            },
                            maxLength: 15,
                            decoration: InputDecoration(
                              hintText: 'What is your job?',
                              border: OutlineInputBorder(),
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
                            onSaved: (val) {
                              salary = val!;
                            },
                            initialValue: _isInitValue['salary'],
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Enter number amount';
                              }
                              return null;
                            },
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'How much is your salary?',
                              border: OutlineInputBorder(),
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
                            onSaved: (val) {
                              age = val!;
                            },
                            initialValue: _isInitValue['age'],
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'How old are you?',
                              border: OutlineInputBorder(),
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
