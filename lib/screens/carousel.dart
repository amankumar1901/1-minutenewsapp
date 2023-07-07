import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/newsmodel.dart';

class NewsSlider extends StatefulWidget {
  const NewsSlider({
    super.key,
    required this.newsmodel,
    required this.currentUser,
  });
  final NewsModel newsmodel;
  final UserCredential currentUser;

  @override
  State<NewsSlider> createState() => _NewsSliderState();
}

class _NewsSliderState extends State<NewsSlider> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> userFullData = {};
  @override
  void initState() {
    super.initState();
    //fetchInfo();
    users
        .where(
          "email",
          isEqualTo: widget.currentUser.user!.email,
        )
        .get()
        .then(
      (value) {
        //setState(() {
        userFullData = value.docs[0].data() as Map<String, dynamic>;
        //});
        return value;
      },
    );
  }

  void fetchInfo() async {
    await users
        .where(
          "email",
          isEqualTo: widget.currentUser.user!.email,
        )
        .get()
        .then(
      (value) {
        setState(() {
          userFullData = value.docs[0].data() as Map<String, dynamic>;
        });
        return value;
      },
    );
  }

  Future<void> addinfo(Article singlearticle) async {
    await users
        .where(
          "email",
          isEqualTo: widget.currentUser.user!.email,
        )
        .get()
        .then((value) {
      Map<String, dynamic> userData =
          value.docs[0].data() as Map<String, dynamic>;
      List<dynamic> data = userData["userfav"];

      data.removeWhere(
          (element) => element["title"] == singlearticle.title.toString());

      if (!data.contains(singlearticle.title.toString())) {
        data.add({
          "title": singlearticle.title.toString(),
          "newsurl": singlearticle.url.toString(),
        });
      }

      log("Total favourite ${data.length}");
      users.doc(value.docs[0].id).update({
        "userfav": data,
      });
      print(data);
      print("Hello $data");
      fetchInfo();
      return value;
    });
  }

  bool isFavourite(String articletitle) {
    for (var val in userFullData["userfav"]) {
      if (val["title"] == articletitle) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // log(widget.newsmodel.articles.length.toString());
    return ColoredBox(
      color: Colors.black,
      child: CarouselSlider(
        options: CarouselOptions(
          // autoPlay: false,
          enableInfiniteScroll: false,
          scrollDirection: Axis.vertical,

          height: height * 1,
          viewportFraction: 1,
        ),
        items: widget.newsmodel.articles.map(
          (singlearticle) {
            return singlearticle.urlToImage == "null"
                ? const Offstage()
                : Stack(
                    children: [
                      Material(
                        color: ConstColors.primaryc,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.4,
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    "https://www.northampton.ac.uk/wp-content/uploads/2018/11/default-svp_news.jpg",
                                    fit: BoxFit.cover,
                                  );
                                },
                                singlearticle.urlToImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  singlearticle.title,
                                  style: GoogleFonts.ubuntu(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Text(
                                "${singlearticle.description} \n${singlearticle.content}",
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 246, 246, 246),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 10),
                              child: SizedBox(
                                child: Text(
                                  "Source : ${singlearticle.source.name}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () async {
                              await addinfo(singlearticle);
                            },
                            child: isFavourite(singlearticle.title.toString())
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ).toList(),
      ),
    );
  }
}
