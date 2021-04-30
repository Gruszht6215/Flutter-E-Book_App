import 'package:cartoon_app_test/utility/my_style.dart';
import 'package:cartoon_app_test/widget/add_new_cartoon.dart';
import 'package:cartoon_app_test/widget/information_login.dart';
import 'package:cartoon_app_test/widget/show_cartoon_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String name, email;
  Widget currentWidget = ShowCartoonList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findNameAndEmail();
  }

  Future<Null> findNameAndEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          name = event.displayName;
          email = event.email;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().darkColor,
      ),
      drawer: buildDrawer(),
      body: currentWidget,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildListTileCartoonList(),
              buildListTileInformation(),
            ],
          ),
          buildSignOut(),
        ],
      ),
    );
  }

  ListTile buildListTileCartoonList() {
    return ListTile(
      leading: Icon(
        Icons.face,
        size: 36,
      ),
      title: Text('Cartoon List'),
      subtitle: Text('Show all cartoon in my stock'),
      onTap: () {
        setState(() {
          currentWidget = ShowCartoonList();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileInformation() {
    return ListTile(
      leading: Icon(
        Icons.info,
        size: 36,
      ),
      title: Text('Information'),
      subtitle: Text('Information User'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: MyStyle().primaryColor,
        // image: DecorationImage(
        //   image: AssetImage('images/wall.jpg'),
        //   fit: BoxFit.cover,
        // ),
      ),
      accountName: Text(name == null ? 'Name' : name),
      accountEmail: Text(email == null ? 'Email' : email),
      currentAccountPicture: Image.asset('images/eye.png'),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/authen', (route) => false));
            });
          },
          tileColor: MyStyle().primaryColor,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: MyStyle().titleH2White('Sign Out'),
          subtitle: MyStyle().titleH3White('Sign Out & Goto Authen'),
        ),
      ],
    );
  }
}
