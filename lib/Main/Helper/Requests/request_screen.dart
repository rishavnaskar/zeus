import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/Main/Helper/Chat/chat_screen.dart';
import 'package:zeus/services/constants.dart';
import 'index.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({@required this.email, @required this.docId});

  final String email;
  final String docId;

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String email, docId, name;
  double latitude, longitude;
  List<String> names = [];
  List<String> emails = [];
  List<String> requestAccepted = [];
  bool isResponded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: kBackButton(context),
      ),
      body: Hero(
        tag: 'request',
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Text('Requests made from people nearby',
                    style: TextStyle(
                        color: Color(0xff520935),
                        wordSpacing: 3.0,
                        fontFamily: 'Montserrat',
                        fontSize: 23.0)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 12),
              Flexible(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: emails == null ? 0 : emails.length,
                  itemBuilder: (context, index) {
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        title: Text('${names[index]}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: Icon(requestAccepted.contains(emails[index])
                              ? Icons.check
                              : Icons.remove),
                          color: Color(0xff520935),
                          onPressed: () async {
                            final records = await Firestore.instance
                                .collection('records')
                                .where('email', isEqualTo: emails[index])
                                .getDocuments();

                            if (requestAccepted.contains(emails[index])) {
                              setState(() {
                                requestAccepted.remove(emails[index]);
                                Firestore.instance
                                    .collection('records')
                                    .document('$docId')
                                    .updateData({
                                  'requestAccepted':
                                      FieldValue.arrayRemove([emails[index]]),
                                });
                                for (var record in records.documents) {
                                  record.reference.updateData({
                                    'responseReceived':
                                        FieldValue.arrayRemove([email])
                                  });
                                }
                              });
                            } else if (!requestAccepted
                                .contains(emails[index])) {
                              setState(() {
                                requestAccepted.add(emails[index]);
                                Firestore.instance
                                    .collection('records')
                                    .document('$docId')
                                    .updateData({
                                  'requestAccepted':
                                      FieldValue.arrayUnion([emails[index]]),
                                });
                                for (var record in records.documents) {
                                  record.reference.updateData({
                                    'responseReceived':
                                        FieldValue.arrayUnion([email])
                                  });
                                }
                              });
                            }
                          },
                        ),
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

  @override
  void initState() {
    super.initState();
    email = widget.email;
    docId = widget.docId;
    getData();
  }

  getData() async {
    await Index().getData(email).then((data) =>
        data.forEach((singleData) {
          setState(() {
            switch(data.indexOf(singleData)) {
              case 0:
                emails.addAll(singleData);
                break;
              case 1: names.addAll(singleData);
              break;
              case 2: requestAccepted.addAll(singleData);
            }
          });
        }));
  }
}
