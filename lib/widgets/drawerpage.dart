import 'package:flutter/material.dart';
import 'dart:convert';

class DrawerPage extends StatefulWidget {
  final String token;

  DrawerPage({required this.token});

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    getUserInfoFromToken(widget.token);
  }

  void getUserInfoFromToken(String token) {
    Map<String, dynamic> tokenData = json.decode(token);
    userName = tokenData['userName'];
    userEmail = tokenData['userEmail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer Example'),
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("user"),
              accountEmail: Text("user@gmail.com"),
            ),
            ListTile(title: Text('Profil'), leading: Icon(Icons.person)),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
