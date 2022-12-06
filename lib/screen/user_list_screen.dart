import 'package:flutter/material.dart';
import 'package:flutter_first_test/screen/edit_screen.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import '../screen/add_user_screen.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<void> _refreshUsers() async {
    await Provider.of<Users>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddUserScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: FutureBuilder(
          future: Provider.of<Users>(context, listen: false).fetchData(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Users>(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No User Added , Please Add some Users',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  builder: (ctx, userData, ch) => userData.users.length <= 0
                      ? ch!
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: userData.users.length,
                          itemBuilder: (ctx, i) => FocusedMenuHolder(
                            blurSize: 2,
                            blurBackgroundColor: Colors.white10,
                            menuWidth: MediaQuery.of(context).size.width * 0.3,
                            onPressed: () {},
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  backgroundColor: Colors.indigo,
                                  trailingIcon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'Edit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        EditScreen.routeName,
                                        arguments: userData.users[i].id);
                                  }),
                              FocusedMenuItem(
                                  backgroundColor: Colors.red,
                                  trailingIcon: Icon(Icons.delete),
                                  title: Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Container(
                                        child: AlertDialog(
                                          title: Text('Are You Sure?'),
                                          content: Text(
                                              'You want to remove the user'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No')),
                                            TextButton(
                                                onPressed: () {
                                                  Provider.of<Users>(context,
                                                          listen: false)
                                                      .removeItem(
                                                          userData.users[i].id);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Yes'))
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 32,
                                          backgroundImage: FileImage(
                                              userData.users[i].image),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            userData.users[i].title,
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            userData.users[i].job,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        trailing: Container(
                                          width: 64,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      userData.users[i].salary
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      userData.users[i].age
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
