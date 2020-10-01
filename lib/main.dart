import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MaterialApp(
      home: Homescreen(),
    ));

class Homescreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreen> {
  File pickedImage;
  var imageFile;
  var result = ' ';
  bool isImageLoaded = false;
  getImage() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);
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
        if(label.text=='Plant'){
          setState(() {
            result = 'Plant';
          });
        }
    }
    if(result=='Plant') {
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
                      Text('Excluding medical and asthetic values,\n69 iPhones 14Ducati Scrambler bikes\n2 Audis\n1 dream Apartment in Mumbai'),
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
    else if(result==" "){
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
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Not a tree or a water body'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text('Prakriti'),
        actions: [
          RaisedButton(
            onPressed: getImage,
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            color: Colors.green.shade900,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/back.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            isImageLoaded
                ? Center(
                    child: Container(
                      height: 250.0,
                      width: 250.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(pickedImage), fit: BoxFit.cover)
                      ),
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
        backgroundColor: Colors.green.shade900,
        onPressed: labelsread,
        child: Icon(Icons.check),
      ),
    );
  }
}
