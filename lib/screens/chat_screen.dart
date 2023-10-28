import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
   final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
    //app bar
        appBar: AppBar(
          //removing back button
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        //body
        body:Column(children: [_chatInput()],
        
        )
      ),
    );
  }

  Widget _appBar(){

    return InkWell(
      onTap: ()=> Navigator.pop(context),
      child: Row(children: [
        //back button
        IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.arrow_back,
            color:Colors.black54
            )),
    
    //user profile pic
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.3),
              child: CachedNetworkImage(
            
                width:mq.height*.05,
                height:mq.height*.05,
            
                    imageUrl: widget.user.image,
                   // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(child:Icon(CupertinoIcons.person)),
                 ),
            ),
    
    //for adding some space
        const SizedBox(width: 10),
    
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(widget.user.name,style: const TextStyle(fontSize:16,color: Colors.black87,
            fontWeight: FontWeight.w500
            )),
    
    
    //for adding some space
    const SizedBox(height: 2),
    
            const Text('Last seen not available',
            style: const TextStyle(
              fontSize:13,color: Colors.black54
            //fontWeight: FontWeight.w500
            )),
            
            ],)
      ],),
    );
  } 

  Widget _chatInput(){
    return Row(
      children: [
        Expanded(
          child: Card(
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(children: [
          ///emogi button
               IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color:Colors.blueAccent
                    )),
          
            const Expanded(child: TextField(
          
              decoration: const InputDecoration(hintText: 'Type Something',
              hintStyle: TextStyle(color: Colors.blueAccent),
              border:InputBorder.none),
            )),
          //take image from gallery
                    IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.image,
                    color:Colors.blueAccent
                    )),
          
          //take image from camera
                    IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color:Colors.blueAccent
                    )),
            ],),
          ),
        ),

        //send message button
      ],
    );
  }
}