import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healsupp/pages/home.dart';
import 'package:healsupp/pages/signIn.dart';
import 'package:healsupp/services/CurrentUser.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


enum ConnectionState{
  connected,
  deconnected,
  blocked

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<ConnectionState> connection() async{
    bool connected = await CurrentUser.getUserLoginStatus();

    if(connected){
      return ConnectionState.connected;
    }else{
      return ConnectionState.deconnected;
    }
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  FutureBuilder<ConnectionState>(
        future: connection(),
        builder: (context, snapshot) {

          if(snapshot.hasData){
            if(snapshot.requireData == ConnectionState.deconnected) {
              return const SignIn();
            }
            if(snapshot.requireData == ConnectionState.connected){
              return const Home();
            }

          }
          return const Center(
            child: CircularProgressIndicator(),
          );


        }
    );
  }
}
