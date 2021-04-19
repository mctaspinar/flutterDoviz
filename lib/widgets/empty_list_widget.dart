import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final IconData iconData;
  final String title;

  EmptyListWidget({this.iconData, this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Icon(
            iconData,
            color: Theme.of(context).accentColor,
            size: 64,
          ),
          SizedBox(
            height: 15,
          ),
          Text(title)
        ],
      ),
    );
  }
}
