import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/favourite_model.dart';
import 'package:newsapp/screens/catslider.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/screens/login.dart';
import 'package:newsapp/screens/newsscreen.dart';
import 'package:newsapp/screens/sourceslider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({
    super.key,
    required this.currentUser,
  });

  final UserCredential? currentUser;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  String que = "";
  TextEditingController searchctrl = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.primaryc,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => FirebaseAuth.instance.signOut().then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyLogin(),
                  ),
                ),
              ),
          child: const Padding(
            padding: EdgeInsets.only(top: 17, left: 17),
            child: Text(
              "S/O",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: ConstColors.primarytext),
            ),
          ),
        ),
        backgroundColor: ConstColors.navc,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 70),
            child: Text(
              'Discover',
              style: TextStyle(color: Color.fromARGB(255, 71, 228, 118)),
            ),
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsScreen(
                    category: "general",
                    source: "null",
                    query: "null",
                    currentUser: widget.currentUser!,
                  ),
                ),
              );
            },
            child: Row(
              children: const [
                Text(
                  "General",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: ConstColors.primarytext),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Icon(
                    Icons.arrow_forward_sharp,
                    size: 19,
                    color: ConstColors.primarytext,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: searchctrl,
                      decoration: InputDecoration(
                        hintText: "Search any keyword",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.black,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            setState(
                              () {
                                if (searchctrl.text.isEmpty) {
                                  print("Empty");
                                  que = "everything";
                                } else {
                                  que = searchctrl.text.toString();
                                }
                              },
                            );
                            searchctrl.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsScreen(
                                  category: "null",
                                  source: "null",
                                  query: que.toLowerCase(),
                                  currentUser: widget.currentUser!,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Color.fromARGB(255, 71, 228, 118)),
                    ),
                  ),
                  CategorySlider(
                    currentUser: widget.currentUser!,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Sources",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Color.fromARGB(255, 71, 228, 118)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SourceSlider(
                      currentUser: widget.currentUser!,
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 30),
                  //   child: Text(
                  //     "Your Favourites",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 25,
                  //         color: Color.fromARGB(255, 71, 228, 118)),
                  //   ),
                  // ),
                  FavouriteListView(user: widget.currentUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouriteListView extends StatefulWidget {
  const FavouriteListView({super.key, required this.user});
  final UserCredential? user;

  @override
  State<FavouriteListView> createState() => _FavouriteListViewState();
}

class _FavouriteListViewState extends State<FavouriteListView> {
  FavouriteModel? favouriteData;
  @override
  void initState() {
    super.initState();
    fetch_favourite();
  }

  Future<void> fetch_favourite() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: widget.user!.user!.email)
        .get()
        .then((value) {
      var data = value.docs.first;
      Map<String, dynamic> alldata = data.data();
      setState(() {
        favouriteData = favouriteModelFromJson(jsonEncode(alldata));
      });
    });
  }

  Future<void> launchWebUrl(url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } on Exception catch (_, e) {
      throw Exception('Could not launch $url $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
      color: Colors.white,
    );
    TextStyle descriptionStyle = const TextStyle(color: Colors.white);
    return favouriteData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Favourites",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Color.fromARGB(255, 71, 228, 118)),
                        ),
                        IconButton(
                            onPressed: () {
                              fetch_favourite();
                            },
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  ),
                  for (int i = 0; i < favouriteData!.userfav.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: ConstColors.primaryc,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: ListTile(
                          onTap: () {
                            launchWebUrl(favouriteData!.userfav[i].newsurl);
                          },
                          title: Text(
                            favouriteData!.userfav[i].title,
                            style: headingStyle,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          leading: const Icon(
                            Icons.sync_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
  }
}
