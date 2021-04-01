import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String title = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Text(title + "Contents"),
    );
  }
}