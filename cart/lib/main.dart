
import 'package:cart/controller/firebase/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cart/controller/usercontroller.dart';
import 'package:cart/model/user.dart';
import 'package:cart/screen/login.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controller/Oder.dart';
import 'controller/cartcontroller.dart';
import 'controller/dummy.dart';

import 'model/product.dart';
import 'model/shopingcart.dart';

// class MyHttpOverrides extends HttpOverrides {
//   // @override
//   // HttpClient createHttpClient(SecurityContext? context) {
//   //   return super.createHttpClient(context)
//   //     ..badCertificateCallback =
//   //         (X509Certificate cert, String host, int port) => true;
//   // }
// }

Future<void> main() async {
  // Initialize HTTP overrides if needed
  // HttpOverrides.global = MyHttpOverrides();

  // Ensure Flutter is initialized first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register your GetX controllers and other dependencies
  Get.put(MemberController());
  Get.put(firebasecontroller());
  Get.put(ProductController());
  Get.put(Odercontrolle());
  Get.put(Cartcontroller());
  Get.put(shopingcart(id: 0, name: '', price: 0, imageUrl: '', date: '', description: '', count: 0));
  Get.put(Product(
      id: 0,
      name: '',
      description: '',
      price: 0.0,
      imageUrl: '',
      date: '',
      quantity: 0, index: 0));
  Get.put(Result(
      username: " ",
      password: " ",
      name: "",
      lastName: "",
      phone: "",
      shoppingCart: [],
      id: 0.toString(),
      resultId: '',
      status: ''));

  // Run your Flutter app
  runApp(MyApp());
}


@override
void initState() {
  initState();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: loginpage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final ProductController products = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
