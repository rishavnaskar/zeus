import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeus/Main/Helper/Home/home_screen.dart';
import 'package:zeus/services/components.dart';
import 'package:zeus/services/constants.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'index.dart';

bool loading = true;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({@required this.email});

  final String email;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Image _image;
  double lat, long;
  bool _hasImage = true, _isSharing, _isMyProfile = false;
  String myEmail, email, phoneNumber, name, address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: kBackButton(context),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.person_outline, color: Colors.black),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.grey[400],
          Colors.grey[200],
        ])),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              FirstSection(
                  hasImage: _hasImage,
                  image: _image,
                  name: name,
                  isMyProfile: _isMyProfile),
              SizedBox(height: MediaQuery.of(context).size.width / 10),
              Container(height: 1.0, color: Colors.grey),
              Expanded(
                  flex: 2,
                  child:
                      SizedBox(height: MediaQuery.of(context).size.width / 13)),
              _isMyProfile
                  ? Row(
                      children: [
                        Text('Share your details?',
                            style: TextStyle(
                                color: Color(0xff520935),
                                letterSpacing: 2.0,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat')),
                        Spacer(),
                        _isSharing == null
                            ? SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    backgroundColor: Color(0xff520935)),
                              )
                            : Switch(
                                value: _isSharing,
                                onChanged: (value) async {
                                  setState(() {
                                    _isSharing = !_isSharing;
                                  });
                                  final records = await Firestore.instance
                                      .collection('records')
                                      .where('email', isEqualTo: widget.email)
                                      .getDocuments();
                                  for (var record in records.documents) {
                                    record.reference
                                        .updateData({'isSharing': _isSharing});
                                  }
                                },
                                activeColor: Color(0xff520935),
                              ),
                      ],
                    )
                  : Text('Contact information',
                      style: TextStyle(
                          color: Color(0xff520935),
                          letterSpacing: 2.0,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
              Expanded(
                  flex: 1,
                  child:
                      SizedBox(height: MediaQuery.of(context).size.width / 15)),
              ProfileDetailsEmail(email: email),
              SizedBox(height: 30.0),
              Visibility(
                  visible: _isMyProfile,
                  child: Expanded(flex: 1, child: SizedBox(height: 20.0))),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 14)),
              Container(height: 1.0, color: Colors.grey),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 25)),
              Row(
                children: [
                  Icon(Icons.home, color: Color(0xff520935), size: 30.0),
                  SizedBox(width: 10.0),
                  Text('Home',
                      style: TextStyle(
                          color: Color(0xff520935),
                          letterSpacing: 2.0,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                ],
              ),
              Expanded(flex: 1, child: SizedBox(height: MediaQuery.of(context).size.height / 40)),
              (lat == null || long == null)
                  ? Text('Protected by user\'s privacy settings',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w500))
                  : address == null
                      ? CircularProgressIndicator()
                      : Text('$address',
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w500,
                          )),
              Expanded(flex: 2, child: SizedBox(height: 10.0)),
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        if (mounted) {
          setState(() {
            myEmail = user.email;
            if (user.photoUrl != null) photoUrl = user.photoUrl;
          });
        }
        final records = await Firestore.instance
            .collection('records')
            .where('email', isEqualTo: widget.email)
            .getDocuments();
        setState(() {
          for (var record in records.documents) {
            setState(() {
              email = record.data['email'];
              if (email == myEmail) _isMyProfile = true;
              if (record.data['isSharing'] == true)
                _isSharing = true;
              else
                _isSharing = false;
              if (_isMyProfile == true ||
                  (_isMyProfile == false && _isSharing == true)) {
                name = record.data['name'];
                if (record.data['latitude'] != null)
                  lat = record.data['latitude'];
                if (record.data['longitude'] != null)
                  long = record.data['longitude'];
                getLocation();
                if (record.data['phone'] != null)
                  phoneNumber = record.data['phone'];
              } else {
                name = record.data['name'];
                phoneNumber = 'Protected by user\'s privacy settings';
              }
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    String res = await Index().getLocation(lat, long);
    setState(() {
      address = res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    if (photoUrl == null) {
      setState(() {
        _hasImage = false;
      });
    } else {
      setState(() {
        _hasImage = true;
      });
      _image = Image.network('$photoUrl');
      _image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            setState(() {
              loading = false;
            });
          },
        ),
      );
    }
  }
}

class ProfileDetailsEmail extends StatelessWidget {
  ProfileDetailsEmail({@required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 5.0,
                  offset: Offset(3.0, 3.0))
            ]),
        child: ListTile(
          enabled: false,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          leading: Icon(Icons.email, color: Color(0xff520935)),
          title: email == null
              ? SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xff520935)))
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('$email',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'))),
        ));
  }
}

class FirstSection extends StatefulWidget {
  FirstSection({this.isMyProfile, this.name, this.image, this.hasImage});

  final bool hasImage;
  final Image image;
  final String name;
  final bool isMyProfile;

  @override
  _FirstSectionState createState() => _FirstSectionState();
}

class _FirstSectionState extends State<FirstSection> {
  File _pickedImage;
  Image image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            !widget.hasImage
                ? CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey[400],
                    child: Center(
                      child: Text('No image',
                          style: TextStyle(
                              color: Color(0xff520935),
                              fontSize: 12.0,
                              fontFamily: 'Montserrat')),
                    ))
                : SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 10,
                    child: loading
                        ? CircleAvatar(
                            child: Icon(Icons.person, color: Colors.black),
                            backgroundColor: Colors.grey[500])
                        : FittedBox(
                            fit: BoxFit.fill, child: ClipOval(child: image))),
            Visibility(
              visible: widget.isMyProfile,
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey[700],
                onPressed: () {
                  getImage(context);
                },
              ),
            ),
            Spacer(),
            Text(widget.name != null ? widget.name : '',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Color(0xff520935),
                    letterSpacing: 2.0)),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  Future getImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedFile.path);
      image = Image.file(_pickedImage);
      uploadImage(context);
    });
  }

  Future uploadImage(BuildContext context) async {
    Components().neverSatisfied('Uploading Image', null, context);

    ///Uploading to Firebase Storage
    //final result = await FirebaseStorage.instance.getReferenceFromUrl(photoUrl);
    //if (result != null) result.delete();
    String fileName = basename(_pickedImage.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(_pickedImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      photoUrl = downloadUrl;
    });

    ///Uploading to FirebaseAuth
    final user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.photoUrl = photoUrl;
    user.updateProfile(userUpdateInfo);

    ///Uploading to Firestore
    final records = await Firestore.instance
        .collection('records')
        .where('email', isEqualTo: user.email)
        .getDocuments();
    if (uploadTask.isComplete && uploadTask.isSuccessful) {
      for (var record in records.documents) {
        record.reference.updateData({'photoUrl': photoUrl}).whenComplete(() {
          Navigator.pop(context);
        });
      }
    } else if (uploadTask.isCanceled) {
      Navigator.pop(context);
      Components().snackBarFunction('Upload Failed');
    }
  }
}
