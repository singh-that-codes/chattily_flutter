import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationServices{
  static ReceivedAction? initialActioin;
  static Future<void> initializeLocalNotification()async{
    await AwesomeNotifications().initialize(
      null,
      [
      NotificationChannel(
        channelKey: "high_importance_channel", 
        channelName: "Message Channel",
        channelDescription: "Channel of Messaging",
        defaultColor: Colors.transparent,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
    );
    initialAction: await AwesomeNotifications()
    .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    awesomeNotifications.setListeners(
        onActionReceivedMethod: onActionReceivedMethod);
  }


  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if(receivedAction.buttonKeyPressed == "READ"){

    }

  }

  static Future<void> showNotification({required RemoteMessage remoteMessage}) async {
    Random random = Random();
    await AwesomeNotifications().createNotification(content: NotificationContent(
      id: random.nextInt(1000000),
      channelKey: "high_importance_channel",
      largeIcon: remoteMessage.data['photo'],
      title: remoteMessage.data['name'],
      body: remoteMessage.data['text'],
      autoDismissible: true,
      category: NotificationCategory.Message,
      notificationLayout: NotificationLayout.Default,
      backgroundColor: Colors.transparent,
      payload: {
        'user': remoteMessage.data['photo'],
        'name': remoteMessage.data['name'],
        'photo': remoteMessage.data['photo'],
        'email': remoteMessage.data['email'],
      }
    ),
    actionButtons: [
      NotificationActionButton(
        key: "READ",
        label: "read Message",
        color: Colors.green,
        autoDismissible: true,
      )
    ]
    );
  }
}