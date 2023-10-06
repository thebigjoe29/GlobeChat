import 'package:chatapp/basic_functions.dart';
import 'package:chatapp/userlogin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signuppage extends StatefulWidget {
  const signuppage({super.key});

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController usernameCon=TextEditingController();
  var isSignup;
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
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            physics: BouncingScrollPhysics(),
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Column(
                  
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        },icon: Icon(Icons.close,color: Colors.red,size: 40,),),
                         SizedBox(
                      width: 10,
                    ),
                      ],
                    )
                  ],
                ),
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
                  SizedBox(width: 30,),
                  Text("Enter your Email-Id",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(
                width: screenwidth * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16), // Adjust the horizontal padding as needed
                  child: TextField(
                    controller: emailCon,
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
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30,),
                  Text("Create a password",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
                ],
              ),
              
              SizedBox(
                width: screenwidth * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16), // Adjust the horizontal padding as needed
                  child: TextField(
                    controller: passCon,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide.none), // Remove the default border
                        // Placeholder text
                        hintText: "minimum 6 characters",
                        hintStyle: TextStyle(fontFamily: "myFont",fontSize: 10),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
             Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30,),
                  Text("Create a username",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
                ],
              ),
              
              SizedBox(
                //width: screenwidth * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16), // Adjust the horizontal padding as needed
                  child: TextField(
                    controller: usernameCon,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_3, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide.none), // Remove the default border
                        // Placeholder text
                        hintText: "be creative!",
                        hintStyle: TextStyle(fontFamily: "myFont",fontSize: 10),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ),
              
              SizedBox(
                height: 37,
              ),
              UnconstrainedBox(
               
                child: SizedBox(
                   width: screenwidth * 0.85,
                height: 60,
                  child: ElevatedButton(
                    
                    onPressed: () async {
                      setState(() {
                        isLoading=!isLoading;
                      });
                     await Future.delayed(Duration(seconds: 1));
                      isSignup = await signupFunc(emailCon.text, passCon.text,usernameCon.text);
                       setState(() {
                        isLoading=!isLoading;
                      });
                      isSignup
                          ? ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                width: 300,
                                padding: EdgeInsets.all(10),
                              content: Center(child: Text("Signed up successfully! Welcome",style: TextStyle(fontFamily: "myFont"),)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.black,
                               behavior: SnackBarBehavior.floating,
                               duration: Duration(milliseconds: 1500),
                            ))
                          : print("not signed in");

                        if(isSignup){
                           Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => loginpage(),
          ));

                        }
                        else{
                          //implement wrong signup
                        }
                    },
                    child: isLoading?  SizedBox(
                  child: Lottie.asset('assets/5.json'),
                  width: 50,
                  height: 50,
                              ) :Text(
                      "SIGNUP",
                      style: TextStyle(fontFamily: "myFont", fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        backgroundColor: Color.fromARGB(255, 116, 208, 119)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            
      
            ],
          ),
        ),
      ),
    );
  }
}
