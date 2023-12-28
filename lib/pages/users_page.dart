import 'package:chatify/models/user_model.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/utils.dart';
import 'package:chatify/widgets/user_photo.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Users'),
        ),
        body: StreamBuilder(
          stream: usersData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserModel user = UserModel(
                    id: snapshot.data![index]['id'],
                    name: snapshot.data![index]['name'],
                    photo: snapshot.data![index]['photo'],
                    email: snapshot.data![index]['email'],
                  );

                  return user.id == currentUser
                      ? const SizedBox.shrink()
                      : ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChatPage(fromHome: false,user: user,);
                            }));
                          },
                          leading: userPhoto(radius: 20, url: user.photo),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(color: Colors.black.withOpacity(0.8)),
                          ),
                        );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
