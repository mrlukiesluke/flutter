import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/mongodb.dart';
import 'package:flutter_application_1/model/user';
import 'package:flutter_application_1/pages/delete_user_page.dart';

import 'package:flutter_application_1/pages/edit_user_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<User>> _futureUsers;
  String searchQuery = '';

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _futureUsers = MongoDatabase.getUsers();
    print('initState user_pro;');
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _futureUsers = MongoDatabase.getUsers();
    });
  }

  void _editUser(User user, int index) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
    );

    if (updatedUser != null && updatedUser is User) {
      // 👇 Update MongoDB
      await MongoDatabase.updateUser(updatedUser);

      // 👇 Refresh UI
      setState(() {
        _futureUsers = MongoDatabase.getUsers();
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      // Update the future to the search results
      if (searchQuery.isEmpty) {
        _futureUsers = MongoDatabase.getUsers();
      } else {
        _futureUsers = MongoDatabase.searchUsers(searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Top Container with Search Box
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(child: userList()),
        ],
      ),
    );
  }

  FutureBuilder<List<User>> userList() {
    return FutureBuilder<List<User>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 60,
                  color: Color.fromARGB(255, 243, 5, 5),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Connection failed.\nPlease check your internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _refreshUsers,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users found."));
        }

        final users = snapshot.data!;

        return RefreshIndicator(
          onRefresh: _refreshUsers,
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Slidable(
                  key: ValueKey(user.email),
                  // 👇 Swipe from right to left
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _editUser(user, index),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DeleteUserPage(selectedUser: user),
                            ),
                          ).then((value) {
                            if (value == true) {
                              _refreshUsers();
                            }
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage('assets/images/id_male.jpg')
                                as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Age: ${user.age}"),
                        Text("Mobile: ${user.contactMobile}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
