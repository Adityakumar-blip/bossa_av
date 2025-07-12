import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bossa/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              child: Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ListTile(
                      leading: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 80,
                      ),
                      title:
                          Text("We care about your privacy and data security."),
                      subtitle: Text(
                          "We require the tracking of the user to enhance the experience of the user. This is used for sending push notifications when entering a geofence. This is will display unique specials.."),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setBool('pop', true);

                            Get.offAndToNamed(Routes.SPLASH);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                                color: Color.fromARGB(123, 244, 67, 54)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => exit(0),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Color.fromARGB(123, 244, 67, 54)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
