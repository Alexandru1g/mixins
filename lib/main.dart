import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'dart:io';
import "package:meta/meta.dart";
import 'dart:convert';

extension Log on Object {
  void log() => devtools.log(toString());
}

extension GetOnUri on Object {
  Future<HttpClientResponse> getUrl(String url) => HttpClient()
      .getUrl(
        Uri.parse(url),
      )
      .then(
        (req) => req.close(),
      );
}

mixin CanMakeGetCall {
  String get url;
  @useResult
  Future<String> getString() => getUrl(
        url,
      ).then(
        (resp) => resp
            .transform(
              utf8.decoder,
            )
            .join(),
      );
}

@immutable
class GetPeople with CanMakeGetCall {
  const GetPeople();
  @override
  String get url => "http://127.0.0.1:5500/apis/people.json";
}

void testIt() async {
  final people = await const GetPeople().getString();
  people.log();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Mixins")),
      ),
    );
  }
}
