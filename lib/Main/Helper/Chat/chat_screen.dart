import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:zeus/Main/Helper/Home/home_screen.dart';
import 'package:zeus/Main/Helper/Profile/profile_screen.dart';
import 'package:zeus/services/constants.dart';
import 'index.dart';

String newEmail, newReceiverEmail;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.email, this.receiverEmail});

  final String email, receiverEmail;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText, receiverName;
  final messageTextController = TextEditingController();
  final _fireStore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: kBackButton(context),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text(receiverName == null ? '' : receiverName,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 20.0)),
            ),
          ),
          IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            ProfileScreen(email: newReceiverEmail)));
              }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.grey[400],
            Colors.grey[200],
          ],
          begin: Alignment.topCenter,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(height: 1.0, color: Colors.grey[700]),
            ),
            MessagesStream(),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              decoration: kMessageContainerDecoration.copyWith(
                  color: Color(0xff520935)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      enableSuggestions: true,
                      toolbarOptions: ToolbarOptions(
                          copy: true, cut: true, paste: true, selectAll: true),
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Montserrat'),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.white,
                    onPressed: () async{
                      String url = await Index().launchURL();
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': url,
                        'sender': newEmail,
                        'receiver': newReceiverEmail,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        messageTextController.clear();
                        _fireStore.collection('messages').add({
                          'text': messageText,
                          'sender': newEmail,
                          'receiver': newReceiverEmail,
                          'time': FieldValue.serverTimestamp()
                        });
                      },
                      icon: Icon(Icons.send),
                      color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getName() async {
    final records = await Firestore.instance
        .collection('records')
        .where('email', isEqualTo: widget.receiverEmail)
        .getDocuments();
    for (var record in records.documents) {
      if (mounted) {
        setState(() {
          receiverName = record.data['name'];
          loading = true;
          if (record.data['photoUrl'] != null)
            photoUrl = record.data['photoUrl'];
          else
            photoUrl = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    newEmail = widget.email;
    newReceiverEmail = widget.receiverEmail;
    getName();
  }
}

class MessagesStream extends StatelessWidget {
  final _fireStore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff520935),
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageReceiver = message.data['receiver'];

          final currentUser = newEmail;

          if ((messageSender == newEmail ||
                  messageSender == newReceiverEmail) &&
              (messageReceiver == newReceiverEmail ||
                  messageReceiver == newEmail)) {
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          } else {
            continue;
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    String finalText = '';
    if (text.contains('http')) {
      finalText = text.substring(text.indexOf('http'));
    }
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color(0xff520935) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Uri.parse(finalText).isAbsolute
                  ? isMe
                      ? SimpleUrlPreview(
                          url: finalText,
                          textColor: Colors.white,
                          isClosable: false,
                          previewHeight: 150,
                          imageLoaderColor: Colors.white,
                        )
                      : SimpleUrlPreview(
                          url: finalText,
                          textColor: Colors.black,
                          bgColor: Colors.white,
                          isClosable: false,
                          previewHeight: 150,
                          imageLoaderColor: Colors.black,
                        )
                  : Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontWeight:
                              isMe ? FontWeight.normal : FontWeight.w500,
                          fontSize: 15.0),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
