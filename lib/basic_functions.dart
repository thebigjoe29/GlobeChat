import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future addChatRoom(String code) async {
  await firestore.collection('chatroom').doc(code).set({
//add code to naviagte to chatpage and show all messages
  });
}

Future addChatToARoom(String code, String text, String sender) async {
  await firestore.collection('chatroom').doc(code).collection('messages').add({
    'text': text,
    'sender': sender,
  });
  return sender;
}

Future signupFunc(String email, String password, String username) async {
 try{ await auth.createUserWithEmailAndPassword(email: email, password: password);
  await firestore.collection('users').add({
    'username': username,
    'email': email,
  });
  return true;
  }
  catch(e){
    print(e);
return false;
  }
}

Future loginFunc(String email, String password) async {
 try{ await auth.signInWithEmailAndPassword(email: email, password: password); return true;}
 catch(e){
  print(e);
  return false;
 }
}










void getText(String code)async{
  var alldocs=await firestore.collection('chatroom').doc(code).collection('messages').get();
 var list=alldocs.docs.map((e) => e.data()['text']).toList();
 print(list);
 

}
void uploadFile() async {
  var result = await FilePicker.platform.pickFiles();

  File file = File(result!.files.single.path!);

  // Generate a unique destination path in Firebase Storage
  String destination =
      'uploads/${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
  try {
    var storageRef = FirebaseStorage.instance.ref().child(destination);
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot taskSnapshot = await uploadTask;

    if (taskSnapshot.state == TaskState.success) {
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print('File uploaded successfully. Download URL: $downloadURL');
    } else {
      // Handle the error case
      print('File upload failed');
    }
  } catch (e) {
    // Handle any exceptions
    print('Error uploading file: $e');
  }
}
