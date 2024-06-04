import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KycFailedWidgets extends StatelessWidget {
  String message;
  String imagePath;

  //KycFailedWidgets({required this.message,super.key});

  KycFailedWidgets({Key? key, required this.message,required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 250,
                  width: 250,
                  alignment: Alignment.topCenter,
                  child: Image.asset(imagePath)),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

                        ],
                      ),
            )),
      ),
    );
  }
}
