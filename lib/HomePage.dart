import 'dart:convert';
import 'dart:io';

import 'package:api/Content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String headline = "NEWS";
  String error = "";

  String url =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=9b82069707b140f09a6cb1885af4c9a7";

  cat(String cat) {
    url =
        "https://newsapi.org/v2/top-headlines?country=in&category=$cat&apiKey=9b82069707b140f09a6cb1885af4c9a7";
    headline = cat.toUpperCase();
    fetchPost();
  }

  List data;
  Future<String> fetchPost() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        var responce = await http.get(
          Uri.encodeFull(url),
        );

        setState(() {
          var converdata = json.decode(responce.body);
          data = converdata["articles"];
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      error = "1";
    }
  }

  load() {
    return SpinKitFadingCircle(
      color: Colors.blue,
      size: 30,
    );
  }

  errorMsg() {
    return Center(
      child: Container(
        child: Image.asset("images/nowifi.png"),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(headline),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: drawer(),
      ),
      body: (error == "1"
          ? errorMsg()
          : (data == null
              ? load()
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        //contentPadding: EdgeInsets.all(10),
                        leading: Container(
                          width: 100,
                          height: 100,
                          child: data[index]["urlToImage"] == null
                              ? load()
                              : Image.network(data[index]["urlToImage"],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) =>
                                      progress == null ? child : load()),
                        ),
                        title: data[index]["title"] == null
                            ? load()
                            : Text(data[index]["title"]),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Content(data, index, headline)));
                        },
                      ), 
                    );
                  },
              ))
                ),
    );
  }

  drawer() {
    return ListView(
      children: <Widget>[
        ListTile(
          subtitle: Text(
            "Category",
            style: TextStyle(fontSize: 30),
          ),
        ),
        Divider(),
        ListTile(
            title: Text("Business"),
            onTap: () {
              cat("business");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Entertainment"),
            onTap: () {
              cat("entertainment");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("general"),
            onTap: () {
              cat("general");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Sports"),
            onTap: () {
              cat("sports");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Health"),
            onTap: () {
              cat("health");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Science"),
            onTap: () {
              cat("science");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Technology"),
            onTap: () {
              cat("technology");
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
            title: Text("Back"),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
