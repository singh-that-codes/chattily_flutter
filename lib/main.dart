import 'package:chatify/my_app.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
final api_key="wur3mwmr996x";
final user_token="nrea6gjvy68uzzq88zm29bgvpkqez8fvmkundt2z3qu68qndruks8pmdqughgmuh";
void main ()async{
  WidgetsFlutterBinding.ensureInitialized();

  //streamchat client
  final client = StreamChatClient(
    api_key,
    logLevel:Level.INFO
  );

  //current user
  await client.connectUser(User(id: "tutorial") ,user_token);

  //get channel
  final channel = client.channel("messaging",id:"flutterdevs");

  await channel.watch();


  runApp(MyApp());
}
