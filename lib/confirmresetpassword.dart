import 'package:chatapp/basic_functions.dart';

import 'package:chatapp/options.dart';
import 'package:chatapp/userlogin.dart';
import 'package:chatapp/usersignup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class confirmReset extends StatefulWidget {
  const confirmReset({super.key});

  @override
  State<confirmReset> createState() => _confirmResetState();
}

class _confirmResetState extends State<confirmReset> {
  TextEditingController codeCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  var isConfirmedReset;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    TextStyle mystyle = TextStyle(
        fontFamily: "myFont", color: Color.fromARGB(255, 129, 128, 128));
    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Color.fromARGB(255, 242, 216, 216),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Hero(
                tag: "yo",
                child: SizedBox(
                  child: Lottie.asset('assets/2.json'),
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50,),
                  Text("Enter the code received in the Email",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              
              SizedBox(
                width: screenwidth * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16), // Adjust the horizontal padding as needed
                  child: TextField(
                    controller: codeCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        // labelText: 'Enter email-id',
                        // labelStyle: mystyle,
                        hintText: "qwerty@domain.com",
                        hintStyle:
                            TextStyle(fontFamily: "myFont", fontSize: 10),
                        filled: true,
                        fillColor: Colors.white
          
                        //labelStyle:
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50,),
                  Text("Enter your new password",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
                ],
              ),
               SizedBox(
                height: 5,
              ),
               SizedBox(
                width: screenwidth * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16), // Adjust the horizontal padding as needed
                  child: TextField(
                    controller: passCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        // labelText: 'Enter email-id',
                        // labelStyle: mystyle,
                        hintText: "qwerty@domain.com",
                        hintStyle:
                            TextStyle(fontFamily: "myFont", fontSize: 10),
                        filled: true,
                        fillColor: Colors.white
          
                        //labelStyle:
                        ),
                  ),
                ),
              ),
               SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: screenwidth * 0.85,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                    if(codeCon.text.isEmpty || passCon.text.isEmpty){
                      ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 300,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Email-Id field cannot be empty",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ));
                    }
                    else{
                     isConfirmedReset=await confirmResetPassword(codeCon.text, passCon.text);
                     if(isConfirmedReset){
                       ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 300,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Password reset successfully!",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ));
                              Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => loginpage(),
          ));
                     }
                     else{
                       ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 300,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Invalid Code/Password",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ));
                     }

                    }
                    },
                    child: isLoading?  SizedBox(
                  child: Lottie.asset('assets/5.json'),
                  width: 50,
                  height: 50,
                ) :Text(
                      "Confirm password reset",
                      style: TextStyle(fontFamily: "myFont", fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        backgroundColor: Color.fromARGB(255, 116, 208, 119)),
                  ),
                ),
             
            ],
          ),
        ),
      ),
    );
  }
}
