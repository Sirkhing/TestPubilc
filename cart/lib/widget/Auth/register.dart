import 'dart:convert';
import 'dart:math';

import 'package:cart/controller/firebase/auth.dart';
import 'package:cart/screen/login.dart';
import 'package:cart/widget/Auth/widgetforuse.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/usercontroller.dart';
import '../../model/user.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final MemberController memberController = Get.find();
  final firebasecontroller fire = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameErrorController = TextEditingController();
  final TextEditingController passwordErrorController = TextEditingController();
  final TextEditingController nameErrorController = TextEditingController();
  final TextEditingController lastNameErrorController = TextEditingController();
  final TextEditingController phoneErrorController = TextEditingController();
  Future<void>? _registrationFuture;
  bool _isRegistering = false;
  Future<void> _registerUser() async {
    setState(() {
      // Set _isRegistering to true when registration begins
      _isRegistering = true;
    });

    // Show loading widget while registering
    final registrationData = Result(
      username: usernameController.text,
      password: passwordController.text,
      name: nameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      shoppingCart: [],
      id: generateRandomString(16),
      resultId: generateRandomString(16),
      status: "user", // Setting the status to 'user' here
    );

    try {
      await memberController.registerMember(registrationData);
      usernameController.clear();
      passwordController.clear();
      nameController.clear();
      lastNameController.clear();
      phoneController.clear();

      // Registration successful, navigate to another page
    } catch (error) {
      // Handle registration error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text(
              'An error occurred during registration. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        // Set _isRegistering to false when registration completes
        _isRegistering = false;
      });
    }
  }

  String generateRandomString(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<bool> checkInternetConnection() async {
    var urll = 'https://typescript-staging.cpdgr-app0001-pkg.workers.dev/Temp/';
    try {
      final response = await http.get(Uri.parse('$urll/register'));
      print(response.statusCode);
      return response.statusCode == 200;
    } catch (error) {
      print(error);
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode
                .always, // Auto-validate always for instant feedback
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username (Email)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Set error message and text color
                      usernameErrorController.text = 'Username is required';
                      usernameErrorController.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                      return 'Username is required'; // Return an error message
                    } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      // Check if the input is a valid email using regex
                      usernameErrorController.text =
                          'Enter a valid email address';
                      usernameErrorController.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                      return 'Enter a valid email address'; // Return an error message
                    }
                    // Clear error message
                    usernameErrorController.clear();
                    return null; // Return null if the input is valid
                  },
                ),

                SizedBox(height: 16),
                // Add Text widget to display error message
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password (at least 6 characters)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Set error message and text color
                      passwordErrorController.text = 'Password is required';
                      passwordErrorController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: 0),
                      );
                      return 'Password is required'; // Return an error message
                    } else if (value.length < 6) {
                      // Set error message and text color
                      passwordErrorController.text =
                          'Password must be 6 or longer';
                      passwordErrorController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: 0),
                      );
                      return 'Password must be 6 or longer'; // Return an error message
                    }
                    // Clear error message
                    passwordErrorController.clear();

                    // Format the phone number with "+66" and send it to the database
                    // Now you can use formattedPhoneNumber to send to the database

                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 16),
                // Add Text widget to display error message
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Set error message and text color
                      nameErrorController.text = 'First name is required';
                      nameErrorController.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                      return null; // Return null if the input is valid
                    }
                    // Clear error message
                    nameErrorController.clear();
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 16),
                // Add Text widget to display error message
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Set error message and text color
                      lastNameErrorController.text = 'Last name is required';
                      lastNameErrorController.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                      return null; // Return null if the input is valid
                    }
                    // Clear error message
                    lastNameErrorController.clear();
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 16),
                // Add Text widget to display error message
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Set error message and text color
                      phoneErrorController.text = 'Phone number is required';
                      phoneErrorController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: 0),
                      );
                      return 'Phone number is required'; // Return an error message
                    } else if (value.length != 10) {
                      // Set error message and text color
                      phoneErrorController.text =
                          'Phone number must be 10 digits long';
                      phoneErrorController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: 0),
                      );
                      return 'Phone number must be 10 digits long'; // Return an error message
                    } else if (!value.startsWith('0')) {
                      // Check if the phone number starts with '0'
                      phoneErrorController.text =
                          'Phone number must start with 0';
                      phoneErrorController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: 0),
                      );
                      return 'Phone number must start with 0'; // Return an error message
                    }

                    // Clear error message
                    phoneErrorController.clear();

                    // Format the phone number with "+66" and send it to the database
                    String formattedPhoneNumber = '+66${value.substring(1)}';
                    // Now you can use formattedPhoneNumber to send to the database
                    print('Formatted Phone Number: $formattedPhoneNumber');

                    return null; // Return null if the input is valid
                  },
                ),

                SizedBox(height: 16),



              ElevatedButton(
                onPressed: () {
                  // Check if the username contains the "@" symbol
                  if (!usernameController.text.contains('@')) {
                    Get.snackbar(
                      'Invalid Email',
                      'Please enter a valid email address.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return; // Stop registration if the email is invalid
                  }

                  // Check if the password is at least 6 characters long
                  if (passwordController.text.length < 6) {
                    Get.snackbar(
                      'Invalid Password',
                      'Password must be at least 6 characters long.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return; // Stop registration if the password is too short
                  }

                  // Check if the phone number starts with '0'
                  if (!phoneController.text.startsWith('0')) {
                    Get.snackbar(
                      'Invalid Phone Number',
                      'Phone number must start with 0.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return; // Stop registration if the phone number is invalid
                  }

                  // Start registration
                  _registrationFuture = _registerUser();

                  _isRegistering ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LoadingWidget();
                    },
                  ) :null;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (usernameController != '' &&
                          passwordController == '' &&
                          nameController == '' &&
                          lastNameController == '' &&
                          phoneController == '') {
                        return Colors.grey;
                      }
                      return Colors.blue;
                    },
                  ),
                ),
                child: Text('Register'),
              ),


              SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(loginpage());
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
