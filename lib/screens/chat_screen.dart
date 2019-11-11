import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;
FirebaseUser _firebaseUser;

class ChatScreen extends StatefulWidget {
  static String name = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _controller = TextEditingController();

  String message;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _firebaseUser = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _controller.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add(
                          {'text': message, 'sender': _firebaseUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.documents;
          List<MessageBox> messageWidget = [];
          for (var m in messages) {
            final mText = m.data['text'];
            final mSender = m.data['sender'];

            final loggedInUser = _firebaseUser.email;

            final msgWidget = MessageBox(
              text: mText,
              sender: mSender,
              isMe: mSender == loggedInUser,
            );
            messageWidget.add(msgWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: messageWidget,
            ),
          );
        } else {
          return Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ],
          ));
        }
      },
    );
  }
}

// ignore: must_be_immutable
class MessageBox extends StatelessWidget {
  final String text, sender;
  final bool isMe;

  const MessageBox({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$sender',
            style: TextStyle(color: Colors.black45, fontSize: 12.0),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(28.0),
                    bottomLeft: Radius.circular(28.0),
                    bottomRight: Radius.circular(28.0))
                : BorderRadius.only(
                    topRight: Radius.circular(28.0),
                    bottomLeft: Radius.circular(28.0),
                    bottomRight: Radius.circular(28.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
