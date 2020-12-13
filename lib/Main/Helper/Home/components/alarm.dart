import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'index.dart';

class AlarmIndex {
  showAlertDialog(
      BuildContext context, String email, String docId, Timer timer) {
    bool alarm = false, mask = false, sanitizer = false;

    var style = TextStyle(fontFamily: 'Montserrat', color: Colors.black);

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection('records')
              .where('email', isEqualTo: email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            for (var snap in snapshot.data.documents) {
              alarm = snap.data['alarm'];
              mask = snap.data['mask'];
              sanitizer = snap.data['sanitizer'];
            }
            return AlertDialog(
              title: Center(
                  child: Text("Zeus Safety alarm",
                      style: style.copyWith(fontWeight: FontWeight.bold))),
              content: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListBody(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Switch(
                              value: alarm,
                              activeColor: Color(0xff520935),
                              onChanged: (value) {
                                setState(() {
                                  if (alarm) {
                                    alarm = !alarm;
                                    mask = false;
                                    sanitizer = false;
                                    if (timer != null) timer.cancel();
                                  } else {
                                    alarm = !alarm;
                                  }
                                });
                                for (var snap in snapshot.data.documents) {
                                  if (alarm) {
                                    snap.reference.updateData({'alarm': alarm});
                                    if (snap.data['latitude'] == null &&
                                        snap.data['longitude'] == null)
                                      Index().getCurrentLocationAgain(docId);
                                  } else {
                                    snap.reference.updateData({
                                      'alarm': alarm,
                                      'mask': mask,
                                      'sanitizer': sanitizer
                                    });
                                  }
                                }
                              }),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        maskWidget(mask, alarm, snapshot, 'Mask'),
                        maskWidget(sanitizer, alarm, snapshot, 'Sanitizer'),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Center(
                            child: Row(
                          children: [
                            Text(mask && sanitizer && alarm ? 'SAFE' : 'UNSAFE',
                                style: TextStyle(fontSize: 30)),
                            Spacer(),
                            Icon(
                                mask && sanitizer && alarm
                                    ? Icons.check_circle
                                    : Icons.close,
                                color: mask && sanitizer && alarm
                                    ? Colors.green
                                    : Colors.red,
                                size: MediaQuery.of(context).size.width / 6),
                          ],
                        )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                            'Zeus alarm will keep popping this up if you aren\'t wearking a mask and carrying a sanitizer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 12)),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget maskWidget(
      bool isChecked, bool alarm, AsyncSnapshot snapshot, String name) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            Text(name,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Checkbox(
              value: isChecked,
              activeColor: Color(0xff520935),
              onChanged: (value) {
                setState(() {
                  if (alarm) {
                    isChecked = !isChecked;
                  }
                });

                for (var snap in snapshot.data.documents) {
                  name == "Mask"
                      ? snap.reference.updateData({'mask': isChecked})
                      : snap.reference.updateData({'sanitizer': isChecked});
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class AlarmButton extends StatefulWidget {
  AlarmButton(
      {@required this.email, @required this.docId, @required this.alarm});

  final String email;
  final String docId;
  final bool alarm;

  @override
  _AlarmButtonState createState() => _AlarmButtonState();
}

class _AlarmButtonState extends State<AlarmButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Timer timer;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -.1)
          .chain(CurveTween(curve: Curves.elasticIn))
          .animate(_animationController),
      child: IconButton(
        icon: Icon(Icons.notifications_active),
        onPressed: () => AlarmIndex()
            .showAlertDialog(context, widget.email, widget.docId, timer),
        color: Colors.black,
      ),
      alignment: Alignment.center,
    );
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // Timer.periodic(
    //     Duration(seconds: 6),
    //     (timer) => _animationController.isDismissed
    //         ? Index().runAnimation(_animationController)
    //         : _animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
