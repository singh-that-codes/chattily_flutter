import 'package:chatify/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices{

  sentTextMessage({required String receiver, required String text}){
//-----------Sender---------------------
    DocumentReference chatDocRef = 
     chatsCollection(user: currentUser).doc(receiver);
      chatDocRef.set(
        {
          'id': chatDocRef.id,
        }
    );
//----------Receiver---------------
   DocumentReference receiverChatDocRef =
      chatsCollection(user: receiver).doc(currentUser);
        receiverChatDocRef.set({
          'id': chatDocRef.id,
        }
      );

    DocumentReference messageDocref =
     messagesCollection(user: currentUser, chat: receiver).doc();

    messageDocref.set(
    {
      'id':messageDocref.id,
      'text': text,
      'sender': currentUser,
      'receiver':DateTime.now(),
      'sent': false
    }
  );

  }
}