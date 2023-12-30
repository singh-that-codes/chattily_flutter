import 'package:chatify/models/chat_model.dart';
import 'package:chatify/models/message_model.dart';
import 'package:chatify/models/user_model.dart';
import 'package:chatify/utils.dart';
import 'package:chatify/widgets/user_photo.dart';
import 'package:flutter/material.dart';

Widget chatWidget({required ChatModel chat}){
  return StreamBuilder(
    stream: messagesCollection(user: currentUser, chat: chat.user)
    .orderBy('time', descending: true)
    .snapshots(),
    builder:(context, messageSnapshot){
      if(messageSnapshot.hasData) {
        MessageModel lastMessage = MessageModel(
          id: messageSnapshot.data!.docs.first['id'],
          sender: messageSnapshot.data!.docs.first['sender'],
          receiver: messageSnapshot.data!.docs.first['receiver'],
          text: messageSnapshot.data!.docs.first['text'],
          time: messageSnapshot.data!.docs.first['time'].toDate(),
        );
        return StreamBuilder(
          stream: userData(id:chat.user),
          builder: (context, userSnapshot){
            UserModel userModel = UserModel (
              id: userSnapshot.data!['id'],
              name: userSnapshot.data!['name'],
              photo: userSnapshot.data!['photo'],
              email: userSnapshot.data!['email']
            );
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.white,
                  border:Border(
                    bottom: BorderSide(
                      color:Colors.black12,
                    )
                  ),
                ),
              child: ListTile(
                leading:userPhoto(radius: 20, url: userModel.photo),
                title: Text(
                  userModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromARGB(117, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  )
                ),
                subtitle: Row(
                  children:[
                    Expanded(
                      child: Text(
                        lastMessage.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color.fromARGB(117, 0, 0, 0),
                            fontSize: 15
                          )
                        ),
                    ),
                    timeStatus(lastMessage: lastMessage, context:context)
                  ]
                ),
                ),
              )
            );
          },
        );
      }
      return const SizedBox.shrink();
    },
  );
}

timeStatus({required MessageModel lastMessage, required BuildContext context}){
  return Padding(
    padding: const EdgeInsets.only(left:5),
    child: Text(
      formatChatDateTime(dateTime: lastMessage.time, context: context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            const TextStyle(
              color: Colors.black,
              fontSize: 15
              )
            ),
  );
}