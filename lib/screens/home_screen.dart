
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/profile_screen.dart';
//import 'package:chatapp/widgets/chat_user_card.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];

  //for storing search items
  final List<ChatUser> _searchList = [];
//for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding the keyboard  when a tap is detected on the screen
      onTap:()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        ///if search is on & back button is pressed then close search
        ///or else close the current screen on back button click
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching ? 
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name, Email, ...' ) ,
                autofocus: true,
                style: TextStyle(fontSize: 16,letterSpacing: 0.5),
                //after search the text update the search list
                onChanged: (val){
                  //search logic
                  _searchList.clear();
          
                  for(var i in _list){
                    if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
          
                },
              
            ) : const Text('We Chat'),
            actions: [
              //search user button
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching 
              ? CupertinoIcons.clear_circled_solid
              : Icons.search)),
              //more button :
              IconButton(onPressed: () {
          
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: APIs.me)));
              }, icon: const Icon(Icons.more_vert))
            ],
          ),
          
          //bottom right corner flaoting button
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                onPressed: () async {
                  await APIs.auth.signOut();
                  await GoogleSignIn().signOut();
                },
                child: const Icon(Icons.add_comment_rounded)),
          ),
          
          //stream builder dynamically add the data
          body: StreamBuilder(
            //from where it will take data
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              //data is loading or have been loading
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
          
                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data =
                      snapshot.data?.docs; // question mark agr data null na ho
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          
                  if(_list.isNotEmpty){
                    return ListView.builder(
                      itemCount: _isSearching ? _searchList.length : _list.length,
          
                      //adding margin frm the top
                      padding: EdgeInsets.only(top: mq.height * .01),
          
                      //bouncing on scrolling
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearching ? _searchList[index] : _list[index]);
          
                       // return Text('Name : ${_list[index]}');
                      });
                  } else {
                    return const Center(child: Text('No Connection Found!', style: TextStyle(fontSize: 20)));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
