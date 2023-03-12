import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../api/apiconst.dart';
import '../constants/colors.dart';
import 'newsscreen.dart';

class SourceSlider extends StatefulWidget {
  const SourceSlider({
    super.key,
    required this.currentUser,
  });

  final UserCredential currentUser;

  @override
  State<SourceSlider> createState() => _SourceSliderState();
}

class _SourceSliderState extends State<SourceSlider> {
  String src = "";
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
          itemCount: Constants.sourcedict.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () {
                  setState(() {
                    src = Constants.sourcedict[index]["id"].toString();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(
                        category: "null",
                        source: src,
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
                        Constants.sourcedict[index]["pic"].toString(),
                        height: 110,
                        width: 110,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: FittedBox(
                          child: Text(
                            Constants.sourcedict[index]["name"].toString(),
                            style: const TextStyle(
                                fontSize: 22, color: ConstColors.primarytext),
                          ),
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
