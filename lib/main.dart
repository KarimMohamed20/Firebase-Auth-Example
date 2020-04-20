import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Firebase Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userImage = '';
  var userDisplayName = '';

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Google Sign In
  Future googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print(user.displayName);
    setState(() {
      userImage = user.photoUrl;
      userDisplayName = user.displayName;
    });
  }

  // Register
  Future emailAndPassword() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
      
    )).user;

    print(user.email);
    email.clear();
    password.clear();
  }

  Future loginEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,

    )).user;
    print(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: email,
              decoration: InputDecoration(hintText: 'Email Address',
              contentPadding: EdgeInsets.all(10)),
            ),

            TextFormField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password",
              contentPadding: EdgeInsets.all(10)),
            ), 
            // Text(
            //   'Firebase Login',
            // ),
            // Text(
            //   '$userDisplayName',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            // userImage == '' ? Container() : Image.network(userImage)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //await googleSignIn();
       //  await emailAndPassword();
       await loginEmailAndPassword();
          print("Done");
        },
        tooltip: 'Google Login',
        child: Icon(Icons.add),
      ),
    );
  }
}
