import 'package:chatify/utils.dart';
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
          return SafeArea(
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {},
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