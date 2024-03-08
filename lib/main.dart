// ignore_for_file: depend_on_referenced_packages

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder_app/service/auth.dart';
import 'map_page.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'medicine_page.dart';

main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'basic_chanel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests'),
    ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medsminder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: AuthPage(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    MedicinePage(),
    HomePage(),
    MapPage(),
  ];

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  late final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.secondaryContainer,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Welcome ${user?.displayName}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: colorScheme.onSecondaryContainer,
              size: 35,
            ),
            onPressed: () {
              signUserOut();
            },
          )
        ],
        leading: Icon(
          Icons.account_circle_rounded,
          size: 35,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: 'Medicine',
            activeIcon: Icon(
              Icons.medication_rounded,
              size: 35,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(
              Icons.home_sharp,
              size: 35,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Map',
              activeIcon: Icon(
                Icons.location_on,
                size: 35,
                color: Colors.white,
              )),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: colorScheme.secondary,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
