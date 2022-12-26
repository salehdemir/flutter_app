import 'package:flutter/material.dart';
import '/screen/edit_screen.dart';
import './screen/user_list_screen.dart';
import 'package:provider/provider.dart';
import './screen/add_user_screen.dart';
import './provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersProvider(),
      child: MaterialApp(
        title: 'Add Users',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: UserListScreen(),
        routes: {
          AddUserScreen.routeName: (ctx) => AddUserScreen(),
          EditScreen.routeName: (ctx) => EditScreen(),
        },
      ),
    );
  }
}
