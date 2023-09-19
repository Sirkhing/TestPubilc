import 'dart:convert';
import 'package:cart/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cart/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screen/homepage.dart';

class MemberController extends GetxController {
  var users = <Result>[].obs;
  var urll = 'https://typescript-staging.agsdev.workers.dev/Temp';
  var isLoading = false.obs;
  Map<String, dynamic> profile = {}; // Use Map instead of List

// var urll ='http://127.0.0.1:8787/Temp';
  @override

  Future<void> registerMember(Result registrationData) async {

    if (registrationData.username.isEmpty ||
        registrationData.password.isEmpty ||
        registrationData.name.isEmpty ||
        registrationData.lastName.isEmpty ||
        registrationData.phone.isEmpty) {
      Get.snackbar(
        'Registration Failed',
        'Please fill in all required fields.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Exit the method without making the HTTP request
    }

    try {
      final url = Uri.parse('$urll/register');
      final data = registrationData.toJson();
      final response = await http.post(url, body: jsonEncode(data));

      final statusCode = response.statusCode.toString();
      ///======================= Firebase
      ///===============================================
      if (statusCode == "200") {
        try {
          // Create a user with email and password
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: registrationData.username,
            password: registrationData.password,
          );

          // Get the authenticated user
          User? user = userCredential.user;

          if (user != null) {
            // Save additional user data to Firestore
            await FirebaseFirestore.instance.collection('member').doc(registrationData.resultId).set({
              'id': registrationData.id,
              'resultId': registrationData.resultId,
              'username': registrationData.username,
              'password': registrationData.password,
              'name': registrationData.name,
              'lastName': registrationData.lastName,
              'phone': registrationData.phone,
              'status': registrationData.status,
              'shoppingCart': registrationData.shoppingCart,
              // Add more user data fields as needed
            });

            // Registration successful
            print('Registration Successful');
            print(registrationData);
          }
        } catch (e) {
          // Handle registration error
          print('Error during registration: $e');
        }
        print('Registration Successful');
        print(response.body);
        Get.snackbar(
          'Registration Successful',
          'You have been successfully registered!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => loginpage());
      } else if (statusCode == "409") {
        // Username already exists, show an error message
        Get.snackbar(
          'Username Already Exists',
          'The username is already in use. Please choose a different username.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('Registration Failed');
        print(data);
      }
    } catch (error) {
      print('Error during registration: $error');
      Get.snackbar(
        'Registration Failed',
        'An error occurred during registration. Please try again.',
        backgroundColor: Colors.yellow,
        colorText: Colors.white,
      );
    }
  }


  bool isLoggedIn = false; // Track user's login status

  fetchUserData(String userId) async {
    final response = await http.post(Uri.parse('$urll/users/$userId'));
    print("================== $userId");
    print(response.body);

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

    // Assuming your 'Result' data is under the 'data' key in the response
    print(responseData['result']);
    final Map<String, dynamic> userData = responseData;
    print(responseData);
    profile = responseData['result'];
    print(userData);

    update();
    print("++++++++++++++++++");
    return MemberRegistration.fromJson(userData);
  }


  Future<User?> loginAndFetchUserData(String username, String password) async {
    try {

      final loginUrl = Uri.parse('$urll/login');
      final loginData = {
        'username': username,
        'password': password,
      };

      final loginResponse = await http.post(loginUrl, body: jsonEncode(loginData));
      final loginResponseBody = json.decode(loginResponse.body.toString());
      final result = loginResponseBody['result'];
      final statusCode = loginResponseBody['status'].toString();

      print(result);
      print(statusCode);
      print(result["id"]);

      if (statusCode == '200' &&
          result['username'] == username &&
          result['password'] == password) {
        // Firebase Login Check
        try {
          print("----------1--------------");
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: username, password: password);
          User? user = userCredential.user;
          print("-----------2-------------");
          if (user != null) {
            // Firebase login successful
            print("---------3---------------" + result["id"]);
            final userData = await fetchUserData(result['id']);
            print("----------4--------------");
            print('Fetched User Data: ${result["name"]}');
            print("----------5--------------");
            print('Fetched User Data: ${userData?.result}');

            print("-----------6-------------");
            Get.offAll(() => homepage(userData: userData!.result)); // Use Get.offAll
            Get.snackbar(
              'Login Success',
              'Welcome, ${userData!.result.name}!',
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            return user;
          } else {
            print('Firebase login failed');
            Get.snackbar(
              'Login Failed',
              'Firebase login failed',
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          print('Firebase login failed: $e');
          Get.snackbar(
            'Login Failed',
            'Firebase login failed: $e',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Invalid credentials or login error');
        Get.snackbar(
          'Login Failed',
          'Invalid credentials or login error',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Login Failed',
        'DO You have any Account ???',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error during login: $error');

    }

    return null; // Return null if login fails
  }
  Future<void> logout() async {
    try {
      // Clear user data
      Result emptyUser = Result(
        id: '',
        username: '',
        password: '',
        name: '',
        lastName: '',
        phone: '',
        shoppingCart: [],
        resultId: '',
        status: '',
      );

      // Clear shopping cart data


      // Save empty user data and shopping cart


      // Navigate to the login page
      Get.offAll(() => loginpage());

      // Show a Snackbar to indicate successful logout
      Get.snackbar(
        'Logout Successful',
        'You have been successfully logged out!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      // Show an error Snackbar if logout fails

    }
  }
  Future<void> updateProfile(Result updatedUser) async {

    try {
      print(updatedUser.shoppingCart.runtimeType);
      print(updatedUser.shoppingCart);
      isLoading.value = true;
      final Map<String, dynamic> requestData = {
        "id": updatedUser.resultId,
        "username": updatedUser.username,
        "password": updatedUser.password,
        "name": updatedUser.name,
        "lastName": updatedUser.lastName,
        "phone": updatedUser.phone,
        "status": updatedUser.status,
        "shoppingChart ":List<dynamic>.from(updatedUser.shoppingCart.map((x) => x)),
      };

      final String requestBody = json.encode(requestData);

      final response = await http.post(
        Uri.parse('$urll/user/${updatedUser.resultId}/update'),
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      if (response.statusCode == 200) {
        await updateProfileOnFirebase(updatedUser);
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody['result']['data']);

        // Assuming 'fetchUserData' updates the 'user' observable
        await fetchUserData(updatedUser.resultId);


        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back();
        update();

        isLoading.value = false;
      } else {
        isLoading.value = false;
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      isLoading.value = false;
      print(error);
    }
  }

  Future<void> updateProfileOnFirebase(Result updatedUser) async {
    try {
      // Assuming you have a Firebase reference to the user's profile
      final DocumentReference userRef = FirebaseFirestore.instance.collection('member').doc(updatedUser.resultId);

      await userRef.update({
        "username": updatedUser.username,
        "password": updatedUser.password,
        "name": updatedUser.name,
        "lastName": updatedUser.lastName,
        "phone": updatedUser.phone,
        "status": updatedUser.status,
        "shoppingCart": updatedUser.shoppingCart.map((x) => x.toJson()).toList(),
      });

      print('User profile updated on Firebase');
    } catch (error) {
      print('Error updating user profile on Firebase: $error');
    }
  }


}