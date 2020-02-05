import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class Content extends StatelessWidget {
  final List data;
  final int index;
  final headline;

  Content(this.data, this.index, this.headline);
  load() {
    return SpinKitFadingCircle(
      color: Colors.blue,
      size: 30,
    );
  }

  String url;
  _launch() {
    return url = data[index]['url'];
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text(headline),
              centerTitle: true,
              actions: <Widget>[
                GestureDetector(
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(Icons.share)),
                  onTap: () {
                    Share.share(data[index]['url']);
                  },
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                data[index]["urlToImage"] == null
                    ? load()
                    : Image.network(
                        data[index]["urlToImage"],
                        width: double.infinity,
                        height: size.height * 0.3,
                        fit: BoxFit.fill,
                      ),
                Container(
                  height: size.height * 0.175,
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: data[index]["title"] == null
                      ? load()
                      : Text(
                          data[index]["title"],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                ),
                Container(
                  height: size.height * 0.35,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 25),
                  child: data[index]["content"] == null
                      ? load()
                      : Text(
                          data[index]["content"],
                          style: TextStyle(fontSize: 20),
                          textScaleFactor: 1,
                          textAlign: TextAlign.justify,
                        ),
                ),
                GestureDetector(
                  child: Text(
                    "Read More...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  onTap: () {
                    launch(_launch());
                  },
                ),
              ],
            )));
  }
}
