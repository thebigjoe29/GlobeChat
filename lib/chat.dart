


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'basic_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class chatpage extends StatefulWidget {
  const chatpage({super.key});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  String message="hi";
  FirebaseFirestore instance=FirebaseFirestore.instance;
 FirebaseAuth auth=FirebaseAuth.instance;
 var isMe;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold();
  }
}













// await loginFunc("joemama@gmail.com", "pass123");
//            var currentUser=auth.currentUser?.email;
//            var sender=await addChatToARoom("bro", "wassup", "joemama@gmail.com");
           
//            if(sender==currentUser){
//             isMe=true;
            
//            }
//            else{
//             isMe=false;
//            }
//            print(isMe);



//  await loginFunc("joemama@gmail.com", "pass123");
//            var doc=await instance.collection('users').where('email',isEqualTo: auth.currentUser?.email).limit(1).get();
//            var docdata=doc.docs[0];
//            print(docdata.data()['username']);