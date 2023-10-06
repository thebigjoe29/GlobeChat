import 'package:chatapp/basic_functions.dart';
import 'package:chatapp/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class options extends StatefulWidget {
  const options({super.key});

  @override
  State<options> createState() => _optionsState();
}

Future<String> generateUniqueCode() async {
  final random = Random();
  String code;
  while (true) {
    // Generate a random 6-digit code
    code = (100000 + random.nextInt(900000)).toString();

    // Check if the code exists in the database
    final exists = await codeAlreadyExists(code);

    // If the code doesn't exist, return it
    if (!exists) {
      return code;
    }
  }
}

Future<bool> codeAlreadyExists(String code) async {
  final firestoreInstance = FirebaseFirestore.instance;
  final collectionReference = firestoreInstance.collection('chatroom');

  // Check if a document with the code exists
  final existingDocument = await collectionReference.doc(code).get();

  return existingDocument.exists;
}

bool isLoadingcreate = false;
bool isLoadingjoin = false;
var isCreated;
TextEditingController roomName = TextEditingController();

class _optionsState extends State<options> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 216, 216),
        body: Center(
          child: ListView(physics: BouncingScrollPhysics(), children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: "yo",
                  child: SizedBox(
                    child: Lottie.asset('assets/2.json'),
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 320,
                  width: screenwidth * 0.9,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 10, // Blur radius
                          offset: Offset(0, 0), // Offset (x, y)
                        ),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "CREATE A NEW CHAT ROOM",
                            style: TextStyle(
                                fontFamily: "myFont",
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 80,
                            width: 330,
                            child: TextField(
                              controller: roomName,
                              decoration: InputDecoration(
                                
                                border: OutlineInputBorder(),
                                
                                labelText: "Enter a room name:",
                                labelStyle: TextStyle(
                                    fontFamily: "myFont", fontSize: 20),
                                hintText: "eg. StudyRoom",
                                hintStyle: TextStyle(
                                    fontFamily: "myFont", fontSize: 10),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 30,
                                width: 330,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red),
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text(
                                    "Tip: Share the code generated for others to join your chat!",
                                    style: TextStyle(
                                        fontFamily: "myFont",
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          SizedBox(
                            width: screenwidth*0.85,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoadingcreate = !isLoadingcreate;
                                });
                                //  await Future.delayed(Duration(seconds: 1));
                                String uniqueCode = await generateUniqueCode();
                                isCreated = await addChatRoom(
                                    uniqueCode, roomName.text);
                                print(roomName.text);
                                setState(() {
                                  isLoadingcreate = !isLoadingcreate;
                                });
                                isCreated
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        width: 300,
                                        padding: EdgeInsets.all(10),
                                        content: Center(
                                            child: Text(
                                          "Chat room created successfully!",
                                          style:
                                              TextStyle(fontFamily: "myFont"),
                                        )),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        backgroundColor: Colors.black,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(milliseconds: 1500),
                                      ))
                                    : print("error creating room");

                                if (isCreated) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => chatpage(),
                                  ));
                                } else {
                                  //implement wrong chatroomcreation
                                }
                              },
                              child: isLoadingcreate
                                  ? SizedBox(
                                      child: Lottie.asset('assets/5.json'),
                                      width: 50,
                                      height: 50,
                                    )
                                  : Text(
                                      "CREATE ROOM",
                                      style: TextStyle(
                                          fontFamily: "myFont", fontSize: 16),
                                    ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70)),
                                  backgroundColor:
                                      Color.fromARGB(255, 116, 208, 119)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "OR",
                        style: TextStyle(
                            fontFamily: "myFont",
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Container(
                  height: 320,
                  width: screenwidth * 0.9,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 10, // Blur radius
                          offset: Offset(0, 0), // Offset (x, y)
                        ),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "JOIN AN EXISTING CHAT ROOM",
                            style: TextStyle(
                                fontFamily: "myFont",
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
