import 'package:cart/widget/Auth/widgetforuse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cartcontroller.dart';
import '../../controller/usercontroller.dart';
import '../../model/shopingcart.dart';
import '../../model/user.dart';
import '../../screen/register.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final MemberController memberController = Get.put(MemberController());
  final Cartcontroller cartController = Get.find<Cartcontroller>();
  Result? user;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize user data here
  }

  Future<void> _login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    setState(() {
      isLoading = true;
    });
    isLoading
        ? showDialog(
      context: context,
      builder: (BuildContext
      context) {
        return LoadingWidget();
      },
    )
        : null;
      await memberController.loginAndFetchUserData(username, password);
    // Load and set the shopping cart data after successful login
      List<shopingcart> shoppingCart = await cartController.loadShoppingCart();
      user?.shoppingCart.assignAll(shoppingCart);
      passwordController.clear();
      usernameController.clear();

      // Navigate to the home page or any other desired screen
      // In this example, we just print a success message


      // Reset loading state
      setState(() {
        isLoading = false;
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {

                  await _login(context);
                },
                child: isLoading ? Text("Checking Data. . . ."):
                     Text('Login'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("If you don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => register()); // Navigate to register page
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
