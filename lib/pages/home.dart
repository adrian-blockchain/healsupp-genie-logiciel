import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healsupp/pages/CreateProfil.dart';
import 'package:healsupp/pages/MainPage.dart';

import '../components/BackgroundCurveWidget.dart';
import '../services/CurrentUser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

enum UserState{
  home,
  createAccount,


}

class _HomeState extends State<Home> {

  Future<UserState> connection() async{
    bool connected = await CurrentUser.getUserLoginStatus();

    if(connected){
      return UserState.home;
    }else{
      return UserState.createAccount;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<UserState>(
      future: connection(),
        builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){

          switch(snapshot.requireData){
            case UserState.home:
              return  MainPage();
            case UserState.createAccount:
              return MainPage();

          }
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      }
    );
  }
}

