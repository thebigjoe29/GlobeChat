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
var isJoined;
TextEditingController roomName = TextEditingController();
final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
TextEditingController topTextFieldController = TextEditingController();
FocusNode topTextFieldFocusNode = FocusNode();
var chatRoomCode;
 String getConcatenatedValue(List<TextEditingController> controllers) {
    String concatenatedValue = '';
    for (int i = 0; i < controllers.length; i++) {
      concatenatedValue += controllers[i].text;
    }
    return concatenatedValue;
  }

class _optionsState extends State<options> {
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          if (i < controllers.length - 1) {
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          } else {
            String concatenatedValue = '';
            for (int j = 0; j < controllers.length; j++) {
              concatenatedValue += controllers[j].text;
            }
            print('Concatenated Value: $concatenatedValue');
          }
        }
      });
    }
  }

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
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 50,),
                  //  Spacer(flex: 1,),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Hero(
                          tag: "yo",
                          child: SizedBox(
                            child: Lottie.asset('assets/2.json'),
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      logoutUser();
                      Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 380,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Logged out successfully!",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ));
                    
                    }, icon:Icon(Icons.logout,color: Colors.red,size: 30,)),
                
                  ],
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
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
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
                              controller: topTextFieldController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: "Enter a room name:",
                                labelStyle: TextStyle(
                                  fontFamily: "myFont",
                                  fontSize: 15,
                                ),
                                hintText: "eg. StudyRoom",
                                hintStyle: TextStyle(
                                  fontFamily: "myFont",
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Lottie.asset("assets/6.json"),
                                    height: 17,
                                    width: 17,
                                  ),
                                  Text(
                                    "Tip: Share the code generated for others to join your chat!",
                                    style: TextStyle(
                                      fontFamily: "myFont",
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 57,
                          ),
                          SizedBox(
                            width: screenwidth * 0.85,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(topTextFieldController.text.isEmpty){
                                   ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 380,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Chat room name cannot be empty",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ));
                                }
                                else{
                                setState(() {
                                  isLoadingcreate = !isLoadingcreate;
                                });
                                String uniqueCode = await generateUniqueCode();
                                chatRoomCode=uniqueCode;
                                isCreated = await addChatRoom(
                                    uniqueCode, topTextFieldController.text);
                                print(topTextFieldController.text);
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
                                            style: TextStyle(
                                              fontFamily: "myFont",
                                            ),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Colors.black,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        duration:
                                            Duration(milliseconds: 1500),
                                      ))
                                    : print("error creating room");

                                if (isCreated) {
                                  isJoined=false;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => chatpage(isCreated:isCreated,chatRoomCode: chatRoomCode,),
                                    ),
                                  );
                                } else {
                                  //implement wrong chatroomcreation
                                }
                              }},
                              child: isLoadingcreate
                                  ? SizedBox(
                                      child: Lottie.asset('assets/5.json'),
                                      width: 50,
                                      height: 50,
                                    )
                                  : Text(
                                      "CREATE ROOM",
                                      style: TextStyle(
                                        fontFamily: "myFont",
                                        fontSize: 16,
                                      ),
                                    ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 116, 208, 119),
                              ),
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
                        color: const Color.fromARGB(255, 44, 43, 43),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 320,
                  width: screenwidth * 0.9,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Enter a valid room code: ",
                            style: TextStyle(
                              fontFamily: "myFont",
                              
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: TextField(
                                    controller: controllers[index],
                                    focusNode: focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 19,
                                        vertical: 15,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(
                            height: 47,
                          ),
                            SizedBox(
                            width: screenwidth * 0.85,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: () async {
                                
                                setState(() {
                                  isLoadingjoin = !isLoadingjoin;
                                });
                               chatRoomCode=getConcatenatedValue(controllers);
                              isJoined=await doesRoomExist(chatRoomCode);
                                setState(() {
                                  isLoadingjoin = !isLoadingjoin;
                                });
                                isJoined
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        width: 300,
                                        padding: EdgeInsets.all(10),
                                        content: Center(
                                          child: Text(
                                            "Room joined successfully!",
                                            style: TextStyle(
                                              fontFamily: "myFont",
                                            ),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Colors.black,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        duration:
                                            Duration(milliseconds: 1500),
                                      ))
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        width: 300,
                                        padding: EdgeInsets.all(10),
                                        content: Center(
                                          child: Text(
                                            "Please enter a valid room code",
                                            style: TextStyle(
                                              fontFamily: "myFont",
                                            ),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Colors.black,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        duration:
                                            Duration(milliseconds: 1500),
                                      ));
                                if (isJoined) {
                                  isCreated=false;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => chatpage(isCreated: isCreated,chatRoomCode: chatRoomCode,),
                                    ),
                                  );
                                } else {
                                  //implement wrong cjoining
                                }
                              },
                              child: isLoadingjoin
                                  ? SizedBox(
                                      child: Lottie.asset('assets/5.json'),
                                      width: 50,
                                      height: 50,
                                    )
                                  : Text(
                                      "JOIN ROOM",
                                      style: TextStyle(
                                        fontFamily: "myFont",
                                        fontSize: 16,
                                      ),
                                    ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 116, 208, 119),
                              ),
                            ),
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
