import 'package:chatify/models/user_model.dart';
import 'package:chatify/pages/users_page.dart';
import 'package:chatify/utils.dart';
import 'package:chatify/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userData(id: currentUser),
      builder: (context, snapshot){
        if(snapshot.hasData){
          UserModel currentUserModeel = UserModel(
                id: snapshot.data?['id'],
                name: snapshot.data?['name'],
                photo: snapshot.data?['photo'],
                email: snapshot.data?['email']);
          return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: userPhoto(radius: 15, url: currentUserModeel.photo),
                  title: const Text("Chattily"),
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context){
                            return const UsersPage();
                          }
                        ),
                      );
                    },
                    child: const Icon(Ionicons.chatbubble)),
              ),
            );
        }
        else{
          return const Center(
            child: CircularProgressIndicator()
          ,);
        }
      }
    );
  }
}