import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'splashScreen.dart';
class Homescreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreen> {
  File pickedImage;
  var imageFile;
  var result = ' ';
  bool isImageLoaded = false;
  Future getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
      result = " ";
    });
  }
  Future getImageFromCamera() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
      result = " ";
    });
  }

  Future labelsread() async {
    result = " ";
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    List labels = await labeler.processImage(myImage);
    for (ImageLabel label in labels) {
      //result = " ";
      final String text = label.text;
      final double confidence = label.confidence;
      if (label.text == 'Plant') {
        setState(() {
          result = 'Plant';
        });
      }
    }
    if (result == 'Plant') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)), //this right here
              child: Container(
                //height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[Container(width:200.0,child: Text("CarbonDioxide level increased to 414 ppm Global Temparature raised by 2 F since 1880",style: TextStyle(fontSize: 19.0,fontFamily: 'SourceSansPro',color: Colors.teal.shade800),),),Container(child: Image(image: AssetImage('images/heat.gif'),height: 65.0,))],),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[Container(width:200.0,child: Text("Releases water from ground each season enough to bath 2271 times.",style: TextStyle(fontSize: 19.0,fontFamily: 'SourceSansPro',color: Colors.teal.shade800),),),Container(child: Image(image: AssetImage('images/bath.gif'),height: 65.0,))],),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[Container(width:200.0,child: Text("Absorb CO2: 450 km of average bike ride, 3832.5 hrs of laptop standby, 30 days of laptop on.",style: TextStyle(fontSize: 19.0,fontFamily: 'SourceSansPro',color: Colors.teal.shade800),),),Container(child: Image(image: AssetImage('images/bike.gif'),height: 65.0,))],),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[Container(width:200.0,child: Text("Direct benefit(excluding medicinal and aesthetic values) are worth upto 69 iPhones, 14 Ducati Scrambler bikes, 2 Audis, 1 dream apartment in mumbai",style: TextStyle(fontSize: 19.0,fontFamily: 'SourceSansPro',color: Colors.teal.shade800),),),Container(child: Image(image: AssetImage('images/money.gif'),height: 65.0,))],),
                      ),
                      SizedBox(
                          width: 320.0,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            child: Text("Close",style: TextStyle(color: Colors.white),),
                            color: const Color(0xFF1BC0C5),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
    else if (result == " ") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 10.0,),
                      Text('Not a tree!',style: TextStyle(fontSize: 23.0,fontFamily: 'SourceSansPro',color: Colors.teal.shade800),),
                      SizedBox(
                          width: 320.0,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("Close",style: TextStyle(color: Colors.white),),
                            ),
                            color: const Color(0xFF1BC0C5),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(193, 66, 66, 0.30),
        elevation: 1.0,
        title: Text('Prakriti'),
        actions: [
          RaisedButton(
            onPressed: getImageFromCamera,
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            color: Colors.transparent,
            elevation: 0.0,
          ),RaisedButton(
            onPressed: getImageFromGallery,
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
            color: Colors.transparent,
            elevation: 0.0,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/back.jpeg'), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            isImageLoaded
                ? Center(
              child: Container(
                height: 300.0,
                width: 300.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(pickedImage),
                        fit: BoxFit.cover)),
              ),
            )
                : Container(),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // child: Text(result),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(193, 66, 66, 0.30),
        elevation: 1.0,
        onPressed: labelsread,
        child: Icon(Icons.check),
      ),
    );
  }
}