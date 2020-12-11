import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/Main/Helper/Chat/chat_screen.dart';

class ResponseScreen extends StatefulWidget {
  ResponseScreen({@required this.email, @required this.docId});
  final String email;
  final String docId;

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  String email, docId;
  List<String> emails = [];
  List<String> names = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Hero(
        tag: 'response',
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Text('People who responded to your help request',
                    style: TextStyle(
                        color: Color(0xff520935),
                        wordSpacing: 3.0,
                        fontFamily: 'Montserrat',
                        fontSize: 23.0)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),

            Flexible(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: emails != null ? emails.length : 0,
                itemBuilder: (context, index) {
                  if (emails == null) {
                    return Center(child: Text('No responses yet'));
                  }

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5.0,
                              color: Colors.grey[400],
                              offset: Offset(5.0, 5.0))
                        ]),
                    child: ListTile(
                      enabled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text('${names[index]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff520935),
                              fontFamily: 'Montserrat',
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold)),
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ChatScreen(
                                  email: email,
                                  receiverEmail: emails[index]))),
                    ),
                  );
                },
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    final record = await Firestore.instance.collection('records').document('$docId').get();
      if (record.data['responseReceived'] != null) {
        for (int i = 0; i < record.data['responseReceived'].length; i++) {
          if (!emails.contains(record.data['responseReceived'][i])) {
            final nameRecords = await Firestore.instance.collection('records').where('email', isEqualTo: record.data['responseReceived'][i]).getDocuments();
            setState(() {
              emails.add(record.data['responseReceived'][i]);
              nameRecords.documents.forEach((element) => names.add(element.data['name']));
            });
          }
        }
      }
  }

  @override
  void initState() {
    super.initState();
    email = widget.email;
    docId = widget.docId;
    getData();
  }
}