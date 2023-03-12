import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/screens/carousel.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/newsmodel.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    super.key,
    required this.category,
    required this.source,
    required this.query,
    required this.currentUser,
  });
  final String category;
  final String source;
  final String query;
  final UserCredential currentUser;
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Map<dynamic, dynamic> resp = {};
  var newsmodel = NewsModel.empty();

  call() async {
    Map<String, String> head = {
      "Authorization": "b1d7977bf69d4fdeb0023514b3d94606"
    };

    Uri url = Uri();
    if (widget.category != "null") {
      log("widget.category ${widget.category}");
      url = Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=in&category=${widget.category}&pageSize=50");
    } else if (widget.source != "null") {
      url = Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=${widget.source}&pageSize=50");
    } else {
      url = Uri.parse(
          "https://newsapi.org/v2/everything?q=${widget.query}&pageSize=50");
    }

    var response = await http.get(url, headers: head).then(
      (value) {
        log("API body ${value.body}");
        return value;
      },
    );
    newsmodel = NewsModel.fromJson(response.body);
    log(newsmodel.articles.first.url);
    setState(() {
      resp = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.primarytext, //change your color here
        ),
        backgroundColor: ConstColors.primaryc,
        title: const Padding(
          padding: EdgeInsets.only(right: 60),
          child: Center(
            child: Text(
              "News",
              style: TextStyle(color: ConstColors.primarytext),
            ),
          ),
        ),
      ),
      body: NewsSlider(
        newsmodel: newsmodel,
        currentUser: widget.currentUser,
      ),
    );
  }
}
