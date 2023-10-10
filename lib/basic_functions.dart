import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future addChatRoom(String code,String roomName) async {
 try{ await firestore.collection('chatroom').doc(code).set({
    'name': roomName,
  });
  return true;
  }
  catch(e){
    print(e);
    return false;
  }
}
Future confirmResetPassword(String code,String password)async{
  try{
    await auth.confirmPasswordReset(code: code, newPassword: password);
    return true;
  }
  catch(e){
    print(e);
    return false;
  }
}
Future logoutUser()async{
  try{
    await auth.signOut();
    return true;
  }
  catch(e){
print(e);
return false;
  }
}
Future sendPasswordResetEmail(String email)async{
  try{
    await auth.sendPasswordResetEmail(email: email);
    return true;
  }
  catch(e){
print("ERROR IS: "+e.toString());
return false;
  }
}
Future getUsernameByEmail(String email) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .where('email', isEqualTo: email)
        .limit(1) // Limit the query to 1 result since emails should be unique
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      // 'username' is the field name in the document that stores the username
      return userDoc['username'];
    } else {
      // No user found with the given email
      return null;
    }
  } catch (e) {
    print('Error getting username by email: $e');
    return null;
  }
}
Future doesUserExist(String email) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: 'temporary_password', // Provide a temporary password
    );
    await userCredential.user?.delete(); // Delete the temporary user
    return false; // User does not exist
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
      return true; // User already exists
    }
    return false; // Some other error occurred
  }
}

bool isEmailValid(String email) {
  // Define a regular expression pattern for the specific format
  final emailRegex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  // Use the hasMatch method to check if the email matches the pattern
  return emailRegex.hasMatch(email);
}







Future addChatToARoom(String code, String text, String sender) async {
  await firestore.collection('chatroom').doc(code).collection('messages').add({
    'text': text,
    'sender': sender,
    'email': auth.currentUser?.email,
    'timestamp': FieldValue.serverTimestamp(),
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
    if(e is FirebaseAuthException){
      return e.code;
    }
    print(e);
    

  }
}

Future loginFunc(String email, String password) async {
 try{ await auth.signInWithEmailAndPassword(email: email, password: password); return true;}
 catch(e){
  print(e);
  return false;
 }
}


Future doesRoomExist(String roomCode) async {
  try {
    final roomDocument = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(roomCode) // Assuming 'roomCode' is the document ID
        .get();

    // Check if the room document exists
    if (roomDocument.exists) {
      return true; // Room exists
    } else {
      return false; // Room does not exist
    }
  } catch (e) {
    print('Error checking room existence: $e');
    return false; // Error occurred, consider it as room not existing
  }
}
Future getChatRoomName(String docId) async {
  try {
    var roomDocument = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(docId)
        .get();

    if (roomDocument.exists) {
      var name = roomDocument.data()?['name']; // Get the 'name' field
      return name; // Return the name value (or null if 'name' field doesn't exist)
    } else {
      return null; // Document with the specified docId does not exist
    }
  } catch (e) {
    print('Error getting chat room name: $e');
    return null; // Error occurred, return null
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
