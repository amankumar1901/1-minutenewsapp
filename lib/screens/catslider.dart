import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/constants/colors.dart';
import '../api/apiconst.dart';
import 'newsscreen.dart';

class CategorySlider extends StatefulWidget {
  const CategorySlider({
    super.key,
    required this.currentUser,
  });

  final UserCredential currentUser;

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  String cat = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.builder(
          itemCount: Constants.catdict.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () {
                  setState(
                    () {
                      cat = Constants.catdict[index]["cat"]
                          .toString()
                          .toLowerCase();
                    },
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(
                        category: cat,
                        source: "null",
                        query: "null",
                        currentUser: widget.currentUser,
                      ),
                    ),
                  );
                },
                child: Material(
                  color: ConstColors.primaryc,
                  child: Column(
                    children: [
                      Image.network(
                        Constants.catdict[index]["thumb"].toString(),
                        height: 140,
                        width: 140,
                      ),
                      FittedBox(
                        child: Text(
                          Constants.catdict[index]["cat"].toString(),
                          style: const TextStyle(
                              fontSize: 22, color: ConstColors.primarytext),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
