import 'package:chatapp/basic_functions.dart';
import 'package:chatapp/usersignup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  var isLogin;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    TextStyle mystyle = TextStyle(
        fontFamily: "myFont", color: Color.fromARGB(255, 129, 128, 128));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  Text("Email-Id",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
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
                  SizedBox(width: 50,),
                  Text("Password",style: TextStyle(fontFamily: "myFont",fontWeight: FontWeight.bold),),
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
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontFamily: "myFont",
                           // fontWeight: FontWeight.bold,
                           fontStyle: FontStyle.italic,
                            fontSize: 13),
                      )),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 29,
              ),
              SizedBox(
                width: screenwidth * 0.85,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading=!isLoading;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    isLogin = await loginFunc(emailCon.text, passCon.text);
                     setState(() {
                      isLoading=!isLoading;
                    });
                    isLogin
                        ? ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                              width: 230,
                              padding: EdgeInsets.all(10),
                            content: Center(child: Text("Logged in successfully!",style: TextStyle(fontFamily: "myFont"),)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.black,
                             behavior: SnackBarBehavior.floating,
                             duration: Duration(milliseconds: 1500),
                          ))
                        : print("not logged in");
                        if(isLogin){
                          //navigate to next page
                        }
                        else{
                          //implement error mechanism for login
                        }
                  },
                  child: isLoading?  SizedBox(
                child: Lottie.asset('assets/5.json'),
                width: 50,
                height: 50,
              ) :Text(
                    "LOGIN",
                    style: TextStyle(fontFamily: "myFont", fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(70)),
                      backgroundColor: Color.fromARGB(255, 116, 208, 119)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
  text: TextSpan(
    text: "Don't have an account? ",
    style: TextStyle(color: Colors.black,fontFamily: "myFont",fontSize: 15),
    children: [
      TextSpan(
        text: "Signup",
        style: TextStyle(
          fontWeight: FontWeight.bold,
         // decoration: TextDecoration.underline,
          color: Colors.blue,
          fontFamily: "myFont",
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => signuppage(),
          ));
            
          },
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
