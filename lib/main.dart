import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihan4/url_api.dart';
import 'details.dart';
import 'newdata.dart';

void main() => runApp(MaterialApp(
      title: "Najwa-20210120050",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getData() async {
    final String urlApi = ApiUrl().url;
    var url = Uri.parse('$urlApi/list.php'); //Api Link
    final response = await http.get(url);
    print(response.body);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("PHP MySQL CRUD"),
        ),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext contex) => NewData(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (ctx, ss) {
          if (ss.hasError) {
            print("error");
          }
          if (ss.hasData) {
            return Items(list: ss.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class Items extends StatelessWidget {
  List list;
  Items({Key? key, required this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (ctx, i) {
          return ListTile(
            leading: const Icon(Icons.text_snippet_outlined),
            title: Text(list[i]['title']), //Key
            subtitle: Text(list[i]['content']), //Key
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Details(list: list, index: i),
            )),
          );
        });
  }
}
