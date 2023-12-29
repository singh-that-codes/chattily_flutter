import 'package:chatify/firebase_options.dart';
import 'package:chatify/home.dart';
import 'package:chatify/services/auth_services.dart';
import 'package:chatify/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage remoteMessage) async {
      await Fluttertoast.showToast(
        msg:"@${remoteMessage.data['name']} : ${remoteMessage.data['text']}",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green
      );
    }
    );
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  )
);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const String homeRoute = '/home';
  @override
  void initState(){
    NotificationServices.startListeningNotificationEvents();
    super.initState();
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName){
    List<Route<dynamic>> pageStack = [];

    pageStack.add(MaterialPageRoute(builder: (_) => const CheckAuthStatus()));

    if(NotificationServices.initialActioin == null){
      pageStack.add(MaterialPageRoute(builder: (_) => Home(receivedAction: null,)));
    }
    return pageStack;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chattily',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white.withOpacity(0.5),
        appBarTheme:AppBarTheme(
          iconTheme:IconThemeData(
            color: Colors.black.withOpacity(0.5),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize:18,
          color:Colors.black,
          fontWeight:FontWeight.w500,
        )
      ),
      ),
      home: const CheckAuthStatus(),
    );
  }
}
class CheckAuthStatus extends StatefulWidget {
  const CheckAuthStatus({Key? key}) : super(key: key);

  @override
  State<CheckAuthStatus> createState() => _CheckAuthStatusState();
}

class _CheckAuthStatusState extends State<CheckAuthStatus> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          // Authenticate user
          AuthServices authServices = AuthServices();
          await authServices.authenticateUser(context:context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Home(receivedAction: null,);
              },
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
