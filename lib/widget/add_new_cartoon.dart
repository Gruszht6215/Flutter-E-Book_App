import 'dart:io';
import 'package:cartoon_app_test/utility/my_style.dart';
import 'package:cartoon_app_test/widget/my_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCartoon extends StatefulWidget {
  @override
  _AddNewCartoonState createState() => _AddNewCartoonState();
}

class _AddNewCartoonState extends State<AddNewCartoon> {
  String fileNamePdf = 'Choose Your Cartoon .pdf file';
  final _picker = ImagePicker();
  File fileImage, filePdf;
  String nameCartoon, urlPicture, urlPdf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Cartoon'),
        backgroundColor: MyStyle().darkColor,
      ),
      body: Container(
        child: Stack(children: [
          showContent(),
          uploadButton(),
        ]),
      ),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          showImage(),
          showPicButton(),
          SizedBox(
            height: 20,
          ),
          nameForm(),
          SizedBox(
            height: 20,
          ),
          addFilePdf(fileNamePdf),
        ],
      ),
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: fileImage == null
          ? Image.asset('images/pic.png')
          : Image.file(fileImage),
    );
  }

  Widget showPicButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        galleryButton(),
      ],
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 40,
        color: MyStyle().lightColor,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      PickedFile image = await _picker.getImage(
        source: imageSource,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        fileImage = File(image.path);
      });
    } catch (e) {}
  }

  Widget nameForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (String string) async {
          nameCartoon = string.trim();
        },
        decoration: InputDecoration(
          helperText: 'Type Your Cartoon Title',
          labelText: 'Name Cartoon',
          icon: Icon(
            Icons.account_circle,
            size: 36,
          ),
        ),
      ),
    );
  }

  Widget addFilePdf(String fileName) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [chooseFilePdf(), MyStyle().titleH4(fileName)],
    );
  }

  Widget chooseFilePdf() {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.note_add,
          size: 36,
          color: MyStyle().lightColor,
        ),
        onPressed: () async {
          FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          filePdf = File(result.files.single.path);
          if (result != null) {
            PlatformFile fileDetail = result.files.first;
            fileNamePdf = fileDetail.name;
            setState(() {
              addFilePdf(fileNamePdf);
            });
          } else {
            fileNamePdf = 'Choose Your Cartoon .pdf file';
            setState(() {
              addFilePdf(fileNamePdf);
            });
          }
        },
      ),
    );
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: MyStyle().lightColor,
            onPressed: () {
              if (fileImage == null) {
                showAlert('No Image Picked Yet', 'Please Add Image');
              } else if (nameCartoon == null || nameCartoon.isEmpty) {
                showAlert('Have Space', 'Please Fill Every Blank');
              } else if (fileNamePdf == 'Choose Your Cartoon .pdf file') {
                showAlert(
                    'No Choose .pdf file', 'Please Add Your Cartoon .pdf File');
              } else {
                uploadFileToStorage();
              }
            },
            icon: Icon(Icons.cloud_upload),
            label: Text('Upload Data'),
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<Null> uploadFileToStorage() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Reference reference = firebaseStorage.ref('cover/cover$uniqueFileName');
    UploadTask uploadTask = reference.putFile(fileImage);
    await uploadTask.then((TaskSnapshot taskSnapshot) async{
      await taskSnapshot.ref.getDownloadURL().then((imageUrl) async{
        urlPicture = imageUrl;

      });
    }).catchError((e) {
      print(e);
    });

    reference = firebaseStorage.ref('ebook/ebook$uniqueFileName');
    uploadTask = reference.putFile(filePdf);
    await uploadTask.then((TaskSnapshot taskSnapshot) async{
      await taskSnapshot.ref.getDownloadURL().then((pdfUrl) async{
        urlPdf = pdfUrl;

      });
    }).catchError((e) {
      print(e);
    });

    InsertValueToFireStore();
  }

  Future<Null> InsertValueToFireStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> map = Map();
    map['cover'] = urlPicture;
    map['name'] = nameCartoon;
    map['pdf'] = urlPdf;


    await firestore.collection('cartoon').doc().set(map).then((value) {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (value) => MyService());
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  Future<Null> showAlert(String title, String msg) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}
