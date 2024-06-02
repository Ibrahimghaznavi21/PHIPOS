import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pihorizonn/auth_screens/sign_up_screen.dart';
import 'package:pihorizonn/dashboard.dart';
import 'package:pihorizonn/widgets/email_textfield.dart';
import 'package:pihorizonn/widgets/gradient_button.dart';
import 'package:pihorizonn/widgets/password_textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obsecureText = true;
  bool emailValid = false;
  RxBool signInloading = false.obs;
  RxBool signUploading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void signIn() async {
    signInloading.value = true;
    // Sign in with email and password
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Fluttertoast.showToast(msg: 'Sign in Successfully');
      signInloading.value = false;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
      print('Signed in: ${userCredential.user!.email}');
    } catch (e) {
      print('Error signing in: $e');
      Fluttertoast.showToast(msg: 'Sign in failed');
      signInloading.value = false;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.grey.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          child: Text('PHI', style: GoogleFonts.nokora(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 40),),
                        ),
                        Text('POS', style: GoogleFonts.nokora(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 40),),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Email'),
                    SizedBox(height: 10,),
                    EmailTextField(
                      controller: emailController,
                      validator: (value){
                        setState(() {
                          emailValid = !EmailValidator.validate(value!);
                        });
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        else if(!EmailValidator.validate(value)){
                          return 'Invalid Email Address';
                        }
                        return null;
                      },

                      hintText: 'Type your Email',
                      icon: Icon(Icons.person_outline),
                    ),
                    SizedBox(height: 20,),
                    Text('Password'),
                    SizedBox(height: 10,),
                    PasswordTexField(
                      controller: passwordController,
                      hintText: 'Type your Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(obsecureText ? Icons.visibility : Icons.visibility_off),
                      suffixPress: (){
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                      obsecureText: obsecureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){}, child: Text('Forget Password',style: TextStyle(decoration: TextDecoration.underline),)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Obx(()=>
                        ButtonWidget(
                      loading: signInloading.value,
                      onPressed: () {
                        if(_globalKey.currentState!.validate()){
                          signIn();
                        }
                      },
                      text: 'Sign In',
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textStyle: GoogleFonts.aboreto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    ),
                    SizedBox(height: 20,),
                    ButtonWidget(
                      loading: signUploading.value,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                      },
                      text: 'Sign Up',
                      gradient: const LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textStyle: GoogleFonts.aboreto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        User? user = await _signInWithGoogle();
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Sign-In successful: ${user.displayName}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Sign-In failed'),
                          ));
                        }
                      },
                      child: Text('Sign in with Google'),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
