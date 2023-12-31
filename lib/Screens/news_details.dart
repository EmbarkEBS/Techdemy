import 'package:flutter/material.dart';

import 'package:learningapp_flutter/Models/courseslist_model.dart';

import '../Models/courseslist_model.dart';

class NewsDetails extends StatefulWidget {
  final Article article;
  final String title;

  NewsDetails(this.article, this.title);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.network(widget.article.image.toString()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.article.image.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.article.description.toString(),
                      style: TextStyle(fontSize: 19.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.article.name.toString(),
                      style: TextStyle(fontSize: 19.0),
                    ),
                  )
                ],
              ),
              MaterialButton(
                height: 50.0,
                color: Colors.grey,
                child: Text(
                  "For more news",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onPressed: () {
                 /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WebView(widget.article.url)));*/
                },
              )
            ],
          ),
        ));
  }
}