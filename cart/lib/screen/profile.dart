import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/usercontroller.dart';
import '../model/user.dart';

class ProfilePage extends StatefulWidget {
  final Result userData;

  ProfilePage({required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final MemberController usercontroller = Get.find<MemberController>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  Future<bool> fetchData() async {
    await usercontroller.fetchUserData(widget.userData.resultId);
    return true;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the user's data
    _usernameController = TextEditingController(text: widget.userData.username);
    _passwordController = TextEditingController(text: widget.userData.password);
    _nameController = TextEditingController(text: widget.userData.name);
    _lastNameController =
        TextEditingController(text: widget.userData.lastName);
    _phoneController = TextEditingController(text: widget.userData.phone);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose the text controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),

      ),
      body: FutureBuilder<bool>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a circular loading indicator while fetching data
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle error case
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else {
            // Data has been fetched, show the form
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... Other elements

                      Text('Username'),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: '${usercontroller.profile['username']}',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '${usercontroller.profile['password']}',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Name'),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '${usercontroller.profile['name']}',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Lastname'),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: '${usercontroller.profile['lastName']}',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Phone'),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: '${usercontroller.profile['phone']}',
                        ),
                      ),

                      SizedBox(height: 20),
                      Center(
                        child:ElevatedButton(
                          onPressed: () async {
                            // Create a copy of the user with updated values
                            Result updatedUser = Result(
                              id: widget.userData.resultId,
                              username: _usernameController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              shoppingCart: widget.userData.shoppingCart.toList(),
                              resultId: widget.userData.resultId,
                              status: widget.userData.status,
                            );

                            // Update the shoppingCart property of the user object with the modified list
                            print(updatedUser.shoppingCart);
                            print(widget.userData.status);

                            // Call the updateProfile function
                            await usercontroller.updateProfile(updatedUser);

                            // Show a dialog with a logout message and automatically log out after 5 seconds
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Profile Updated'),
                                  content: Text('You need to log out. Logging out in 5 seconds...'),
                                );
                              },
                            );

                            // Log out after 5 seconds
                            Timer(Duration(seconds: 5), () {
                             usercontroller.logout();
                            });
                          },
                          child: Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
