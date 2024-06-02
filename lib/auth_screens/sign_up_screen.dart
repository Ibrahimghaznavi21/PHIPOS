import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pihorizonn/auth_screens/login_screen.dart';
import 'package:pihorizonn/widgets/custom_text_field.dart';
import 'package:pihorizonn/widgets/email_textfield.dart';
import 'package:pihorizonn/widgets/gradient_button.dart';
import 'package:pihorizonn/widgets/password_textField.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool emailValid = false;
  bool obsecureText1 = true;
  bool obsecureText2 = true;
  RxBool signupLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp() async {
    try {
      signupLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      String name = nameController.text.toString();
      String email = emailController.text.toString();
      String phone = phoneController.text.toString();
      String cnic = cnicController.text.toString();
      String password = passwordController.text.toString();
      String confimPassword = confirmPasswordController.text.toString();


      // Save data to Firestore
      await FirebaseFirestore.instance.collection('users')..doc(name).set({
        'name': name,
        'email': email,
        'phone': phone,
        'cnic': cnic,
        'password': password,
        'confirm_password': confimPassword
      });

      Fluttertoast.showToast(msg: 'Register user Successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

      // If sign up is successful, navigate to the home screen or perform any other action
      // For example, you could show a success message using a Snackbar
      signupLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Register user failed');

      // If sign up fails, display an error message to the user
      signupLoading.value = false;
    }

  }

  void _formatCNIC() {
    final text = cnicController.text;
    if (text.length == 5 || text.length == 13) {
      cnicController.value = cnicController.value.copyWith(
        text: '$text-',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
  }

  String? _validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a CNIC';
    }
    // Regular expression for CNIC format: 00000-0000000-0
    if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(value)) {
      return 'Please enter a valid CNIC';
    }
    return null;
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
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50,),
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
                        Text('Name'),
                        SizedBox(height: 10,),
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        SizedBox(height: 10,),
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
                          icon: Icon(Icons.email),
                        ),
                        SizedBox(height: 10,),
                        Text('Phone'),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 5,
                            bottom: 5,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: InternationalPhoneNumberInput(
                            textFieldController: phoneController,
                            onInputChanged: (PhoneNumber number) {},
                            onInputValidated: (bool value) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ), // Changed selectorType to BOTTOM_SHEET
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: const TextStyle(color: Colors.black),
                            initialValue: PhoneNumber(isoCode: 'KW'),
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: const OutlineInputBorder(),
                            onSaved: (PhoneNumber number) {},
                            inputDecoration: InputDecoration(
                              hintText: 'Phone',
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('CNIC'),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: cnicController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: '12345-1234567-1',
                            prefixIcon: Icon(Icons.credit_card),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 0),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(23),
                            ),
                          ),
                          validator: _validateCNIC,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(13),
                            CNICFormatter(),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text('Password'),
                        SizedBox(height: 10,),
                        PasswordTexField(
                          controller: passwordController,
                          hintText: 'Type your Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: Icon(obsecureText1 ? Icons.visibility : Icons.visibility_off),
                          suffixPress: (){
                            setState(() {
                              obsecureText1 = !obsecureText1;
                            });
                          },
                          obsecureText: obsecureText1,
                          validator: (value) {
                            setState(() {
                              passwordController.value.text.length < 7;
                              passwordController.value.text != confirmPasswordController.value.text;
                            });
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                              return 'Password must contain at least one number';
                            }
                            if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              return 'Password must contain at least one special character';
                            }
                            else if(passwordController.value.text.length < 7){
                              {
                                return 'Password must contain at least 8 characters';
                              }
                            }
                            else if(confirmPasswordController.value.text != passwordController.value.text){
                              {
                                return 'Password do not match';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        Text('Confirm Password'),
                        SizedBox(height: 10,),
                        PasswordTexField(
                          controller: confirmPasswordController,
                          hintText: 'Type your Password Again',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: Icon(obsecureText2 ? Icons.visibility : Icons.visibility_off),
                          suffixPress: (){
                            setState(() {
                              obsecureText2 = !obsecureText2;
                            });
                          },
                          obsecureText: obsecureText2,
                          validator: (value) {
                            setState(() {
                              confirmPasswordController.value.text.length < 7;
                              confirmPasswordController.value.text != passwordController.value.text;

                            });
                            if (value == null || value.isEmpty) {
                              return 'Please enter confirm password';
                            }
                            if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                              return 'Password must contain at least one number';
                            }
                            if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
                              return 'Password must contain at least one special character';
                            }
                            else if(confirmPasswordController.value.text.length < 7){
                              {
                                return 'Password must contain at least 8 characters';
                              }
                            }
                            else if(confirmPasswordController.value.text != passwordController.value.text){
                              {
                                return 'Password do not match';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20,),
                        Obx(()=>
                            ButtonWidget(
                          loading: signupLoading.value,
                          onPressed: (){
                            if(_globalKey.currentState!.validate()){
                              signUp();
                            }
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
                        )
                        ),
                      ],
                    ),
                    Positioned(
                        top: 20,
                        left: 7,
                        child: IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            },
                            icon: Icon(Icons.arrow_back,
                            ))),
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

class CNICFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    final text = newValue.text;
    final StringBuffer newText = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      newText.write(text[i]);
      if ((i == 4 || i == 11) && !text.endsWith('-')) {
        newText.write('-');
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}