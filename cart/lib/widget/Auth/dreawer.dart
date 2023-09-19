import 'package:cart/screen/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/usercontroller.dart';
import '../../model/user.dart';

class AppDrawer extends StatefulWidget {
  final Result userData;

  AppDrawer({
    required this.userData,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}


class _AppDrawerState extends State<AppDrawer> {
  final MemberController userController = Get.find<MemberController>();
  bool Isloading =false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color:  Colors.red ,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv6VwM648bpzlLW1Fm5fVi7JtiwIuFHu7GgvkBo_kPfQ&s',
                    ),
                    radius: 50,
                  ),
                  Obx(
                        () {
                      if (userController.isLoading.value) {
                        // Display a loading indicator while data is being fetched
                        return SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Text('Status: ${userController.profile["status"]}'),
                            Text('Name: ${userController.profile["name"]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ), Text('Lastname: ${userController.profile["lastName"]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            title: Text('Profile'),
            onTap: () async {
              print(userController.profile);

              // Use Navigator.push and await
              final returnedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userData: widget.userData),
                ),
              );

              // Check if returnedData is not null and refresh data
              if (returnedData != null) {
                userController.fetchUserData(widget.userData.resultId);
              }
            },
          ),


          ListTile(
            title: Text('Logout'),
            onTap: () {
              userController.logout();
            },
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }
}
