import 'package:chatify/models/user_model.dart';
import 'package:chatify/utils.dart';
import 'package:chatify/widgets/user_photo.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final bool fromHome;
  final UserModel user;
  const ChatPage({super.key, required this.fromHome, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
                          leading: userPhoto(radius: 20, url: widget.user.photo),
                          title: Text(
                            widget.user.name,
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                          subtitle: Text(
                            widget.user.email,
                            style: TextStyle(color: Colors.black.withOpacity(0.8)),
                          ),
                        ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            chatMessageInput(),
          ],
        )
      ),
    );
  }


Widget chatMessageInput(){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children:[
        Row(
          children:[
            Flexible(
              child:Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextField(
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ),
                      Scrollbar(
                        radius: const Radius.circular(5),
                        child: TextField(
                          controller: textEditingController,
                          maxLines: 10,
                          minLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical:5
                              ),
                              border: InputBorder.none,
                              hintText: "Message",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: deviceWidth(context: context)*0.05
                              ),
                            ),
                            onChanged: (value){
                              setState(() {});
                            }
                          )
                        ),
                    ],
                  )
                ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  ),
                  child: const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.transparent,
                    iconSize: 30,
                  )
              )
            ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 30,
                        )
                      )
                  ))
              ],)
          ),
        )
      ]
      )
  );
}}