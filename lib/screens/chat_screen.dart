import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;
dynamic loggedInUser;
dynamic fuck;
dynamic lastMessageSender;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textMessageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    String userId = (_auth.currentUser.uid).toString();
    await _fireStore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot ds) {
      fuck = ds.get('username');
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = fuck;
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapShot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapShot.docs) {
        print(message.data());
      }
    }
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
                messageStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Color.fromARGB(150, 0, 160, 196),
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
                      controller: textMessageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textMessageController.clear();

                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser,
                        'timestamp': Timestamp.now(),
                      });
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
        stream: _fireStore
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final messages = snapshot.data.docs;
          List<MessageBubble> messagesText = [];
          dynamic lastDiffInMinutes = 0;
          dynamic lastUser = '';

          for (var message in messages) {
            final messageText = message.get('text');
            ///////print(fuck);

            // = test.get('username'); //////////////hehehehe
            final messageSender = message.get('sender');
            final currentUser = loggedInUser;

            final timeStamp = message.get('timestamp');
            final timeStampInMilliSeconds = timeStamp.millisecondsSinceEpoch;

            int timeStepInSeconds = (timeStampInMilliSeconds ~/ 1000);

            var now = new DateTime.now();

            var formatTime = new DateFormat('h:mm a');
            var formatDate = new DateFormat('MM/dd/yyyy');
            var formatDay = new DateFormat('d');
            var formatMonth = new DateFormat('M');
            var formatYear = new DateFormat('yyyy');

            var dateAndTime = new DateTime.fromMillisecondsSinceEpoch(
                timeStepInSeconds * 1000);

            var dateAndTimeNow = new DateTime.fromMillisecondsSinceEpoch(
                (Timestamp.now().millisecondsSinceEpoch));

            var diff = dateAndTime.difference(now);
            var time = '';
            var date = '';

            var monthNow = '';
            var dayNow = '';
            var yearNow = '';

            var monthMessageTime = '';
            var dayMessageTime = '';
            var yearMessageTime = '';
            var combineMessages;

            if (diff.inSeconds <= 0 ||
                diff.inSeconds > 0 && diff.inMinutes == 0 ||
                diff.inMinutes > 0 && diff.inHours == 0 ||
                diff.inHours > 0 && diff.inDays == 0) {
              time = formatTime.format(dateAndTime);
              date = formatDate.format(dateAndTime);

              dayNow = formatDay.format(dateAndTimeNow);
              monthNow = formatMonth.format(dateAndTimeNow);
              yearNow = formatYear.format(dateAndTimeNow);

              dayMessageTime = formatDay.format(dateAndTime);
              monthMessageTime = formatMonth.format(dateAndTime);
              yearMessageTime = formatYear.format(dateAndTime);

              //print(dayNow + ' ' + monthNow + ' ' + yearNow);
              //print(dayMessageTime + ' ' + monthMessageTime + ' ' + yearMessageTime);

              if (monthMessageTime == monthNow &&
                  yearMessageTime == yearNow &&
                  dayMessageTime == (int.parse(dayNow) - 1).toString()) {
                time = 'yesterday at ' + time;
              }

              if (diff.inDays <= -1) {
                time = date; //+ ' at ' + time
              }
            }

            if ((diff.inMinutes - lastDiffInMinutes).abs() <= 15 &&
                lastUser == messageSender) {
              combineMessages = true;
            }

            if ((diff.inMinutes - lastDiffInMinutes).abs() <= 15 &&
                lastUser == messageSender) {
              combineMessages = true;
            } else {
              combineMessages = false;
            }
            lastUser = messageSender;
            lastDiffInMinutes = diff.inMinutes;

            //print(diff.inMinutes - lastDiffInMinutes);

            final messageWidget = MessageBubble(
              messageText: messageText,
              messageSender: messageSender,
              isMe: currentUser == messageSender,
              timeStamp: timeStamp,
              time: time,
              combineMessages: combineMessages,
            );
            messagesText.add(messageWidget);
          }
          messagesText = new List.from(messagesText.reversed);

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messagesText,
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.messageText,
    this.messageSender,
    this.isMe,
    this.timeStamp,
    this.time,
    this.combineMessages,
  });

  final String messageText;
  final String messageSender;

  final bool isMe;
  final dynamic timeStamp;
  final dynamic time;
  final dynamic combineMessages;

  @override
  Widget build(BuildContext context) {
    if (combineMessages == false) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 7),
        child: Row(
          children: [
//          CircleAvatar(
//            backgroundColor: Colors.brown.shade800,
//            child: Text('AH'),
//          ),
            GFAvatar(
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hausziege_04.jpg'),
              shape: GFAvatarShape.standard,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      messageSender, //+ ' ' + combineMessages
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        time,
                        style: TextStyle(
                          // fontWeight: FontWeight.w100,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Material(
                  child: Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(0.0),
        child: Row(
          children: [
            SizedBox(
              width: 75,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
