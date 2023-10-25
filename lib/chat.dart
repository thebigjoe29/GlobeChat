import 'package:chatapp/basic_functions.dart';
import 'package:chatapp/options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class chatpage extends StatefulWidget {
  final bool isCreated;
  final String chatRoomCode;

  const chatpage(
      {Key? key, required this.isCreated, required this.chatRoomCode})
      : super(key: key);

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  @override
  late Future roomNameFuture;
  void initState() {
    super.initState();
    loggedInUserEmail = auth.currentUser?.email;

    roomNameFuture = getChatRoomName(widget.chatRoomCode);
  }

  Future timeDelay() async {
    await Future.delayed(Duration(seconds: 1));
  }

  //String message = "hi";
  FirebaseFirestore instance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController message = TextEditingController();
  var loggedInUserEmail;
  var isMe;
  var loggedInUserUsername;
  var radius = Radius.circular(30);

  var roomName;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 216, 216),
        appBar: AppBar(
          backgroundColor: Colors.red.withOpacity(0.5),
          // automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context:
                        context, // Make sure you have access to the context
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          // constraints: BoxConstraints(maxHeight: 300),
                          child: CupertinoActionSheet(
                            title: Text("Select Language"),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text("English"),
                                onPressed: () {
                                  // Handle the first option
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text('Spanish'),
                                onPressed: () {
                                  // Handle the second option
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text('French'),
                                onPressed: () {
                                  // Handle the second option
                                  Navigator.of(context).pop();
                                },
                              ),
                              // Add more options as needed
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.language,
                  size: 30,
                )),
          ],
          // leading: IconButton(onPressed: (){}, icon: Icon(Icons.logout)),
          toolbarHeight: 80,
          title: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: roomNameFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Text('Error'); // Handle errors here
                    }
                    return Text(
                      snapshot.data!.toUpperCase(),
                      style: TextStyle(
                          fontFamily: "myFont",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ); // Display the room name
                  },
                ),
                Text(
                  "Room code: " + widget.chatRoomCode.toString(),
                  style: TextStyle(fontFamily: "myFont", fontSize: 12),
                )
              ],
            ),
          ),
        ), // Replace with your chat room name

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(widget
                        .chatRoomCode) // Use chatRoomCode as the document ID
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (snapshot.hasError) {
                  //   return Text('Error: ${snapshot.error}');
                  // }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // timeDelay();
                    return SizedBox(
                      child: Center(child: Lottie.asset('assets/1.json')),
                      width: 200,
                      height: 200,
                    );
                  }

                  // Extract and display messages here
                  final messages = snapshot.data!.docs.toList();
                  String previousSender = "";
                  bool shouldShowSender = true;
                  DateTime previoustime = DateTime.now();
                  return ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                          messages[index].data() as Map<String, dynamic>;
                      final sender = messageData['sender'];
                      
                      final text = messageData['text'];
                      
                      final email = messageData['email'];
                      
                      final timestamp = messageData['timestamp'];
                      print(timestamp);

                      if (timestamp != null && timestamp is Timestamp) {
                       
                        final timestampDateTime =
                            (timestamp as Timestamp).toDate();

                        if (previousSender != sender ||
                            timestampDateTime
                                    .difference(previoustime)
                                    .inMinutes >
                                1) {
                          shouldShowSender = true;
                        } else {
                          shouldShowSender = false;
                        }

                        previoustime = timestampDateTime;
                      } else {
                       print("TIMESTAMP NULL");
                      }

                      previousSender = sender;

                      final isCurrentUserMessage = email == loggedInUserEmail;

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 5, top: 5),
                        child: Align(
                          alignment: isCurrentUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isCurrentUserMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                               Text(
                                      sender, // Display the sender's name
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 108, 107, 107)),
                                    ),
                                   SizedBox(
                                      height: 3,
                                    ),
                              IntrinsicHeight(
                                child: IntrinsicWidth(
                                  child: Container(
                                    //height: 50,
                                    //width: 100,
                                    decoration: BoxDecoration(
                                      color: isCurrentUserMessage
                                          ? Colors.blue
                                          : Colors.green,
                                      borderRadius: isCurrentUserMessage
                                          ? BorderRadius.only(
                                              topLeft: radius,
                                              bottomLeft: radius,
                                              bottomRight: radius)
                                          : BorderRadius.only(
                                              topRight: radius,
                                              bottomLeft: radius,
                                              bottomRight: radius),
                                    ),
                                    child: Center(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: message,
                decoration: InputDecoration(
                    hintText: "Type Something...",
                    suffixIcon: TextButton(
                      onPressed: () async {
                        var messageText = message.text;
                        if (messageText.isNotEmpty) {
                          message.clear();
                          loggedInUserUsername =
                              await getUsernameByEmail(loggedInUserEmail);
                          addChatToARoom(
                              chatRoomCode, messageText, loggedInUserUsername);
                        }
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
