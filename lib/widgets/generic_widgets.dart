import 'package:flutter/material.dart';
import 'package:todopomodoro/style.dart';

class GenericWidgets extends StatelessWidget {
  const GenericWidgets({super.key});

  static Widget appHeader(BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColours.label,
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColours.buttonUnpressed),
                onPressed: () {},
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColours.lightText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.person, color: AppColours.lightText),
                onPressed: () {},
              ),
            ],
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          height: 35,
          decoration: BoxDecoration(
            color: AppColours.label,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(0, 4), // Schatten nach unten
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.italicHeader,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
