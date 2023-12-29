import 'dart:async';

import 'package:chatify/models/message_model.dart';
import 'package:chatify/models/user_model.dart';
import 'package:chatify/services/chat_services.dart';
import 'package:chatify/utils.dart';
import 'package:chatify/widgets/user_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  ChatServices chatServices = ChatServices();
  List<MessageModel> messages = [];
  Stream<QuerySnapshot>? messageStream;
  StreamSubscription<QuerySnapshot>? messageSubscription;


  Stream<QuerySnapshot> getMessageStream(){
    Stream<QuerySnapshot> stream = messagesCollection(user: currentUser, chat: widget.user.id).
    orderBy('time', descending: false).snapshots();
    return stream;
  }
  @override
  void initState(){
    super.initState();
    messageStream = getMessageStream();
    messageSubscription = messageStream!.listen(
      (snapshot){
        setState((){
          messages=[];
        });
        if(snapshot.docs.isNotEmpty){
          for(var doc in snapshot.docs){
            MessageModel message = MessageModel(id: doc['id'], sender: doc['sender'], receiver: doc['receiver'], text: doc['text'], time: doc['time'].toDate(),
            );
            if(messages.contains(message) == false){
              setState((){
                messages.add(message);
              });
            }
          }
        }
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async {
        if(widget.fromHome){
          Navigator.pop(context);
        }
        else{
          Navigator.pop(context);
          Navigator.pop(context);
        }
        return false;
      },
      child: SafeArea(
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
                child: messages.isEmpty 
                ?Center(child: Text(
                              "No Messages",
                              style: TextStyle(color: Colors.black.withOpacity(0.8)),
                            ),)
                :ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: ((context, index){
                    return messageWidget(message: messages[index]);
                  }
      
                ))
              ),
              chatMessageInput(),
            ],
          )
        ),
      ),
    );
  }

Widget messageWidget({required MessageModel message}){
  return Align(
    alignment: message.sender == currentUser ? Alignment.centerRight : Alignment.centerLeft,
    child:Padding(
      padding: const EdgeInsets.only(
        top: 4,
        left: 8,
        right: 8,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: deviceWidth(context:context)*0.8,
          ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: message.sender == currentUser
          ? Colors.white:Colors.blue
        ),
      child:Padding(
        padding:EdgeInsets.symmetric(
          vertical:5,
          horizontal: 8
        ),
        child: Text(
                message.text,
                style: TextStyle(
                  color: message.sender == currentUser ? Colors.black : Colors.white,
                ),
              ),
            )
      ),
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
                  onTap: (){
                    if(textEditingController.text.trim().isNotEmpty){
                      chatServices.sendTextMessage(receiver:widget.user.id, text: textEditingController.text.trim());
                  setState(){
                    textEditingController.clear();
                  }
                    }
                  },
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